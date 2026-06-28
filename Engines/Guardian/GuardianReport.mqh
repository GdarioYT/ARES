#ifndef __ARES_GUARDIANREPORT_MQH__
#define __ARES_GUARDIANREPORT_MQH__

#include "GuardianMonitor.mqh"

struct SGuardianReport
{
   int allowed;
   int blocked;
   int paused;
   double blockRate;

   void Build(const CGuardianMonitor &monitor)
   {
      allowed = monitor.Allows();
      blocked = monitor.Blocks();
      paused = monitor.Pauses();

      int total = allowed + blocked + paused;
      blockRate = (total>0) ? (double)blocked / (double)total : 0.0;
   }
};

#endif
