#ifndef __ARES_INSTITUTIONALCOORDINATOR_MQH__
#define __ARES_INSTITUTIONALCOORDINATOR_MQH__

#include "OrderBlockDetector.mqh"
#include "FairValueGapDetector.mqh"
#include "LiquiditySweepDetector.mqh"
#include "InstitutionalSignal.mqh"
#include "ConfluenceEngine.mqh"
#include "TradeCoordinator.mqh"

class CInstitutionalCoordinator
{
private:
   CInstitutionalSignal m_signal;
   CConfluenceEngine    m_confluence;

public:
   bool Evaluate(const COrderBlockDetector &ob,
                 const CFairValueGapDetector &fvg,
                 const CLiquiditySweepDetector &sweep,
                 const CBOSDetector &bos,
                 const CCHOCHDetector &choch,
                 const CTrendDetector &trend)
   {
      if(!m_signal.Evaluate(ob,fvg,sweep))
         return false;

      return m_confluence.Evaluate(bos,choch,trend,m_signal);
   }

   const CInstitutionalSignal &Signal() const { return m_signal; }
   const CConfluenceEngine &Confluence() const { return m_confluence; }
};

#endif
