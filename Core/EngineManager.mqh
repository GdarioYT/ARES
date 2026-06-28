#ifndef __ARES_ENGINEMANAGER_MQH__
#define __ARES_ENGINEMANAGER_MQH__

#include "SystemContext.mqh"

#include "../Engines/Market/MarketEngine.mqh"
#include "../Engines/Pattern/PatternEngine.mqh"
#include "../Engines/Intelligence/IntelligenceEngine.mqh"
#include "../Engines/Decision/DecisionEngine.mqh"
#include "../Engines/Guardian/GuardianEngine.mqh"
#include "../Engines/Portfolio/PortfolioEngine.mqh"
#include "../Engines/Execution/ExecutionEngine.mqh"
#include "../Engines/Learning/LearningEngine.mqh"
#include "../Engines/Audit/AuditEngine.mqh"

class CEngineManager
{
private:
   CMarketEngine        m_market;
   CPatternEngine       m_pattern;
   CIntelligenceEngine  m_intelligence;
   CDecisionEngine      m_decision;
   CGuardianEngine      m_guardian;
   CPortfolioEngine     m_portfolio;
   CExecutionEngine     m_execution;
   CLearningEngine      m_learning;
   CAuditEngine         m_audit;

public:
   CMarketEngine       &Market()       { return m_market; }
   CPatternEngine      &Pattern()      { return m_pattern; }
   CIntelligenceEngine &Intelligence() { return m_intelligence; }
   CDecisionEngine     &Decision()     { return m_decision; }
   CGuardianEngine     &Guardian()     { return m_guardian; }
   CPortfolioEngine    &Portfolio()    { return m_portfolio; }
   CExecutionEngine    &Execution()    { return m_execution; }
   CLearningEngine     &Learning()     { return m_learning; }
   CAuditEngine        &Audit()        { return m_audit; }
};

#endif
