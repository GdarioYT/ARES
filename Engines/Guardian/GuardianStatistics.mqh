#ifndef __ARES_GUARDIANSTATISTICS_MQH__
#define __ARES_GUARDIANSTATISTICS_MQH__

#include "GuardianReport.mqh"

class CGuardianStatistics
{
private:
   SGuardianReport m_report;

public:
   void Update(const SGuardianReport &report)
   {
      m_report = report;
   }

   const SGuardianReport &Report() const
   {
      return m_report;
   }

   double AllowRate() const
   {
      int total = m_report.allowed + m_report.blocked + m_report.paused;
      if(total==0)
         return 0.0;
      return (double)m_report.allowed / (double)total;
   }

   double PauseRate() const
   {
      int total = m_report.allowed + m_report.blocked + m_report.paused;
      if(total==0)
         return 0.0;
      return (double)m_report.paused / (double)total;
   }

   double BlockRate() const
   {
      return m_report.blockRate;
   }
};

#endif
