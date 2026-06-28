#ifndef __ARES_PORTFOLIOCONTEXT_MQH__
#define __ARES_PORTFOLIOCONTEXT_MQH__

#include "../Guardian/GuardianPolicy.mqh"

struct SPortfolioContext
{
   bool tradingEnabled;
   double equity;
   double balance;
   double exposure;

   void Reset()
   {
      tradingEnabled=false;
      equity=0.0;
      balance=0.0;
      exposure=0.0;
   }
};

#endif
