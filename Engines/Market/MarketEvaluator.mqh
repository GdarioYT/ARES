#ifndef __ARES_MARKETEVALUATOR_MQH__
#define __ARES_MARKETEVALUATOR_MQH__

#include "MarketSnapshot.mqh"

class CMarketEvaluator
{
public:
   static bool IsTradeAllowed(const SMarketSnapshot &snapshot)
   {
      if(!snapshot.IsValid())
         return false;

      return snapshot.confidence>=0.50;
   }

   static bool IsBullish(const SMarketSnapshot &snapshot)
   {
      return snapshot.bias==MARKET_BIAS_BULLISH;
   }

   static bool IsBearish(const SMarketSnapshot &snapshot)
   {
      return snapshot.bias==MARKET_BIAS_BEARISH;
   }
};

#endif
