#ifndef __ARES_DATACACHE_MQH__
#define __ARES_DATACACHE_MQH__

#include "../../Core/Types.mqh"

class CDataCache
{
private:
   MqlRates m_rates[];
   int      m_capacity;

public:
   CDataCache()
   {
      m_capacity=0;
   }

   bool Initialize(const int capacity)
   {
      m_capacity=capacity;
      ArrayResize(m_rates,0);
      ArraySetAsSeries(m_rates,true);
      return(true);
   }

   bool Update(const string symbol,const ENUM_TIMEFRAMES timeframe)
   {
      if(m_capacity<=0)
         return(false);

      int copied=CopyRates(symbol,timeframe,0,m_capacity,m_rates);
      return(copied>0);
   }

   int Count() const
   {
      return(ArraySize(m_rates));
   }

   bool Get(const int index,MqlRates &rate) const
   {
      if(index<0 || index>=ArraySize(m_rates))
         return(false);

      rate=m_rates[index];
      return(true);
   }

   void Clear()
   {
      ArrayResize(m_rates,0);
   }
};

#endif
