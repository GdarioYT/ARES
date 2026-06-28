#ifndef __ARES_EQUALHIGHEQUALLOWDETECTOR_MQH__
#define __ARES_EQUALHIGHEQUALLOWDETECTOR_MQH__

#include "StructureAnalyzer.mqh"

// ============================================================================
// ARES - EqualHighEqualLowDetector.mqh
// Detecta Equal Highs (EQH) o Equal Lows (EQL) comparando los dos últimos
// swings estructurales registrados.
// ============================================================================

enum EEqualLevelType
{
   EQUAL_NONE=0,
   EQUAL_HIGHS,
   EQUAL_LOWS
};

struct SEqualLevel
{
   EEqualLevelType type;
   double level;
   bool valid;

   void Reset()
   {
      type=EQUAL_NONE;
      level=0.0;
      valid=false;
   }
};

class CEqualHighEqualLowDetector
{
private:
   SEqualLevel m_last;
   double m_tolerance;

public:
   CEqualHighEqualLowDetector()
   {
      m_last.Reset();
      // Tolerancia por defecto para considerar niveles "iguales"
      m_tolerance = 0.00020; 
   }

   void SetTolerance(const double tolerance)
   {
      m_tolerance = tolerance;
   }

   bool Analyze(const CStructureAnalyzer &structure)
   {
      m_last.Reset();

      double lastH = structure.LastHigh();
      double prevH = structure.PreviousHigh();
      double lastL = structure.LastLow();
      double prevL = structure.PreviousLow();

      // Check Equal Highs
      if(lastH > 0 && prevH > 0 && MathAbs(lastH - prevH) <= m_tolerance)
      {
         m_last.type = EQUAL_HIGHS;
         m_last.level = MathMax(lastH, prevH);
         m_last.valid = true;
         return true;
      }

      // Check Equal Lows
      if(lastL > 0 && prevL > 0 && MathAbs(lastL - prevL) <= m_tolerance)
      {
         m_last.type = EQUAL_LOWS;
         m_last.level = MathMin(lastL, prevL);
         m_last.valid = true;
         return true;
      }

      return false;
   }

   const SEqualLevel &Last() const { return m_last; }
   bool HasEqualLevel() const { return m_last.valid; }
};

#endif
