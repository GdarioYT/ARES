#ifndef __ARES_INSTITUTIONALSIGNAL_MQH__
#define __ARES_INSTITUTIONALSIGNAL_MQH__

#include "OrderBlockDetector.mqh"
#include "FairValueGapDetector.mqh"
#include "LiquiditySweepDetector.mqh"

enum EInstitutionalSignal
{
   SIGNAL_NONE=0,
   SIGNAL_LONG,
   SIGNAL_SHORT
};

class CInstitutionalSignal
{
private:
   EInstitutionalSignal m_signal;
   double m_score;

public:
   CInstitutionalSignal()
   {
      Reset();
   }

   void Reset()
   {
      m_signal=SIGNAL_NONE;
      m_score=0.0;
   }

   bool Evaluate(const COrderBlockDetector &ob,
                 const CFairValueGapDetector &fvg,
                 const CLiquiditySweepDetector &sweep)
   {
      Reset();

      if(ob.HasOrderBlock())
         m_score+=0.40;

      if(fvg.HasGap())
         m_score+=0.30;

      if(sweep.HasSweep())
         m_score+=0.30;

      if(m_score<0.70)
         return false;

      if(ob.LastBlock().type==ORDERBLOCK_BULLISH)
         m_signal=SIGNAL_LONG;
      else if(ob.LastBlock().type==ORDERBLOCK_BEARISH)
         m_signal=SIGNAL_SHORT;
      else
         return false;

      return true;
   }

   EInstitutionalSignal Signal() const { return m_signal; }
   double Score() const { return m_score; }
   bool IsLong() const { return m_signal==SIGNAL_LONG; }
   bool IsShort() const { return m_signal==SIGNAL_SHORT; }
};

#endif
