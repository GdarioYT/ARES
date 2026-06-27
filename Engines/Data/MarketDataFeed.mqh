#ifndef __ARES_MARKETDATAFEED_MQH__
#define __ARES_MARKETDATAFEED_MQH__

#include "../../Core/Types.mqh"
#include "HistoryLoader.mqh"
#include "DataCache.mqh"
#include "DataValidator.mqh"
#include "SessionManager.mqh"
#include "DataEngine.mqh"

class CMarketDataFeed
{
private:
   CHistoryLoader  m_loader;
   CDataCache      m_cache;
   CDataValidator  m_validator;
   CSessionManager m_session;
   CDataEngine    *m_engine;

public:
   CMarketDataFeed()
   {
      m_engine=NULL;
   }

   bool Initialize(CDataEngine &engine,const int cacheSize=5000)
   {
      m_engine=&engine;
      return m_cache.Initialize(cacheSize);
   }

   bool Refresh(const string symbol,const ENUM_TIMEFRAMES timeframe)
   {
      if(m_engine==NULL)
         return(false);

      if(!m_session.IsMarketOpen())
         return(false);

      return m_cache.Update(symbol,timeframe);
   }

   int CachedBars() const
   {
      return m_cache.Count();
   }
};

#endif
