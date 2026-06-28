#ifndef __ARES_PATTERNCONTEXT_MQH__
#define __ARES_PATTERNCONTEXT_MQH__

#include "../Market/MarketSnapshot.mqh"

enum EPatternDirection
{
   PATTERN_NONE = 0,
   PATTERN_LONG,
   PATTERN_SHORT
};

struct SPatternContext
{
   SMarketSnapshot market;

   EPatternDirection direction;
   bool valid;
   double score;

   void Reset()
   {
      direction = PATTERN_NONE;
      valid = false;
      score = 0.0;
   }

   void FromMarket(const SMarketSnapshot &snapshot)
   {
      market = snapshot;

      valid = snapshot.IsValid();
      score = snapshot.confidence;

      if(snapshot.bias == MARKET_BIAS_BULLISH)
         direction = PATTERN_LONG;
      else if(snapshot.bias == MARKET_BIAS_BEARISH)
         direction = PATTERN_SHORT;
      else
         direction = PATTERN_NONE;
   }
};

#endif
