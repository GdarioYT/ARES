#ifndef __ARES_PREMIUMDISCOUNTDETECTOR_MQH__
#define __ARES_PREMIUMDISCOUNTDETECTOR_MQH__

#include "StructureAnalyzer.mqh"

enum EPremiumDiscountZone
{
   PD_ZONE_UNDEFINED = 0,
   PD_ZONE_PREMIUM,
   PD_ZONE_DISCOUNT,
   PD_ZONE_EQUILIBRIUM
};

class CPremiumDiscountDetector
{
private:
   EPremiumDiscountZone m_currentZone;
   double m_equilibriumLevel;

public:
   CPremiumDiscountDetector()
   {
      m_currentZone = PD_ZONE_UNDEFINED;
      m_equilibriumLevel = 0.0;
   }

   bool Analyze(const CStructureAnalyzer &structure, double currentPrice)
   {
      m_currentZone = PD_ZONE_UNDEFINED;
      m_equilibriumLevel = 0.0;

      double high = structure.LastHigh();
      double low = structure.LastLow();

      if(high == 0.0 || low == 0.0 || high <= low)
         return false;

      m_equilibriumLevel = low + (high - low) * 0.5;

      if(currentPrice > m_equilibriumLevel)
         m_currentZone = PD_ZONE_PREMIUM;
      else if(currentPrice < m_equilibriumLevel)
         m_currentZone = PD_ZONE_DISCOUNT;
      else
         m_currentZone = PD_ZONE_EQUILIBRIUM;

      return true;
   }

   EPremiumDiscountZone CurrentZone() const { return m_currentZone; }
   double EquilibriumLevel() const { return m_equilibriumLevel; }
   
   bool IsPremium() const { return m_currentZone == PD_ZONE_PREMIUM; }
   bool IsDiscount() const { return m_currentZone == PD_ZONE_DISCOUNT; }
};

#endif
