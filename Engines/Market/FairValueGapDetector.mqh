#ifndef __ARES_FAIRVALUEGAPDETECTOR_MQH__
#define __ARES_FAIRVALUEGAPDETECTOR_MQH__

enum EFVGType
{
   FVG_NONE=0,
   FVG_BULLISH,
   FVG_BEARISH
};

struct SFairValueGap
{
   EFVGType type;
   double upper;
   double lower;
   int index;
   bool valid;

   void Reset()
   {
      type=FVG_NONE;
      upper=0.0;
      lower=0.0;
      index=-1;
      valid=false;
   }
};

class CFairValueGapDetector
{
private:
   SFairValueGap m_lastGap;

public:
   CFairValueGapDetector()
   {
      m_lastGap.Reset();
   }

   bool Analyze(const MqlRates &left,
                const MqlRates &middle,
                const MqlRates &right,
                const int index)
   {
      m_lastGap.Reset();

      if(left.high<right.low)
      {
         m_lastGap.type=FVG_BULLISH;
         m_lastGap.upper=right.low;
         m_lastGap.lower=left.high;
      }
      else if(left.low>right.high)
      {
         m_lastGap.type=FVG_BEARISH;
         m_lastGap.upper=left.low;
         m_lastGap.lower=right.high;
      }
      else
      {
         return false;
      }

      m_lastGap.index=index;
      m_lastGap.valid=true;
      return true;
   }

   const SFairValueGap &LastGap() const { return m_lastGap; }
   bool HasGap() const { return m_lastGap.valid; }
};

#endif
