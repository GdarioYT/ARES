#ifndef __ARES_GUARDIANRULES_MQH__
#define __ARES_GUARDIANRULES_MQH__

#include "GuardianContext.mqh"

class CGuardianRules
{
private:
   double m_maxRisk;

public:
   CGuardianRules()
   {
      m_maxRisk=0.50;
   }

   void SetMaxRisk(const double value)
   {
      m_maxRisk=value;
   }

   bool Evaluate(SGuardianContext &context) const
   {
      if(context.riskScore>m_maxRisk)
      {
         context.status=GUARDIAN_BLOCK;
         return false;
      }

      context.status=GUARDIAN_ALLOW;
      return true;
   }
};

#endif
