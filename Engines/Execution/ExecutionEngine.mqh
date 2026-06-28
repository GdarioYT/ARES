#ifndef __ARES_EXECUTIONENGINE_MQH__
#define __ARES_EXECUTIONENGINE_MQH__

#include "ExecutionContext.mqh"

class CExecutionEngine
{
public:
   bool Prepare(SExecutionContext &context,
                const double volume,
                const double stopLoss,
                const double takeProfit)
   {
      if(context.decision.action==DECISION_NONE)
      {
         context.execute=false;
         return false;
      }

      context.volume=volume;
      context.stopLoss=stopLoss;
      context.takeProfit=takeProfit;
      context.execute=true;

      return true;
   }

   bool CanExecute(const SExecutionContext &context) const
   {
      return context.execute;
   }
};

#endif
