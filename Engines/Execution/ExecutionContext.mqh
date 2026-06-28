#ifndef __ARES_EXECUTIONCONTEXT_MQH__
#define __ARES_EXECUTIONCONTEXT_MQH__

#include "../PortFolio/PortfolioContext.mqh"
#include "../Decision/DecisionContext.mqh"

struct SExecutionContext
{
   SPortfolioContext portfolio;
   SDecisionContext decision;

   bool execute;
   double volume;
   double stopLoss;
   double takeProfit;

   void Reset()
   {
      portfolio.Reset();
      decision.Reset();
      execute=false;
      volume=0.0;
      stopLoss=0.0;
      takeProfit=0.0;
   }
};

#endif
