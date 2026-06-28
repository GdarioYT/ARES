#ifndef __ARES_GUARDIANRULES_MQH__
#define __ARES_GUARDIANRULES_MQH__

#include "GuardianContext.mqh"

class CGuardianRules
{
private:
   double m_maxRisk;          // Límite máximo de riesgo (1% recomendado)
   double m_maxDailyDrawdown; // Límite máximo de Drawdown diario

public:
   CGuardianRules()
   {
      m_maxRisk = 1.0; 
      m_maxDailyDrawdown = 5.0; // Default 5%
   }

   void SetMaxRisk(const double value)
   {
      m_maxRisk=value;
   }

   bool Evaluate(SGuardianContext &context) const
   {
      // Veto 1: Limite del broker y tamaño nulo o inválido
      if(context.decision.lotSize <= 0.0)
      {
         context.status = GUARDIAN_BLOCK;
         return false;
      }
      
      // Veto 2: Riesgo Excesivo
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskDist = MathAbs(context.decision.entryPrice - context.decision.stopLoss);
      double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      
      if(tickSize > 0 && tickValue > 0 && riskDist > 0)
      {
         double ticks = riskDist / tickSize;
         double riskAmount = ticks * tickValue * context.decision.lotSize;
         double riskPercent = (riskAmount / balance) * 100.0;
         
         if(riskPercent > m_maxRisk)
         {
             context.status = GUARDIAN_BLOCK;
             return false;
         }
      }

      // Veto 3: Drawdown Diario
      if(context.dailyDrawdown > m_maxDailyDrawdown)
      {
         context.status = GUARDIAN_BLOCK;
         return false;
      }

      // Veto 4: Filtro de Noticias
      if(context.newsFilterActive)
      {
         context.status = GUARDIAN_BLOCK;
         return false;
      }

      context.status = GUARDIAN_ALLOW;
      return true;
   }
};

#endif
