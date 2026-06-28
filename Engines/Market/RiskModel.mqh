#ifndef __ARES_RISKMODEL_MQH__
#define __ARES_RISKMODEL_MQH__

#include "EntryEngine.mqh"

struct SRiskProfile
{
   double riskPercent;
   double positionSize;
   double stopDistance;
   bool valid;

   void Reset()
   {
      riskPercent = 0.0;
      positionSize = 0.0;
      stopDistance = 0.0;
      valid = false;
   }
};

class CRiskModel
{
private:
   SRiskProfile m_profile;

public:
   CRiskModel()
   {
      m_profile.Reset();
   }

   bool Evaluate(const SEntrySignal &signal,
                 const double accountBalance,
                 const double stopDistancePoints,
                 const double riskPercent)
   {
      m_profile.Reset();

      if(!signal.valid || accountBalance<=0.0 || stopDistancePoints<=0.0 || riskPercent<=0.0)
         return false;

      m_profile.riskPercent = riskPercent;
      m_profile.stopDistance = stopDistancePoints;
      m_profile.positionSize = (accountBalance * riskPercent) / stopDistancePoints;
      m_profile.valid = true;

      return true;
   }

   const SRiskProfile &Profile() const
   {
      return m_profile;
   }
};

#endif
