#ifndef __ARES_AUDITCONTEXT_MQH__
#define __ARES_AUDITCONTEXT_MQH__

#include "../Learning/LearningContext.mqh"

struct SAuditContext
{
   SLearningContext learning;

   datetime timestamp;
   bool success;
   double pnl;

   void Reset()
   {
      learning.Reset();
      timestamp=0;
      success=false;
      pnl=0.0;
   }

   void FromLearning(const SLearningContext &ctx)
   {
      learning=ctx;
      timestamp=TimeCurrent();
      success=ctx.completed;
      pnl=ctx.pnl;
   }
};

#endif
