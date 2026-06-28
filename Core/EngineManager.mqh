#ifndef __ARES_ENGINEMANAGER_MQH__
#define __ARES_ENGINEMANAGER_MQH__

#include "SystemContext.mqh"
#include "Config.mqh"

#include "../Engines/Data/DataEngine.mqh"
#include "../Engines/Market/MarketEngine.mqh"
#include "../Engines/Pattern/PatternEngine.mqh"
#include "../Engines/Intelligence/IntelligenceEngine.mqh"
#include "../Engines/Decision/DecisionEngine.mqh"
#include "../Engines/Guardian/GuardianEngine.mqh"
#include "../Engines/PortFolio/PortfolioEngine.mqh"
#include "../Engines/Execution/ExecutionEngine.mqh"
#include "../Engines/Learning/LearningEngine.mqh"
#include "../Engines/Audit/AuditEngine.mqh"

class CEngineManager
{
private:
   CDataEngine          m_data;
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
   bool Initialize()
   {
      if(!m_data.Initialize(InpHistoryBars))
         return false;

      if(!m_market.Initialize(m_data))
         return false;

      return true;
   }

   CDataEngine         &Data()         { return m_data; }
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
