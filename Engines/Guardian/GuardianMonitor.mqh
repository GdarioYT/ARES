#ifndef __ARES_GUARDIANMONITOR_MQH__
#define __ARES_GUARDIANMONITOR_MQH__

#include "GuardianContext.mqh"

class CGuardianMonitor
{
private:
   int m_blocks;
   int m_pauses;
   int m_allows;

public:
   CGuardianMonitor()
   {
      Reset();
   }

   void Reset()
   {
      m_blocks=0;
      m_pauses=0;
      m_allows=0;
   }

   void Register(const SGuardianContext &ctx)
   {
      switch(ctx.status)
      {
         case GUARDIAN_ALLOW: ++m_allows; break;
         case GUARDIAN_BLOCK: ++m_blocks; break;
         case GUARDIAN_PAUSE: ++m_pauses; break;
      }
   }

   int Blocks() const { return m_blocks; }
   int Pauses() const { return m_pauses; }
   int Allows() const { return m_allows; }
};

#endif
