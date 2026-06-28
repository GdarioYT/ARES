#ifndef __ARES_DECISIONENGINE_MQH__
#define __ARES_DECISIONENGINE_MQH__

#include "DecisionContext.mqh"

class CDecisionEngine
{
private:
   double m_riskPercent;
   double m_minRiskReward;

public:
   CDecisionEngine()
   {
      m_riskPercent = 0.50;  // 0.50% recomendado por el Master Plan
      m_minRiskReward = 2.0; // R:R 1:2 mínimo recomendado
   }

   void SetRiskParams(const double riskPercent, const double minRiskReward)
   {
      m_riskPercent = riskPercent;
      m_minRiskReward = minRiskReward;
   }

   bool Evaluate(SDecisionContext &context)
   {
      if(context.action == DECISION_NONE)
         return false;

      // Calcular R:R
      double riskDist = MathAbs(context.entryPrice - context.stopLoss);
      double rewardDist = MathAbs(context.takeProfit - context.entryPrice);

      if(riskDist > 0)
         context.riskRewardRatio = rewardDist / riskDist;
      else
         context.riskRewardRatio = 0;

      if(context.riskRewardRatio < m_minRiskReward)
      {
         // R:R no cumple, vetamos el trade a nivel de Decisión
         context.action = DECISION_NONE;
         return false;
      }

      // Calculo de Lotaje usando el riesgo de la cuenta
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskAmount = balance * (m_riskPercent / 100.0);
      
      double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      
      if(tickSize > 0 && tickValue > 0 && riskDist > 0)
      {
         double ticks = riskDist / tickSize;
         double lot = riskAmount / (ticks * tickValue);
         
         // Normalizar lotaje a los limites del broker
         double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
         double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
         double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
         
         lot = MathRound(lot / stepLot) * stepLot;
         if(lot < minLot) lot = minLot;
         if(lot > maxLot) lot = maxLot;
         
         context.lotSize = lot;
      }

      return context.action != DECISION_NONE;
   }

   bool IsBuy(const SDecisionContext &context) const
   {
      return context.action==DECISION_BUY;
   }

   bool IsSell(const SDecisionContext &context) const
   {
      return context.action==DECISION_SELL;
   }
};

#endif
