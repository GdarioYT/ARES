#ifndef __ARES_PATTERNDETECTOR_MQH__
#define __ARES_PATTERNDETECTOR_MQH__

#include "PatternContext.mqh"

// EPatternType and EPatternDirection are defined in PatternContext.mqh

#include "../Data/DataEngine.mqh"

class CPatternDetector
{
private:
   CDataEngine *m_engine;
   EPatternType m_lastPattern;
   double m_priceTop;
   double m_priceBottom;

public:
   CPatternDetector()
   {
      m_engine = NULL;
      m_lastPattern = PATTERN_TYPE_NONE;
      m_priceTop = 0.0;
      m_priceBottom = 0.0;
   }

   void Initialize(CDataEngine &engine)
   {
      m_engine = &engine;
   }

   bool Analyze(const SPatternContext &context)
   {
      m_lastPattern = PATTERN_TYPE_NONE;
      m_priceTop = 0.0;
      m_priceBottom = 0.0;

      if(!context.valid || m_engine == NULL || m_engine.Bars() < 5)
         return false;

      SCandle c1, c2, c3;
      // Index 1 (newest closed), 2, 3 (oldest)
      if(!m_engine.Get(1, c1) || !m_engine.Get(2, c2) || !m_engine.Get(3, c3))
         return false;

      // Bullish FVG (c3 is older, c1 is newest)
      // c2 is large bullish, leaving a gap between c3.High and c1.Low
      if (c2.Close > c2.Open && c3.High < c1.Low)
      {
         m_lastPattern = PATTERN_TYPE_FVG;
         m_priceTop = c1.Low;
         m_priceBottom = c3.High;
         return true;
      }

      // Bearish FVG
      // c2 is large bearish, leaving a gap between c3.Low and c1.High
      if (c2.Close < c2.Open && c3.Low > c1.High)
      {
         m_lastPattern = PATTERN_TYPE_FVG;
         m_priceTop = c3.Low;
         m_priceBottom = c1.High;
         return true;
      }

      // Bullish Order Block (c3 was down, c2 was strong up engulfing)
      if (c3.Close < c3.Open && c2.Close > c2.Open && c2.Close > c3.High)
      {
         m_lastPattern = PATTERN_TYPE_OB;
         m_priceTop = c3.High;
         m_priceBottom = c3.Low;
         return true;
      }

      // Bearish Order Block (c3 was up, c2 was strong down engulfing)
      if (c3.Close > c3.Open && c2.Close < c2.Open && c2.Close < c3.Low)
      {
         m_lastPattern = PATTERN_TYPE_OB;
         m_priceTop = c3.High;
         m_priceBottom = c3.Low;
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
      return m_lastPattern != PATTERN_TYPE_NONE;
   }

   double PriceTop() const { return m_priceTop; }
   double PriceBottom() const { return m_priceBottom; }
};

#endif
