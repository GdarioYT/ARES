#ifndef __ARES_TRADEEXECUTOR_MQH__
#define __ARES_TRADEEXECUTOR_MQH__

#include "TradePlan.mqh"
#include "../Execution/ExecutionContext.mqh"

class CTradeExecutor
{
public:
   bool Prepare(const STradePlan &plan,
                SExecutionContext &execution)
   {
      execution.execute = false;

      if(!plan.valid)
         return false;

      execution.volume     = plan.volume;
      execution.stopLoss   = plan.stopLoss;
      execution.takeProfit = plan.takeProfit;
      execution.execute    = true;

      return true;
   }

   bool CanExecute(const SExecutionContext &execution) const
   {
      return execution.execute;
   }
};

#endif
