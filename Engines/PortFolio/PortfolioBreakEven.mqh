#ifndef __ARES_PORTFOLIOBREAKEVEN_MQH__
#define __ARES_PORTFOLIOBREAKEVEN_MQH__

#include <Trade\Trade.mqh>
#include "PortfolioPosition.mqh"

//+------------------------------------------------------------------+
//| CPortfolioBreakEven                                               |
//| Regla: Cuando el precio alcanza 1R de beneficio, mueve el SL     |
//| al precio de entrada (Break Even). Solo se aplica una vez.       |
//+------------------------------------------------------------------+
class CPortfolioBreakEven
{
private:
   CTrade  m_trade;
   double  m_triggerR;    // A cuántos R se activa (por defecto 1.0)
   double  m_bufferPips;  // Buffer extra sobre el entry en pips (evita stop outs por spread)

   double NormalizePrice(const double price, const string symbol) const
   {
      double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickSize <= 0) return price;
      return MathRound(price / tickSize) * tickSize;
   }

public:
   CPortfolioBreakEven()
   {
      m_triggerR   = 1.0;  // Activar BE cuando tenemos 1R de beneficio
      m_bufferPips = 2.0;  // 2 pips de buffer sobre el entry
   }

   void SetParams(const double triggerR, const double bufferPips)
   {
      m_triggerR   = triggerR;
      m_bufferPips = bufferPips;
   }

   void SetMagicNumber(const ulong magic)
   {
      m_trade.SetExpertMagicNumber(magic);
   }

   //--- Evalúa y aplica Break Even si corresponde
   //--- Devuelve true si modificó la posición
   bool Apply(SPortfolioPosition &pos)
   {
      // Si ya aplicamos BE o la posición no es válida, salir
      if(!pos.valid || pos.breakEvenDone) return false;

      // Reseleccionar la posición para que las llamadas a PositionGet* sean válidas
      if(!PositionSelectByTicket(pos.ticket)) return false;

      // Verificar que tenemos suficiente beneficio (>= triggerR)
      if(pos.CurrentR() < m_triggerR) return false;

      string symbol = _Symbol; // Portfolio solo gestiona posiciones del símbolo actual
      double point  = SymbolInfoDouble(symbol, SYMBOL_POINT);
      double buffer = m_bufferPips * point * 10; // convertir pips a precio

      double newSL = 0.0;

      if(pos.IsBuy())
      {
         newSL = NormalizePrice(pos.openPrice + buffer, symbol);
         // Solo subir el SL, nunca bajarlo
         if(newSL <= pos.currentSL) return false;
      }
      else if(pos.IsSell())
      {
         newSL = NormalizePrice(pos.openPrice - buffer, symbol);
         // Solo bajar el SL, nunca subirlo
         if(newSL >= pos.currentSL) return false;
      }

      // Enviar modificación al broker
      bool result = m_trade.PositionModify(pos.ticket, newSL, pos.currentTP);

      if(result)
      {
         pos.currentSL     = newSL;
         pos.breakEvenDone = true;
         Print("[ARES][Portfolio][BE] ✅ Break Even aplicado. Ticket #", pos.ticket,
               " | Nuevo SL: ", DoubleToString(newSL, _Digits),
               " | R actual: ", DoubleToString(pos.CurrentR(), 2));
      }
      else
      {
         Print("[ARES][Portfolio][BE] ❌ Error al modificar SL. Ticket #", pos.ticket,
               " | Retcode: ", m_trade.ResultRetcode());
      }

      return result;
   }
};

#endif
