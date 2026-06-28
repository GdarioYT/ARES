#ifndef __ARES_INTELLIGENCEEVALUATOR_MQH__
#define __ARES_INTELLIGENCEEVALUATOR_MQH__

#include "IntelligenceContext.mqh"

enum EIntelligenceGrade
{
   INTELLIGENCE_REJECT=0,
   INTELLIGENCE_ACCEPT,
   INTELLIGENCE_HIGH_CONFIDENCE
};

class CIntelligenceEvaluator
{
private:
   EIntelligenceGrade m_grade;

public:
   CIntelligenceEvaluator()
   {
      m_grade=INTELLIGENCE_REJECT;
   }

   EIntelligenceGrade Evaluate(const SIntelligenceContext &ctx)
   {
      if(!ctx.valid)
      {
         m_grade=INTELLIGENCE_REJECT;
         return m_grade;
      }

      if(ctx.confidence>=0.85)
         m_grade=INTELLIGENCE_HIGH_CONFIDENCE;
      else if(ctx.confidence>=0.70)
         m_grade=INTELLIGENCE_ACCEPT;
      else
         m_grade=INTELLIGENCE_REJECT;

      return m_grade;
   }

   EIntelligenceGrade Grade() const
   {
      return m_grade;
   }
};

#endif
