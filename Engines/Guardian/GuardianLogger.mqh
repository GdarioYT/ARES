#ifndef __ARES_GUARDIANLOGGER_MQH__
#define __ARES_GUARDIANLOGGER_MQH__

#include "GuardianStatistics.mqh"

class CGuardianLogger
{
private:
   CGuardianStatistics m_statistics;

public:
   void Update(const CGuardianStatistics &statistics)
   {
      m_statistics = statistics;
   }

   string Summary() const
   {
      return StringFormat("Guardian | Allow: %.2f%% Pause: %.2f%% Block: %.2f%%",
                          m_statistics.AllowRate()*100.0,
                          m_statistics.PauseRate()*100.0,
                          m_statistics.BlockRate()*100.0);
   }
};

#endif
