#ifndef __ARES_LEARNINGCONTEXT_MQH__
#define __ARES_LEARNINGCONTEXT_MQH__

#include "../Execution/ExecutionReport.mqh"

struct SLearningContext
{
   SExecutionReport execution;

   bool completed;
   double pnl;
   double confidence;

   void Reset()
   {
      execution.Reset();
      completed=false;
      pnl=0.0;
      confidence=0.0;
   }

   void FromExecution(const SExecutionReport &report)
   {
      execution=report;
      completed=(report.status==EXECUTION_SENT);
      confidence=1.0;
   }
};

#endif
