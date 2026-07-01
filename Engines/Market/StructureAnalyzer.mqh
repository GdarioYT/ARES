#ifndef __ARES_STRUCTUREANALYZER_MQH__
#define __ARES_STRUCTUREANALYZER_MQH__

#include "StructureState.mqh"
#include "SwingDetector_v2.mqh"

// ============================================================================
// ARES - StructureAnalyzer.mqh
// Detecta y clasifica la estructura de mercado (HH / HL / LH / LL).
// Usa EMarketStructure (de StructureState.mqh) como tipo canónico para que
// no haya conflicto de identificadores en el espacio de nombres global MQL5.
// ============================================================================

class CStructureAnalyzer
{
private:
   CSwingDetector   m_swing;
   double           m_lastHigh;
   double           m_prevHigh;
   double           m_lastLow;
   double           m_prevLow;
   EMarketStructure m_lastStructure;

public:
   CStructureAnalyzer()
   {
      Reset();
   }

   bool Initialize(CDataEngine &data, const int swingLookback = 2)
   {
      Reset();
      return m_swing.Initialize(data, swingLookback);
   }

   void Reset()
   {
      m_lastHigh      = 0.0;
      m_prevHigh      = 0.0;
      m_lastLow       = 0.0;
      m_prevLow       = 0.0;
      m_lastStructure = STRUCTURE_UNDEFINED;
   }

   // Analiza el bar en 'index' buscando un swing point.
   // Devuelve true si se registró un nuevo HH/HL/LH/LL.
   bool Analyze(const int index)
   {
      ESwingType swing = m_swing.Detect(index);

      if(swing == SWING_HIGH)
      {
         RegisterHigh(m_swing.LastSwingHigh());
         return true;
      }

      if(swing == SWING_LOW)
      {
         RegisterLow(m_swing.LastSwingLow());
         return true;
      }

      return false;
   }

   void RegisterHigh(const double price)
   {
      m_prevHigh = m_lastHigh;
      m_lastHigh = price;

      if(m_prevHigh != 0.0)
         m_lastStructure = (m_lastHigh > m_prevHigh) ? STRUCTURE_HH : STRUCTURE_LH;
   }

   void RegisterLow(const double price)
   {
      m_prevLow = m_lastLow;
      m_lastLow = price;

      if(m_prevLow != 0.0)
         m_lastStructure = (m_lastLow > m_prevLow) ? STRUCTURE_HL : STRUCTURE_LL;
   }

   EMarketStructure LastStructure() const { return m_lastStructure; }

   double LastHigh()     const { return m_lastHigh; }
   double PreviousHigh() const { return m_prevHigh; }
   double LastLow()      const { return m_lastLow; }
   double PreviousLow()  const { return m_prevLow; }

   bool IsHH() const { return m_lastStructure == STRUCTURE_HH; }
   bool IsHL() const { return m_lastStructure == STRUCTURE_HL; }
   bool IsLH() const { return m_lastStructure == STRUCTURE_LH; }
   bool IsLL() const { return m_lastStructure == STRUCTURE_LL; }
};

#endif
