#ifndef __ARES_SWINGDETECTOR_MQH__
#define __ARES_SWINGDETECTOR_MQH__

#include "../Data/DataEngine.mqh"

enum ESwingType
{
   SWING_NONE=0,
   SWING_HIGH,
   SWING_LOW
};

// ============================================================================
// ARES - SwingDetector_v2.mqh
// Detecta swings de mercado con ventana configurable.
// FIX: Ventana mínima de 5 velas (2 izquierda + pivot + 2 derecha) para
// reducir el ruido de micro-swings en real ticks. El swing de 3 velas
// generaba ~3900 BOS en 8 días. Con 5 velas se espera reducir ~80%.
// ============================================================================
class CSwingDetector
{
private:
   CDataEngine *m_engine;
   double       m_lastHigh;
   double       m_lastLow;
   int          m_lookback; // Velas a cada lado del pivot (mínimo 2)

public:
   CSwingDetector()
   {
      m_engine   = NULL;
      m_lastHigh = 0.0;
      m_lastLow  = 0.0;
      m_lookback = 2; // Por defecto: 2 velas cada lado = ventana de 5
   }

   bool Initialize(CDataEngine &engine, const int lookback = 2)
   {
      m_engine   = &engine;
      m_lastHigh = 0.0;
      m_lastLow  = 0.0;
      m_lookback = MathMax(lookback, 2); // Mínimo 2
      return true;
   }

   ESwingType Detect(const int index)
   {
      if(m_engine == NULL || m_engine.Bars() < index + (m_lookback * 2) + 1)
         return SWING_NONE;

      // El pivot es la vela en (index + lookback)
      int pivot = index + m_lookback;

      SCandle cPivot;
      if(!m_engine.Get(pivot, cPivot)) return SWING_NONE;

      bool isSwingHigh = true;
      bool isSwingLow  = true;

      // Verificar que el pivot supera a todas las velas en la ventana
      for(int i = 0; i < m_lookback && (isSwingHigh || isSwingLow); i++)
      {
         SCandle cLeft, cRight;
         if(!m_engine.Get(pivot - (i + 1), cLeft))  { isSwingHigh = false; isSwingLow = false; break; }
         if(!m_engine.Get(pivot + (i + 1), cRight)) { isSwingHigh = false; isSwingLow = false; break; }

         if(cLeft.High  >= cPivot.High || cRight.High >= cPivot.High) isSwingHigh = false;
         if(cLeft.Low   <= cPivot.Low  || cRight.Low  <= cPivot.Low)  isSwingLow  = false;
      }

      if(isSwingHigh)
      {
         m_lastHigh = cPivot.High;
         return SWING_HIGH;
      }

      if(isSwingLow)
      {
         m_lastLow = cPivot.Low;
         return SWING_LOW;
      }

      return SWING_NONE;
   }

   double LastSwingHigh() const { return m_lastHigh; }
   double LastSwingLow()  const { return m_lastLow;  }
};

#endif
