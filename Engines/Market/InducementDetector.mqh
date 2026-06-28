#ifndef __ARES_INDUCEMENTDETECTOR_MQH__
#define __ARES_INDUCEMENTDETECTOR_MQH__

#include "StructureAnalyzer.mqh"

// ============================================================================
// ARES - InducementDetector.mqh
// Detects if a minor swing exists between the current price and a POI (like OB),
// acting as Inducement (liquidity trap) before the real move.
// ============================================================================

class CInducementDetector
{
private:
   bool m_inducementPresent;
   double m_inducementLevel;

public:
   CInducementDetector()
   {
      m_inducementPresent = false;
      m_inducementLevel = 0.0;
   }

   bool AnalyzeBullish(const CStructureAnalyzer &structure, double currentPrice, double orderBlockTop)
   {
      m_inducementPresent = false;
      m_inducementLevel = 0.0;
      
      double lastLow = structure.LastLow();
      
      // If there is a recent minor low between the current price and the OB top
      if(lastLow > orderBlockTop && lastLow < currentPrice)
      {
         m_inducementPresent = true;
         m_inducementLevel = lastLow;
         return true;
      }
      return false;
   }

   bool AnalyzeBearish(const CStructureAnalyzer &structure, double currentPrice, double orderBlockBottom)
   {
      m_inducementPresent = false;
      m_inducementLevel = 0.0;
      
      double lastHigh = structure.LastHigh();
      
      // If there is a recent minor high between the current price and the OB bottom
      if(lastHigh < orderBlockBottom && lastHigh > currentPrice)
      {
         m_inducementPresent = true;
         m_inducementLevel = lastHigh;
         return true;
      }
      return false;
   }

   bool HasInducement() const { return m_inducementPresent; }
   double InducementLevel() const { return m_inducementLevel; }
};

#endif
