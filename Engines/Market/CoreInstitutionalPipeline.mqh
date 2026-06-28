#ifndef __ARES_COREINSTITUTIONALPIPELINE_MQH__
#define __ARES_COREINSTITUTIONALPIPELINE_MQH__

#include "InstitutionalGate.mqh"
#include "InstitutionalCoordinator.mqh"
#include "TradeCoordinator.mqh"

class CCoreInstitutionalPipeline
{
private:
   CInstitutionalGate   *m_gate;
   CTradeCoordinator    *m_trade;

public:
   CCoreInstitutionalPipeline()
   {
      m_gate=NULL;
      m_trade=NULL;
   }

   bool Initialize(CInstitutionalGate &gate,
                   CTradeCoordinator &trade)
   {
      m_gate=&gate;
      m_trade=&trade;
      return true;
   }

   bool CanContinue(const CInstitutionalEntryEngine &entry,
                    const CInstitutionalCoordinator &coordinator) const
   {
      if(m_gate==NULL || m_trade==NULL)
         return false;

      return m_gate->Allow(entry,coordinator);
   }
};

#endif
