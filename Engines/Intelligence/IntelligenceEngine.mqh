#ifndef __ARES_INTELLIGENCEENGINE_MQH__
#define __ARES_INTELLIGENCEENGINE_MQH__

#include "IntelligenceContext.mqh"
#include "IntelligenceEvaluator.mqh"

class CIntelligenceEngine
{
private:
   CIntelligenceEvaluator m_evaluator;

public:
   bool Analyze(const SIntelligenceContext &context,
                EIntelligenceGrade &grade)
   {
      grade=m_evaluator.Evaluate(context);
      return grade!=INTELLIGENCE_REJECT;
   }

   const CIntelligenceEvaluator *Evaluator() const
   {
      return &m_evaluator;
   }
};

#endif
