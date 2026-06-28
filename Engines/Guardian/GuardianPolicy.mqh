#ifndef __ARES_GUARDIANPOLICY_MQH__
#define __ARES_GUARDIANPOLICY_MQH__

#include "GuardianSession.mqh"
#include "../Decision/DecisionContext.mqh"

class CGuardianPolicy
{
private:
   CGuardianSession *m_session;

public:
   CGuardianPolicy()
   {
      m_session=NULL;
   }

   bool Initialize(CGuardianSession &session)
   {
      m_session=&session;
      return true;
   }

   bool CanExecute(const SDecisionContext &decision) const
   {
      if(m_session==NULL)
         return false;

      if(m_session->IsPaused())
         return false;

      return decision.action!=DECISION_NONE;
   }
};

#endif
