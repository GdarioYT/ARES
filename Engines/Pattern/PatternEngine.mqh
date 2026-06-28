#ifndef __ARES_PATTERNENGINE_MQH__
#define __ARES_PATTERNENGINE_MQH__

#include "PatternContext.mqh"
#include "PatternDetector.mqh"
#include "PatternValidator.mqh"
#include "PatternScore.mqh"
#include "PatternResult.mqh"

class CPatternEngine
{
private:
   CPatternDetector  m_detector;
   CPatternValidator m_validator;
   CPatternScore     m_score;

public:
   bool Initialize(CDataEngine &data)
   {
      m_detector.Initialize(data);
      return true;
   }

public:
   bool Analyze(const SPatternContext &context,
                SPatternResult &result)
   {
      result.Reset();

      if(!m_detector.Analyze(context))
         return false;

      if(!m_validator.Validate(context,m_detector))
         return false;

      m_score.Evaluate(context);

      result.detected=true;
      result.pattern=m_detector.LastPattern();
      result.direction=context.direction;

      if(m_score.Value()>=0.90)
         result.strength=PATTERN_STRENGTH_STRONG;
      else if(m_score.Value()>=0.75)
         result.strength=PATTERN_STRENGTH_MEDIUM;
      else
         result.strength=PATTERN_STRENGTH_WEAK;

      result.score=m_score.Value();
      result.priceTop=m_detector.PriceTop();
      result.priceBottom=m_detector.PriceBottom();
      result.timestamp=TimeCurrent();

      return true;
   }
};

#endif
