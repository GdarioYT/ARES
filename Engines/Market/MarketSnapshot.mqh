#ifndef __ARES_MARKETSNAPSHOT_MQH__
#define __ARES_MARKETSNAPSHOT_MQH__

#include "MarketState.mqh"

struct SMarketSnapshot
{
   datetime time;
   EMarketBias bias;
   ETrendState trend;
   EMarketStructure structure;
   ELiquidityEvent liquidity;
   double confidence;

   void FromState(const CMarketState &state)
   {
      const SMarketContext &ctx = state.Context();

      time = ctx.timestamp;
      bias = state.Bias();
      trend = ctx.trend;
      structure = ctx.structure;
      liquidity = ctx.liquidity;
      confidence = ctx.confidence;
   }

   bool IsValid() const
   {
      return time != 0;
   }
};

#endif
