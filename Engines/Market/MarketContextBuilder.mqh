#ifndef __ARES_MARKETCONTEXTBUILDER_MQH__
#define __ARES_MARKETCONTEXTBUILDER_MQH__

#include "MarketContext.mqh"
#include "StructureAnalyzer.mqh"
#include "BOSDetector.mqh"
#include "CHOCHDetector.mqh"
#include "TrendDetector.mqh"
#include "LiquidityDetector.mqh"

class CMarketContextBuilder
{
public:
   static void Build(SMarketContext &ctx,
                     CStructureAnalyzer &structure,
                     CBOSDetector &bos,
                     CCHOCHDetector &choch,
                     CTrendDetector &trend,
                     CLiquidityDetector &liquidity)
   {
      ctx.Reset();

      ctx.structure=structure.LastStructure();
      ctx.trend=trend.State();
      ctx.liquidity=liquidity.LastEvent();

      ctx.bullishBOS=bos.IsBullishBOS();
      ctx.bearishBOS=bos.IsBearishBOS();

      ctx.bullishCHOCH=choch.IsBullishCHOCH();
      ctx.bearishCHOCH=choch.IsBearishCHOCH();

      int score=0;
      if(ctx.bullishBOS||ctx.bearishBOS) score++;
      if(ctx.bullishCHOCH||ctx.bearishCHOCH) score++;
      if(ctx.liquidity!=LIQUIDITY_NONE) score++;
      if(ctx.trend!=TREND_UNKNOWN) score++;

      ctx.confidence=score/4.0;
      ctx.timestamp=TimeCurrent();
   }
};

#endif
