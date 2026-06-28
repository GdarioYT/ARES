#ifndef __ARES_PATTERNSCORE_MQH__
#define __ARES_PATTERNSCORE_MQH__

#include "PatternContext.mqh"

class CPatternScore
{
private:
   double m_score;

public:
   CPatternScore()
   {
      Reset();
   }

   void Reset()
   {
      m_score=0.0;
   }

   void Evaluate(const SPatternContext &context)
   {
      m_score=0.0;

      if(!context.valid)
         return;

      m_score=context.score;

      if(context.direction!=PATTERN_NONE)
         m_score+=0.10;

      if(m_score>1.0)
         m_score=1.0;
   }

   double Value() const
   {
      return m_score;
   }

   bool IsHighQuality() const
   {
      return m_score>=0.80;
   }
};

#endif
