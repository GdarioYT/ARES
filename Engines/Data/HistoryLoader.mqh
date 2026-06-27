#ifndef __ARES_HISTORYLOADER_MQH__
#define __ARES_HISTORYLOADER_MQH__

#include "../../Core/Types.mqh"
#include "TimeframeData.mqh"

class CHistoryLoader
{
public:
   bool Load(const string symbol,
             const ENUM_TIMEFRAMES timeframe,
             const int bars,
             MqlRates &rates[])
   {
      ArraySetAsSeries(rates,true);
      int copied=CopyRates(symbol,timeframe,0,bars,rates);
      return(copied>0);
   }
};

#endif
