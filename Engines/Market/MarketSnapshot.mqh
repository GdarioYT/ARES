#ifndef __ARES_MARKETSNAPSHOT_MQH__
#define __ARES_MARKETSNAPSHOT_MQH__

#include "MarketState.mqh"

struct SMarketSnapshot
{
   SMarketState State;
   datetime     Timestamp;
   double       LastPrice;

   SMarketSnapshot()
   {
      Timestamp=0;
      LastPrice=0.0;
   }
};

class CMarketSnapshotBuilder
{
public:
   static void Build(const SMarketState &state,
                     const datetime timestamp,
                     const double lastPrice,
                     SMarketSnapshot &snapshot)
   {
      snapshot.State=state;
      snapshot.Timestamp=timestamp;
      snapshot.LastPrice=lastPrice;
   }
};

#endif
