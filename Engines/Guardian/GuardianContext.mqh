#ifndef __ARES_GUARDIANCONTEXT_MQH__
#define __ARES_GUARDIANCONTEXT_MQH__

#include "../Decision/DecisionContext.mqh"

enum EGuardianStatus
{
   GUARDIAN_ALLOW=0,
   GUARDIAN_BLOCK
};

struct SGuardianContext
{
   SDecisionContext decision;
   EGuardianStatus status;
   
   double dailyDrawdown;
   double maxDailyDrawdown;
   
   bool newsFilterActive;

   void Reset()
   {
      decision.Reset();
      status=GUARDIAN_ALLOW;
      dailyDrawdown=0.0;
      maxDailyDrawdown=0.0;
      newsFilterActive=false;
   }
};

#endif
