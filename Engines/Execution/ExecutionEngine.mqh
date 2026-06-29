#ifndef __ARES_EXECUTIONENGINE_MQH__
#define __ARES_EXECUTIONENGINE_MQH__

#include <Trade\Trade.mqh>
#include "ExecutionContext.mqh"
#include "ExecutionReport.mqh"

//+------------------------------------------------------------------+
//| CExecutionEngine                                                  |
//| Responsabilidad: Enviar órdenes reales al broker usando CTrade.  |
//| Recibe un SExecutionContext ya validado por GuardianEngine y      |
//| DecisionEngine. No toma decisiones propias — solo ejecuta.       |
//+------------------------------------------------------------------+
class CExecutionEngine
{
private:
   CTrade      m_trade;
   ulong       m_magicNumber;
   uint        m_slippagePoints;
   bool        m_initialized;

   //--- Normaliza el precio al tick del símbolo
   double NormalizePrice(const double price) const
   {
      double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickSize <= 0) return price;
      return MathRound(price / tickSize) * tickSize;
   }

   //--- Construye el comentario de la orden
   string BuildComment(const SExecutionContext &ctx) const
   {
      string dir = (ctx.decision.action == DECISION_BUY) ? "BUY" : "SELL";
      return StringFormat("ARES|%s|Score%.0f|RR%.2f",
                          dir,
                          ctx.decision.intelligence.totalScore,
                          ctx.decision.riskRewardRatio);
   }

public:
   CExecutionEngine()
   {
      m_magicNumber    = 20260629; // ID único de ARES
      m_slippagePoints = 10;       // Slippage máximo en puntos (ajustable)
      m_initialized    = false;
   }

   //--- Inicialización: configura CTrade con los parámetros del broker
   bool Initialize(const ulong magicNumber = 20260629, const uint slippage = 10)
   {
      m_magicNumber    = magicNumber;
      m_slippagePoints = slippage;

      m_trade.SetExpertMagicNumber(m_magicNumber);
      m_trade.SetDeviationInPoints(m_slippagePoints);
      m_trade.SetAsyncMode(false); // Esperar confirmación del broker

      // Detectar automáticamente el modo de filling soportado por el broker
      uint fillingMode = (uint)SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
      if((fillingMode & ORDER_FILLING_IOC) != 0)
         m_trade.SetTypeFilling(ORDER_FILLING_IOC);
      else if((fillingMode & ORDER_FILLING_FOK) != 0)
         m_trade.SetTypeFilling(ORDER_FILLING_FOK);
      else
         m_trade.SetTypeFilling(ORDER_FILLING_RETURN); // Fallback para todos los brokers

      m_initialized = true;
      Print("[ARES][Execution] Motor inicializado. Magic: ", m_magicNumber,
            " | Slippage: ", m_slippagePoints, " pts");
      return true;
   }

   //--- Valida el contexto antes de enviar la orden
   bool Prepare(SExecutionContext &context,
                const double volume,
                const double stopLoss,
                const double takeProfit)
   {
      if(context.decision.action == DECISION_NONE)
      {
         context.execute = false;
         return false;
      }

      // Normalizar precios al tick del broker
      context.volume     = volume;
      context.stopLoss   = NormalizePrice(stopLoss);
      context.takeProfit = NormalizePrice(takeProfit);
      context.execute    = true;

      return true;
   }

   bool CanExecute(const SExecutionContext &context) const
   {
      return context.execute && m_initialized;
   }

   //--- FUNCIÓN PRINCIPAL: Envía la orden al broker
   bool SendOrder(SExecutionContext &context, SExecutionReport &report)
   {
      report.Reset();

      if(!CanExecute(context))
      {
         report.status = EXECUTION_REJECTED;
         Print("[ARES][Execution] ERROR: Motor no inicializado o contexto inválido.");
         return false;
      }

      // Obtener precio de mercado actual para la ejecución
      double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);

      double entryPrice = 0.0;
      bool   result     = false;

      // --- Ejecutar BUY ---
      if(context.decision.action == DECISION_BUY)
      {
         entryPrice = askPrice;
         double sl  = NormalizePrice(context.stopLoss);
         double tp  = NormalizePrice(context.takeProfit);

         Print("[ARES][Execution] >> ENVIANDO BUY | Vol: ", DoubleToString(context.volume, 2),
               " | Entry: ", DoubleToString(entryPrice, _Digits),
               " | SL: ",    DoubleToString(sl, _Digits),
               " | TP: ",    DoubleToString(tp, _Digits));

         result = m_trade.Buy(context.volume, _Symbol, entryPrice, sl, tp, BuildComment(context));
      }
      // --- Ejecutar SELL ---
      else if(context.decision.action == DECISION_SELL)
      {
         entryPrice = bidPrice;
         double sl  = NormalizePrice(context.stopLoss);
         double tp  = NormalizePrice(context.takeProfit);

         Print("[ARES][Execution] >> ENVIANDO SELL | Vol: ", DoubleToString(context.volume, 2),
               " | Entry: ", DoubleToString(entryPrice, _Digits),
               " | SL: ",    DoubleToString(sl, _Digits),
               " | TP: ",    DoubleToString(tp, _Digits));

         result = m_trade.Sell(context.volume, _Symbol, entryPrice, sl, tp, BuildComment(context));
      }

      // --- Procesar resultado del broker ---
      if(result)
      {
         ulong ticket = m_trade.ResultOrder();
         report.FromContext(context);
         report.status    = EXECUTION_SENT;
         report.ticket    = ticket;
         report.entryPrice = entryPrice;

         Print("[ARES][Execution] ✅ ORDEN ENVIADA. Ticket #", ticket,
               " | Retcode: ", m_trade.ResultRetcode(),
               " | Deal: ",    m_trade.ResultDeal());
      }
      else
      {
         report.status = EXECUTION_REJECTED;
         Print("[ARES][Execution] ❌ ERROR AL ENVIAR ORDEN.",
               " Retcode: ", m_trade.ResultRetcode(),
               " | ", m_trade.ResultRetcodeDescription());
      }

      return result;
   }

   //--- Acceso al número mágico (útil para el PortfolioEngine)
   ulong MagicNumber() const { return m_magicNumber; }
};

#endif
