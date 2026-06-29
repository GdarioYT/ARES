#ifndef __ARES_PORTFOLIOPOSITION_MQH__
#define __ARES_PORTFOLIOPOSITION_MQH__

//+------------------------------------------------------------------+
//| SPortfolioPosition                                                |
//| Snapshot de una posición abierta gestionada por ARES.            |
//| Se rellena desde el ticket real del broker.                      |
//+------------------------------------------------------------------+
struct SPortfolioPosition
{
   ulong    ticket;
   long     type;          // POSITION_TYPE_BUY / POSITION_TYPE_SELL
   double   volume;
   double   openPrice;
   double   currentSL;
   double   currentTP;
   double   currentPrice; // Precio actual de mercado (Bid para Buy, Ask para Sell)
   double   riskDistance; // |openPrice - SL original| = 1R
   bool     breakEvenDone;
   bool     valid;

   void Reset()
   {
      ticket        = 0;
      type          = -1;
      volume        = 0.0;
      openPrice     = 0.0;
      currentSL     = 0.0;
      currentTP     = 0.0;
      currentPrice  = 0.0;
      riskDistance  = 0.0;
      breakEvenDone = false;
      valid         = false;
   }

   //--- Carga los datos de una posición abierta por su ticket
   bool LoadFromTicket(const ulong t)
   {
      if(!PositionSelectByTicket(t))
      {
         valid = false;
         return false;
      }

      ticket       = t;
      type         = PositionGetInteger(POSITION_TYPE);
      volume       = PositionGetDouble(POSITION_VOLUME);
      openPrice    = PositionGetDouble(POSITION_PRICE_OPEN);
      currentSL    = PositionGetDouble(POSITION_SL);
      currentTP    = PositionGetDouble(POSITION_TP);
      riskDistance = MathAbs(openPrice - currentSL);

      // Precio actual según dirección
      if(type == POSITION_TYPE_BUY)
         currentPrice = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);
      else
         currentPrice = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);

      breakEvenDone = false; // Se evalúa en runtime
      valid         = true;
      return true;
   }

   bool IsBuy()  const { return type == POSITION_TYPE_BUY;  }
   bool IsSell() const { return type == POSITION_TYPE_SELL; }

   //--- Cuántos R de beneficio tenemos ahora mismo
   double CurrentR() const
   {
      if(riskDistance <= 0) return 0.0;
      if(IsBuy())  return (currentPrice - openPrice) / riskDistance;
      if(IsSell()) return (openPrice - currentPrice) / riskDistance;
      return 0.0;
   }
};

#endif
