#ifndef __ARES_TRADEVALIDATOR_MQH__
#define __ARES_TRADEVALIDATOR_MQH__

#include "TradePlan.mqh"

class CTradeValidator
{
private:
   double m_minConfidence;
   double m_maxRisk;

public:
   CTradeValidator()
   {
      m_minConfidence = 0.75;
      m_maxRisk = 0.02;
   }

   void Configure(const double minConfidence,
                  const double maxRisk)
   {
      m_minConfidence = minConfidence;
      m_maxRisk = maxRisk;
   }

   bool Validate(const STradePlan &plan) const
   {
      if(!plan.valid)
         return false;

      if(plan.confidence < m_minConfidence)
         return false;

      if(plan.riskPercent > m_maxRisk)
         return false;

      if(plan.volume <= 0.0)
         return false;

      if(plan.entryPrice <= 0.0)
         return false;

      if(plan.stopLoss <= 0.0)
         return false;

      if(plan.takeProfit <= 0.0)
         return false;

      return true;
   }
};

#endif
