#ifndef __ARES_EXECUTIONCONTEXT_MQH__
#define __ARES_EXECUTIONCONTEXT_MQH__

#include "../Decision/DecisionContext.mqh"

//+------------------------------------------------------------------+
//| SExecutionContext                                                  |
//| Contexto de ejecución — contiene la decisión lista para enviar   |
//| al broker. Generado por Pipeline después de pasar Guardian.      |
//+------------------------------------------------------------------+
struct SExecutionContext
{
   SDecisionContext decision;

   bool   execute;
   double volume;
   double stopLoss;
   double takeProfit;

   void Reset()
   {
      decision.Reset();
      execute   = false;
      volume    = 0.0;
      stopLoss  = 0.0;
      takeProfit= 0.0;
   }
};

#endif
