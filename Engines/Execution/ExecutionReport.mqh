#ifndef __ARES_EXECUTIONREPORT_MQH__
#define __ARES_EXECUTIONREPORT_MQH__

#include "ExecutionContext.mqh"

enum EExecutionStatus
{
   EXECUTION_PENDING  = 0,
   EXECUTION_READY,
   EXECUTION_SENT,
   EXECUTION_REJECTED
};

//+------------------------------------------------------------------+
//| SExecutionReport                                                  |
//| Registro completo del resultado de una orden enviada al broker.  |
//+------------------------------------------------------------------+
struct SExecutionReport
{
   EExecutionStatus status;
   datetime         timestamp;
   ulong            ticket;       // Ticket asignado por el broker
   double           entryPrice;   // Precio real de ejecución
   double           volume;
   double           stopLoss;
   double           takeProfit;

   void Reset()
   {
      status     = EXECUTION_PENDING;
      timestamp  = 0;
      ticket     = 0;
      entryPrice = 0.0;
      volume     = 0.0;
      stopLoss   = 0.0;
      takeProfit = 0.0;
   }

   void FromContext(const SExecutionContext &ctx)
   {
      volume     = ctx.volume;
      stopLoss   = ctx.stopLoss;
      takeProfit = ctx.takeProfit;
      timestamp  = TimeCurrent();
      status     = ctx.execute ? EXECUTION_READY : EXECUTION_REJECTED;
      ticket     = 0;
      entryPrice = 0.0;
   }

   bool WasSent()     const { return status == EXECUTION_SENT;     }
   bool WasRejected() const { return status == EXECUTION_REJECTED;  }
};

#endif
