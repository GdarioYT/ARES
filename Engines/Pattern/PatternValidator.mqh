#ifndef __ARES_PATTERNVALIDATOR_MQH__
#define __ARES_PATTERNVALIDATOR_MQH__

#include "PatternDetector.mqh"

class CPatternValidator
{
public:
   bool Validate(const SPatternContext &context,
                 const CPatternDetector &detector) const
   {
      if(!context.valid)
         return false;

      if(context.score<0.70)
         return false;

      return detector.HasPattern();
   }
};

#endif
