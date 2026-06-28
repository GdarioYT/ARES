#ifndef __ARES_INSTITUTIONALENTRYENGINE_MQH__
#define __ARES_INSTITUTIONALENTRYENGINE_MQH__

#include "InstitutionalTradeFlow.mqh"
#include "EntryEngine.mqh"

class CInstitutionalEntryEngine
{
private:
   CInstitutionalTradeFlow *m_flow;
   CEntryEngine             m_entry;

public:
   CInstitutionalEntryEngine()
   {
      m_flow=NULL;
   }

   bool Initialize(CInstitutionalTradeFlow &flow)
   {
      m_flow=&flow;
      return true;
   }

   bool Ready() const
   {
      return (m_flow!=NULL && m_flow.Ready());
   }

   CEntryEngine &Entry()
   {
      return m_entry;
   }
};

#endif
