#ifndef __ARES_SYSTEMCONTEXT_MQH__
#define __ARES_SYSTEMCONTEXT_MQH__

#include "../Market/MarketContext.mqh"
#include "../Pattern/PatternResult.mqh"
#include "../Intelligence/IntelligenceContext.mqh"
#include "../Decision/DecisionContext.mqh"
#include "../Guardian/GuardianContext.mqh"
#include "../Portfolio/PortfolioContext.mqh"
#include "../Execution/ExecutionReport.mqh"
#include "../Learning/LearningContext.mqh"
#include "../Audit/AuditContext.mqh"

struct SSystemContext
{
   SMarketContext market;
   SPatternResult pattern;
   SIntelligenceContext intelligence;
   SDecisionContext decision;
   SGuardianContext guardian;
   SPortfolioContext portfolio;
   SExecutionReport execution;
   SLearningContext learning;
   SAuditContext audit;

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
