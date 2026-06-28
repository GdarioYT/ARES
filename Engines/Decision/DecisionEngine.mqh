#ifndef __ARES_DECISIONENGINE_MQH__
#define __ARES_DECISIONENGINE_MQH__

#include "DecisionContext.mqh"

class CDecisionEngine
{
public:
   bool Evaluate(const SDecisionContext &context)
   {
      return context.action!=DECISION_NONE;
   }

   bool IsBuy(const SDecisionContext &context) const
   {
      return context.action==DECISION_BUY;
   }

   bool IsSell(const SDecisionContext &context) const
   {
      return context.action==DECISION_SELL;
   }
};

#endif
