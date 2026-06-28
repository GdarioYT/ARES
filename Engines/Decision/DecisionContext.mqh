#ifndef __ARES_DECISIONCONTEXT_MQH__
#define __ARES_DECISIONCONTEXT_MQH__

#include "../Intelligence/IntelligenceContext.mqh"
#include "../Intelligence/IntelligenceEvaluator.mqh"

enum EDecisionAction
{
   DECISION_NONE=0,
   DECISION_BUY,
   DECISION_SELL
};

struct SDecisionContext
{
   SIntelligenceContext intelligence;
   EIntelligenceGrade grade;
   EDecisionAction action;

   // Execution specifics
   double entryPrice;
   double stopLoss;
   double takeProfit;
   double lotSize;
   double riskRewardRatio;

   void Reset()
   {
      intelligence.Reset();
      grade=INTELLIGENCE_REJECT;
      action=DECISION_NONE;
      entryPrice = 0.0;
      stopLoss = 0.0;
      takeProfit = 0.0;
      lotSize = 0.0;
      riskRewardRatio = 0.0;
   }

   void Update(const SIntelligenceContext &ctx,
               EIntelligenceGrade g)
   {
      intelligence=ctx;
      grade=g;

      if(g==INTELLIGENCE_REJECT)
         action=DECISION_NONE;
      else if(ctx.pattern.direction==PATTERN_LONG)
         action=DECISION_BUY;
      else if(ctx.pattern.direction==PATTERN_SHORT)
         action=DECISION_SELL;
      else
         action=DECISION_NONE;
   }
};

#endif
