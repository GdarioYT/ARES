#ifndef __ARES_GUARDIANCONTEXT_MQH__
#define __ARES_GUARDIANCONTEXT_MQH__

#include "../Decision/DecisionContext.mqh"

enum EGuardianStatus
{
   GUARDIAN_ALLOW=0,
   GUARDIAN_BLOCK,
   GUARDIAN_PAUSE
};

struct SGuardianContext
{
   SDecisionContext decision;
   EGuardianStatus status;
   double riskScore;

   void Reset()
   {
      decision.Reset();
      status=GUARDIAN_ALLOW;
      riskScore=0.0;
   }

   void Update(const SDecisionContext &ctx)
   {
      decision=ctx;
      riskScore=0.0;
      status=GUARDIAN_ALLOW;
   }
};

#endif
