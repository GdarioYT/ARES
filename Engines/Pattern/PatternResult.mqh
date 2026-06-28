#ifndef __ARES_PATTERNRESULT_MQH__
#define __ARES_PATTERNRESULT_MQH__

#include "PatternContext.mqh"

enum EPatternStrength
{
   PATTERN_STRENGTH_NONE = 0,
   PATTERN_STRENGTH_WEAK,
   PATTERN_STRENGTH_MEDIUM,
   PATTERN_STRENGTH_STRONG
};

struct SPatternResult
{
   bool detected;
   EPatternType pattern;
   EPatternDirection direction;
   EPatternStrength strength;
   double score;
   datetime timestamp;
   double priceTop;
   double priceBottom;

   void Reset()
   {
      detected = false;
      pattern = PATTERN_TYPE_NONE;
      direction = PATTERN_NONE;
      strength = PATTERN_STRENGTH_NONE;
      score = 0.0;
      timestamp = 0;
      priceTop = 0.0;
      priceBottom = 0.0;
   }
};

#endif
