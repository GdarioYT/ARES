#ifndef __ARES_TRENDDETECTOR_MQH__
#define __ARES_TRENDDETECTOR_MQH__

#include "StructureAnalyzer.mqh"
#include "BOSDetector.mqh"
#include "CHOCHDetector.mqh"

enum ETrendState
{
   TREND_UNKNOWN=0,
   TREND_BULLISH,
   TREND_BEARISH,
   TREND_TRANSITION
};

class CTrendDetector
{
private:
   CStructureAnalyzer *m_structure;
   CBOSDetector       *m_bos;
   CCHOCHDetector     *m_choch;
   ETrendState         m_state;

public:
   CTrendDetector()
   {
      m_structure=NULL;
      m_bos=NULL;
      m_choch=NULL;
      m_state=TREND_UNKNOWN;
   }

   bool Initialize(CStructureAnalyzer &s, CBOSDetector &b, CCHOCHDetector &c)
   {
      m_structure=&s;
      m_bos=&b;
      m_choch=&c;
      return true;
   }

   ETrendState Update()
   {
      if(m_bos==NULL || m_choch==NULL)
         return TREND_UNKNOWN;

      if(m_choch->IsBullishCHOCH())
         m_state=TREND_TRANSITION;
      else if(m_choch->IsBearishCHOCH())
         m_state=TREND_TRANSITION;
      else if(m_bos->IsBullishBOS())
         m_state=TREND_BULLISH;
      else if(m_bos->IsBearishBOS())
         m_state=TREND_BEARISH;

      return m_state;
   }

   ETrendState State() const { return m_state; }
   bool IsBullish() const { return m_state==TREND_BULLISH; }
   bool IsBearish() const { return m_state==TREND_BEARISH; }
   bool IsTransition() const { return m_state==TREND_TRANSITION; }
};

#endif
