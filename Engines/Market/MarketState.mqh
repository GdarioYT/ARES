#ifndef __ARES_MARKETSTATE_MQH__
#define __ARES_MARKETSTATE_MQH__

#include "StructureSignal.mqh"

enum EMarketBias
{
   MARKET_NEUTRAL=0,
   MARKET_BULLISH,
   MARKET_BEARISH
};

struct SMarketState
{
   EMarketBias Bias;
   bool ValidStructure;
   bool Breakout;

   SMarketState()
   {
      Bias=MARKET_NEUTRAL;
      ValidStructure=false;
      Breakout=false;
   }
};

class CMarketStateBuilder
{
public:
   static void Build(const SStructureSignal &signal,SMarketState &state)
   {
      state=SMarketState();

      if(signal.Bias==BIAS_BULLISH)
         state.Bias=MARKET_BULLISH;
      else if(signal.Bias==BIAS_BEARISH)
         state.Bias=MARKET_BEARISH;

      state.ValidStructure=(signal.Bias!=BIAS_NEUTRAL);
      state.Breakout=signal.HasBOS;
   }
};

#endif
