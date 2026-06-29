#ifndef __ARES_PORTFOLIOENGINE_MQH__
#define __ARES_PORTFOLIOENGINE_MQH__

#include "PortfolioContext.mqh"
#include "PortfolioRisk.mqh"
#include "PortfolioPosition.mqh"
#include "PortfolioBreakEven.mqh"
#include "PortfolioTrailing.mqh"

//+------------------------------------------------------------------+
//| CPortfolioEngine                                                  |
//| Responsabilidad: Vigilar todas las posiciones abiertas de ARES   |
//| y aplicar Break Even + Trailing Stop en cada tick.               |
//| Se llama desde Pipeline.Execute() en cada nueva vela/tick.       |
//+------------------------------------------------------------------+
class CPortfolioEngine
{
private:
   CPortfolioRisk      m_risk;
   CPortfolioBreakEven m_breakEven;
   CPortfolioTrailing  m_trailing;
   ulong               m_magicNumber;

   // Estado interno de Break Even por ticket
   // (necesario porque SPortfolioPosition se reconstruye en cada tick)
   ulong m_beTickets[100];
   int   m_beCount;

   bool IsBreakEvenDone(const ulong ticket) const
   {
      for(int i = 0; i < m_beCount; i++)
         if(m_beTickets[i] == ticket) return true;
      return false;
   }

   void MarkBreakEvenDone(const ulong ticket)
   {
      if(m_beCount < 100)
      {
         m_beTickets[m_beCount] = ticket;
         m_beCount++;
      }
   }

   void CleanClosedTickets()
   {
      // Eliminar tickets de posiciones ya cerradas
      int i = 0;
      while(i < m_beCount)
      {
         if(!PositionSelectByTicket(m_beTickets[i]))
         {
            // Mover el último elemento a esta posición
            m_beTickets[i] = m_beTickets[m_beCount - 1];
            m_beCount--;
         }
         else i++;
      }
   }

public:
   CPortfolioEngine()
   {
      m_magicNumber = 20260629;
      m_beCount     = 0;
      ArrayInitialize(m_beTickets, 0);
   }

   bool Initialize(const ulong magicNumber = 20260629)
   {
      m_magicNumber = magicNumber;

      m_breakEven.SetMagicNumber(m_magicNumber);
      m_trailing.SetMagicNumber(m_magicNumber);

      // Parámetros por defecto (ajustables)
      m_breakEven.SetParams(1.0, 2.0);  // BE a 1R, buffer 2 pips
      m_trailing.SetParams(1.5, 1.0);   // Trail activo desde 1.5R, mantiene 1R de distancia

      Print("[ARES][Portfolio] Motor inicializado. Magic: ", m_magicNumber);
      return true;
   }

   //--- API heredada: controlar si se puede abrir un nuevo trade
   void SetMaximumExposure(const double value) { m_risk.SetMaxExposure(value); }
   bool CanTrade(const SPortfolioContext &context) const { return m_risk.CanOpen(context); }
   double MaxExposure() const { return m_risk.MaxExposure(); }

   //--- FUNCIÓN PRINCIPAL: Llamar en cada tick/vela para gestionar posiciones
   void Monitor()
   {
      CleanClosedTickets();

      int totalPositions = PositionsTotal();
      if(totalPositions == 0) return;

      for(int i = 0; i < totalPositions; i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket == 0) continue;

         // Solo gestionar posiciones de ARES
         if(PositionGetInteger(POSITION_MAGIC) != (long)m_magicNumber) continue;
         // Solo gestionar el símbolo actual
         if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;

         // Cargar datos actuales de la posición
         SPortfolioPosition pos;
         pos.Reset();
         if(!pos.LoadFromTicket(ticket)) continue;

         // Restaurar estado de BE desde nuestro registro interno
         pos.breakEvenDone = IsBreakEvenDone(ticket);

         // 1. Intentar aplicar Break Even (solo si aún no se ha hecho)
         if(!pos.breakEvenDone)
         {
            bool beApplied = m_breakEven.Apply(pos);
            if(beApplied)
               MarkBreakEvenDone(ticket);
         }

         // 2. Intentar actualizar Trailing Stop
         m_trailing.Apply(pos);
      }
   }
};

#endif
