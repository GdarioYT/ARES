#ifndef __ARES_ORDERBLOCKDETECTOR_MQH__
#define __ARES_ORDERBLOCKDETECTOR_MQH__

#include "../Data/DataEngine.mqh"
#include "MarketStructure.mqh"

enum EOrderBlockType
{
   ORDERBLOCK_NONE=0,
   ORDERBLOCK_BULLISH,
   ORDERBLOCK_BEARISH
};

struct SOrderBlock
{
   EOrderBlockType type;
   double high;
   double low;
   int index;
   bool valid;

   void Reset()
   {
      type=ORDERBLOCK_NONE;
      high=0.0;
      low=0.0;
      index=-1;
      valid=false;
   }
};

class COrderBlockDetector
{
private:
   SOrderBlock m_lastBlock;

public:
   COrderBlockDetector()
   {
      m_lastBlock.Reset();
   }

   bool Analyze(const MqlRates &candle,
                const EMarketPhase phase,
                const int index)
   {
      m_lastBlock.Reset();

      if(phase==MARKET_PHASE_MARKUP && candle.close<candle.open)
      {
         m_lastBlock.type=ORDERBLOCK_BULLISH;
      }
      else if(phase==MARKET_PHASE_MARKDOWN && candle.close>candle.open)
      {
         m_lastBlock.type=ORDERBLOCK_BEARISH;
      }
      else
      {
         return false;
      }

      m_lastBlock.high=candle.high;
      m_lastBlock.low=candle.low;
      m_lastBlock.index=index;
      m_lastBlock.valid=true;
      return true;
   }

   const SOrderBlock &LastBlock() const { return m_lastBlock; }
   bool HasOrderBlock() const { return m_lastBlock.valid; }
};

#endif
