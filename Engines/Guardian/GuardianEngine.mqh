#ifndef __ARES_GUARDIANENGINE_MQH__
#define __ARES_GUARDIANENGINE_MQH__

#include "GuardianContext.mqh"
#include "GuardianRules.mqh"

class CGuardianEngine
{
private:
   CGuardianRules m_rules;

public:
   bool Evaluate(SGuardianContext &context)
   {
      return m_rules.Evaluate(context);
   }

   void SetMaximumRisk(const double value)
   {
      m_rules.SetMaxRisk(value);
   }
};

#endif
