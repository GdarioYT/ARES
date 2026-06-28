#ifndef __ARES_TRADECOORDINATOR_MQH__
#define __ARES_TRADECOORDINATOR_MQH__

#include "TradeSetup.mqh"
#include "RiskModel.mqh"
#include "PositionSizer.mqh"
#include "TradePlan.mqh"
#include "TradeValidator.mqh"
#include "TradePipeline.mqh"

class CTradeCoordinator
{
private:
   CPositionSizer   m_sizer;
   CTradeValidator  m_validator;
   CTradePipeline  *m_pipeline;

public:
   CTradeCoordinator()
   {
      m_pipeline=NULL;
   }

   bool Initialize(CTradePipeline &pipeline)
   {
      m_pipeline=&pipeline;
      return true;
   }

   bool Execute(const SEntrySignal &signal,
                const SRiskProfile &risk,
                double entry,
                double stop,
                double target,
                SExecutionContext &execution)
   {
      if(m_pipeline==NULL)
         return false;

      CTradePlan builder;
      double volume=m_sizer.Calculate(risk);

      if(!builder.Build(signal,risk,entry,stop,target,volume))
         return false;

      if(!m_validator.Validate(builder.Plan()))
         return false;

      return m_pipeline->Process(builder.Plan(),execution);
   }
};

#endif
