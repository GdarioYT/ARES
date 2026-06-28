#ifndef __ARES_MARKETCONTEXT_MQH__
#define __ARES_MARKETCONTEXT_MQH__

#include "StructureAnalyzer.mqh"
#include "TrendDetector.mqh"
#include "LiquidityDetector.mqh"

struct SMarketContext
{
   EStructureClass structure;
   ETrendState trend;
   ELiquidityEvent liquidity;

   bool bullishBOS;
   bool bearishBOS;

   bool bullishCHOCH;
   bool bearishCHOCH;

   double confidence;
   datetime timestamp;

   void Reset()
   {
      structure=STRUCTURE_UNKNOWN;
      trend=TREND_UNKNOWN;
      liquidity=LIQUIDITY_NONE;

      bullishBOS=false;
      bearishBOS=false;
      bullishCHOCH=false;
      bearishCHOCH=false;

      confidence=0.0;
      timestamp=0;
   }
};

#endif
