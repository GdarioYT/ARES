#ifndef __ARES_TRADEPIPELINE_MQH__
#define __ARES_TRADEPIPELINE_MQH__

#include "TradeExecutor.mqh"
#include "../Execution/ExecutionEngine.mqh"

class CTradePipeline
{
private:
   CTradeExecutor *m_executor;
   CExecutionEngine *m_execution;

public:
   CTradePipeline()
   {
      m_executor=NULL;
      m_execution=NULL;
   }

   bool Initialize(CTradeExecutor &executor,
                   CExecutionEngine &execution)
   {
      m_executor=&executor;
      m_execution=&execution;
      return true;
   }

   bool Process(const STradePlan &plan,
                SExecutionContext &context)
   {
      if(m_executor==NULL || m_execution==NULL)
         return false;

      if(!m_executor->Prepare(plan,context))
         return false;

      return m_execution->CanExecute(context);
   }
};

#endif
