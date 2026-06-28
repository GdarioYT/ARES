#ifndef __ARES_MARKETSTATE_MQH__
#define __ARES_MARKETSTATE_MQH__

#include "MarketContext.mqh"

enum EMarketBias
{
   MARKET_BIAS_NEUTRAL = 0,
   MARKET_BIAS_BULLISH,
   MARKET_BIAS_BEARISH
};

class CMarketState
{
private:
   SMarketContext m_context;
   EMarketBias    m_bias;

public:
   CMarketState()
   {
      Reset();
   }

   void Reset()
   {
      m_context.Reset();
      m_bias = MARKET_BIAS_NEUTRAL;
   }

   void Update(const SMarketContext &context)
   {
      m_context = context;

      if(context.bullishBOS || context.bullishCHOCH)
         m_bias = MARKET_BIAS_BULLISH;
      else if(context.bearishBOS || context.bearishCHOCH)
         m_bias = MARKET_BIAS_BEARISH;
      else
         m_bias = MARKET_BIAS_NEUTRAL;
   }

   const SMarketContext &Context() const
   {
      return m_context;
   }

   EMarketBias Bias() const
   {
      return m_bias;
   }

   bool IsBullish() const
   {
      return m_bias == MARKET_BIAS_BULLISH;
   }

   bool IsBearish() const
   {
      return m_bias == MARKET_BIAS_BEARISH;
   }

   bool IsNeutral() const
   {
      return m_bias == MARKET_BIAS_NEUTRAL;
   }
};

#endif
