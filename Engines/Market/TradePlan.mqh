#ifndef __ARES_TRADEPLAN_MQH__
#define __ARES_TRADEPLAN_MQH__

#include "EntryEngine.mqh"
#include "RiskModel.mqh"

struct STradePlan
{
   ETradeSetupType type;

   double entryPrice;
   double stopLoss;
   double takeProfit;

   double volume;
   double riskPercent;

   double confidence;

   bool valid;

   void Reset()
   {
      type=SETUP_NONE;
      entryPrice=0.0;
      stopLoss=0.0;
      takeProfit=0.0;
      volume=0.0;
      riskPercent=0.0;
      confidence=0.0;
      valid=false;
   }
};

class CTradePlan
{
private:
   STradePlan m_plan;

public:
   CTradePlan()
   {
      m_plan.Reset();
   }

   bool Build(const SEntrySignal &signal,
              const SRiskProfile &risk,
              const double entry,
              const double stop,
              const double target,
              const double volume)
   {
      m_plan.Reset();

      if(!signal.valid || !risk.valid)
         return false;

      m_plan.type=signal.type;
      m_plan.entryPrice=entry;
      m_plan.stopLoss=stop;
      m_plan.takeProfit=target;
      m_plan.volume=volume;
      m_plan.riskPercent=risk.riskPercent;
      m_plan.confidence=signal.confidence;
      m_plan.valid=true;

      return true;
   }

   const STradePlan &Plan() const
   {
      return m_plan;
   }
};

#endif
