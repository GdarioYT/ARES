#ifndef __ARES_EXECUTIONREPORT_MQH__
#define __ARES_EXECUTIONREPORT_MQH__

#include "ExecutionContext.mqh"

enum EExecutionStatus
{
   EXECUTION_PENDING=0,
   EXECUTION_READY,
   EXECUTION_SENT,
   EXECUTION_REJECTED
};

struct SExecutionReport
{
   EExecutionStatus status;
   datetime timestamp;
   double volume;
   double stopLoss;
   double takeProfit;

   void Reset()
   {
      status=EXECUTION_PENDING;
      timestamp=0;
      volume=0.0;
      stopLoss=0.0;
      takeProfit=0.0;
   }

   void FromContext(const SExecutionContext &ctx)
   {
      volume=ctx.volume;
      stopLoss=ctx.stopLoss;
      takeProfit=ctx.takeProfit;
      timestamp=TimeCurrent();
      status=ctx.execute?EXECUTION_READY:EXECUTION_REJECTED;
   }
};

#endif
