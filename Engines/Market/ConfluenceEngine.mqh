#ifndef __ARES_CONFLUENCEENGINE_MQH__
#define __ARES_CONFLUENCEENGINE_MQH__

#include "BOSDetector.mqh"
#include "CHOCHDetector.mqh"
#include "TrendDetector.mqh"
#include "InstitutionalSignal.mqh"

class CConfluenceEngine
{
private:
   double m_score;

public:
   CConfluenceEngine()
   {
      m_score=0.0;
   }

   bool Evaluate(const CBOSDetector &bos,
                 const CCHOCHDetector &choch,
                 const CTrendDetector &trend,
                 const CInstitutionalSignal &signal)
   {
      m_score=0.0;

      if(bos.IsBullishBOS() || bos.IsBearishBOS())
         m_score+=0.25;

      if(choch.IsBullishCHOCH() || choch.IsBearishCHOCH())
         m_score+=0.25;

      if(trend.IsBullish() || trend.IsBearish())
         m_score+=0.20;

      m_score+=signal.Score()*0.30;

      return m_score>=0.75;
   }

   double Score() const
   {
      return m_score;
   }
};

#endif
