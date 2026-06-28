#ifndef __ARES_MARKETFILTER_MQH__
#define __ARES_MARKETFILTER_MQH__

#include "MarketEvaluator.mqh"

class CMarketFilter
{
private:
   double m_minConfidence;

public:
   CMarketFilter()
   {
      m_minConfidence=0.60;
   }

   void SetMinimumConfidence(const double value)
   {
      m_minConfidence=value;
   }

   bool Accept(const SMarketSnapshot &snapshot) const
   {
      if(!CMarketEvaluator::IsTradeAllowed(snapshot))
         return false;

      return snapshot.confidence>=m_minConfidence;
   }
};

#endif
