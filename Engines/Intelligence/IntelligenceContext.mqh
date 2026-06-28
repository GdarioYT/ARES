#ifndef __ARES_INTELLIGENCECONTEXT_MQH__
#define __ARES_INTELLIGENCECONTEXT_MQH__

#include "../Pattern/PatternResult.mqh"

struct SIntelligenceContext
{
   SPatternResult pattern;

   bool valid;
   double confidence;

   void Reset()
   {
      pattern.Reset();
      valid=false;
      confidence=0.0;
   }

   void FromPattern(const SPatternResult &result)
   {
      pattern=result;
      valid=result.detected;
      confidence=result.score;
   }
};

#endif
