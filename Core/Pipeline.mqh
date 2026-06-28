#ifndef __ARES_PIPELINE_MQH__
#define __ARES_PIPELINE_MQH__

#include "EngineManager.mqh"

class CPipeline
{
private:
   CEngineManager *m_manager;

public:
   CPipeline()
   {
      m_manager=NULL;
   }

   bool Initialize(CEngineManager &manager)
   {
      m_manager=&manager;
      return true;
   }

   bool Execute()
   {
      if(m_manager == NULL) return false;

      // Update MarketEngine with the latest closed candle
      m_manager.Market().Update(1);

      // Log BOS
      if(m_manager.Market().BOS().IsBullishBOS()) {
         Print("[ARES] Bullish BOS Detected!");
      } else if(m_manager.Market().BOS().IsBearishBOS()) {
         Print("[ARES] Bearish BOS Detected!");
      }

      // Log CHOCH
      if(m_manager.Market().CHOCH().IsBullishCHOCH()) {
         Print("[ARES] Bullish CHOCH Detected!");
      } else if(m_manager.Market().CHOCH().IsBearishCHOCH()) {
         Print("[ARES] Bearish CHOCH Detected!");
      }

      // Run Pattern Engine
      SPatternContext pContext;
      SMarketSnapshot snapshot = {};
      pContext.FromMarket(snapshot);
      pContext.valid = true; // Force validation for testing data flow
      pContext.score = 1.0;

      SPatternResult pResult;
      m_manager.Pattern().Analyze(pContext, pResult);

      if(pResult.detected) {
         string pName = "";
         if(pResult.pattern == PATTERN_TYPE_FVG) pName = "FVG";
         else if(pResult.pattern == PATTERN_TYPE_OB) pName = "Order Block";

         if(pName != "") {
             string dir = "Unknown";
             if (pResult.direction == PATTERN_LONG) dir = "Bullish";
             if (pResult.direction == PATTERN_SHORT) dir = "Bearish";
             Print("[ARES] ", dir, " ", pName, " Detected at ", DoubleToString(pResult.priceBottom, 5), " - ", DoubleToString(pResult.priceTop, 5));
         }
      }

      return true;
   }
};

#endif
