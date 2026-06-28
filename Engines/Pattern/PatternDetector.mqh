#ifndef __ARES_PATTERNDETECTOR_MQH__
#define __ARES_PATTERNDETECTOR_MQH__

#include "PatternContext.mqh"

enum EPatternType
{
   PATTERN_TYPE_NONE=0,
   PATTERN_TYPE_CONTINUATION,
   PATTERN_TYPE_REVERSAL
};

class CPatternDetector
{
private:
   EPatternType m_lastPattern;

public:
   CPatternDetector()
   {
      m_lastPattern=PATTERN_TYPE_NONE;
   }

   bool Analyze(const SPatternContext &context)
   {
      m_lastPattern=PATTERN_TYPE_NONE;

      if(!context.valid)
         return false;

      if(context.score<0.60)
         return false;

      if(context.direction==PATTERN_LONG ||
         context.direction==PATTERN_SHORT)
      {
         m_lastPattern=PATTERN_TYPE_CONTINUATION;
         return true;
      }

      return false;
   }

   EPatternType LastPattern() const
   {
      return m_lastPattern;
   }

   bool HasPattern() const
   {
      return m_lastPattern!=PATTERN_TYPE_NONE;
   }
};

#endif
