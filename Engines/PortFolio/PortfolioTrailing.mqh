#ifndef __ARES_PORTFOLIOTRAILING_MQH__
#define __ARES_PORTFOLIOTRAILING_MQH__

#include <Trade\Trade.mqh>
#include "PortfolioPosition.mqh"

//+------------------------------------------------------------------+
//| CPortfolioTrailing                                                |
//| Regla: Trailing Stop dinámico basado en R.                       |
//| Solo se activa después del Break Even (>= activationR).          |
//| Mueve el SL siguiendo el precio a una distancia fija en R.       |
//+------------------------------------------------------------------+
class CPortfolioTrailing
{
private:
   CTrade  m_trade;
   double  m_activationR;  // Mínimo R para activar el trailing (por defecto 1.5R)
   double  m_trailR;       // Distancia del trailing en R (por defecto 1.0R)

   double NormalizePrice(const double price, const string symbol) const
   {
      double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickSize <= 0) return price;
      return MathRound(price / tickSize) * tickSize;
   }

public:
   CPortfolioTrailing()
   {
      m_activationR = 1.5; // Activar trailing cuando hay 1.5R de beneficio
      m_trailR      = 1.0; // Mantener SL a 1R del precio actual
   }

   void SetParams(const double activationR, const double trailR)
   {
      m_activationR = activationR;
      m_trailR      = trailR;
   }

   void SetMagicNumber(const ulong magic)
   {
      m_trade.SetExpertMagicNumber(magic);
   }

   //--- Evalúa y aplica Trailing Stop si corresponde
   //--- Devuelve true si modificó la posición
   bool Apply(SPortfolioPosition &pos)
   {
      if(!pos.valid) return false;

      // Solo activar si estamos por encima del umbral de activación
      double currentR = pos.CurrentR();
      if(currentR < m_activationR) return false;

      if(pos.riskDistance <= 0) return false;

      string symbol = PositionGetString(POSITION_SYMBOL);

      // Calcular el nuevo SL basado en trailing: precio actual - (trailR * riskDistance)
      double newSL = 0.0;

      if(pos.IsBuy())
      {
         // SL = Precio actual - (trailR * riskDistance)
         newSL = NormalizePrice(pos.currentPrice - (m_trailR * pos.riskDistance), symbol);

         // El trailing solo SUBE el SL (proteger más ganancia)
         if(newSL <= pos.currentSL) return false;

         // No permitir que el trailing baje el SL por debajo del entry (ya tenemos BE)
         if(pos.breakEvenDone && newSL < pos.openPrice) return false;
      }
      else if(pos.IsSell())
      {
         // SL = Precio actual + (trailR * riskDistance)
         newSL = NormalizePrice(pos.currentPrice + (m_trailR * pos.riskDistance), symbol);

         // El trailing solo BAJA el SL (proteger más ganancia en short)
         if(newSL >= pos.currentSL) return false;

         // No permitir que el trailing suba el SL por encima del entry
         if(pos.breakEvenDone && newSL > pos.openPrice) return false;
      }

      // Enviar modificación al broker
      bool result = m_trade.PositionModify(pos.ticket, newSL, pos.currentTP);

      if(result)
      {
         pos.currentSL = newSL;
         Print("[ARES][Portfolio][Trail] 📈 Trailing actualizado. Ticket #", pos.ticket,
               " | Nuevo SL: ",  DoubleToString(newSL, _Digits),
               " | Precio: ",    DoubleToString(pos.currentPrice, _Digits),
               " | R actual: ",  DoubleToString(currentR, 2));
      }

      return result;
   }
};

#endif
