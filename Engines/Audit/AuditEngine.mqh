#ifndef __ARES_AUDITENGINE_MQH__
#define __ARES_AUDITENGINE_MQH__

#include "AuditContext.mqh"

class CAuditEngine
{
private:
   int m_totalAudits;
   int m_successfulAudits;
   double m_totalPnL;

public:
   CAuditEngine()
   {
      Reset();
   }

   void Reset()
   {
      m_totalAudits=0;
      m_successfulAudits=0;
      m_totalPnL=0.0;
   }

   void Register(const SAuditContext &ctx)
   {
      ++m_totalAudits;
      if(ctx.success)
         ++m_successfulAudits;
      m_totalPnL+=ctx.pnl;
   }

   int TotalAudits() const { return m_totalAudits; }
   int SuccessfulAudits() const { return m_successfulAudits; }

   double SuccessRate() const
   {
      if(m_totalAudits==0)
         return 0.0;
      return (double)m_successfulAudits/(double)m_totalAudits;
   }

   double TotalPnL() const
   {
      return m_totalPnL;
   }
};

#endif
