#ifndef __ARES_SYSTEMCONTEXT_MQH__
#define __ARES_SYSTEMCONTEXT_MQH__

#include "../Engines/Market/MarketContext.mqh"
#include "../Engines/Pattern/PatternResult.mqh"
#include "../Engines/Intelligence/IntelligenceContext.mqh"
#include "../Engines/Decision/DecisionContext.mqh"
#include "../Engines/Guardian/GuardianContext.mqh"
#include "../Engines/PortFolio/PortfolioContext.mqh"
#include "../Engines/Execution/ExecutionReport.mqh"
#include "../Engines/Learning/LearningContext.mqh"
#include "../Engines/Audit/AuditContext.mqh"

struct SSystemContext
{
   SMarketContext     market;
   SPatternResult     pattern;
   SIntelligenceContext intelligence;
   SDecisionContext   decision;
   SGuardianContext   guardian;
   SPortfolioContext  portfolio;
   SExecutionReport   execution;
   SLearningContext   learning;
   SAuditContext      audit;

   void Reset()
   {
      market.Reset();
      pattern.Reset();
      intelligence.Reset();
      decision.Reset();
      guardian.Reset();
      portfolio.Reset();
      execution.Reset();
      learning.Reset();
      audit.Reset();
   }
};

#endif
