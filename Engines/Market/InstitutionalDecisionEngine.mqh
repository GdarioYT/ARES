#ifndef __ARES_INSTITUTIONALDECISIONENGINE_MQH__
#define __ARES_INSTITUTIONALDECISIONENGINE_MQH__

#include "CoreInstitutionalPipeline.mqh"
#include "InstitutionalSignal.mqh"
#include "TradePlan.mqh"

enum EInstitutionalDecision
{
   INSTITUTIONAL_DECISION_NONE = 0,
   INSTITUTIONAL_DECISION_BUY,
   INSTITUTIONAL_DECISION_SELL
};

class CInstitutionalDecisionEngine
{
private:
   EInstitutionalDecision m_decision;
   double m_confidence;

public:
   CInstitutionalDecisionEngine()
   {
      Reset();
   }

   void Reset()
   {
      m_decision = INSTITUTIONAL_DECISION_NONE;
      m_confidence = 0.0;
   }

   bool Evaluate(const CInstitutionalSignal &signal,
                 const CConfluenceEngine &confluence,
                 const STradePlan &plan)
   {
      Reset();

      if(!plan.valid)
         return false;

      if(confluence.Score() < 0.75)
         return false;

      m_confidence = confluence.Score();

      if(signal.IsLong())
      {
         m_decision = INSTITUTIONAL_DECISION_BUY;
         return true;
      }

      if(signal.IsShort())
      {
         m_decision = INSTITUTIONAL_DECISION_SELL;
         return true;
      }

      return false;
   }

   EInstitutionalDecision Decision() const
   {
      return m_decision;
   }

   double Confidence() const
   {
      return m_confidence;
   }

   bool IsBuy() const
   {
      return m_decision == INSTITUTIONAL_DECISION_BUY;
   }

   bool IsSell() const
   {
      return m_decision == INSTITUTIONAL_DECISION_SELL;
   }
};

#endif
