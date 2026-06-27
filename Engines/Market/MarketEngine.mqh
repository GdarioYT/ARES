#ifndef __ARES_MARKETENGINE_MQH__
#define __ARES_MARKETENGINE_MQH__

#include "../Data/MarketDataFeed.mqh"

class CMarketEngine
{
private:
   CMarketDataFeed m_feed;
   bool            m_ready;

public:
   CMarketEngine()
   {
      m_ready=false;
   }

   bool Initialize(CDataEngine &engine,const int cacheSize=5000)
   {
      m_ready=m_feed.Initialize(engine,cacheSize);
      return m_ready;
   }

   bool Update(const string symbol,const ENUM_TIMEFRAMES timeframe)
   {
      if(!m_ready)
         return(false);

      return m_feed.Refresh(symbol,timeframe);
   }

   int CachedBars() const
   {
      return m_feed.CachedBars();
   }
};

#endif
