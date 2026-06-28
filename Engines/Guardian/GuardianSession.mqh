#ifndef __ARES_GUARDIANSESSION_MQH__
#define __ARES_GUARDIANSESSION_MQH__

#include "GuardianConfig.mqh"

class CGuardianSession
{
private:
   CGuardianConfig m_config;
   int m_consecutiveLosses;
   bool m_paused;

public:
   CGuardianSession()
   {
      Reset();
   }

   void Reset()
   {
      m_config.Reset();
      m_consecutiveLosses=0;
      m_paused=false;
   }

   void SetConfig(const CGuardianConfig &config)
   {
      m_config=config;
   }

   void RegisterWin()
   {
      m_consecutiveLosses=0;
   }

   void RegisterLoss()
   {
      m_consecutiveLosses++;
      if(m_config.PauseEnabled() &&
         m_consecutiveLosses>=m_config.MaxConsecutiveLosses())
         m_paused=true;
   }

   bool IsPaused() const
   {
      return m_paused;
   }

   void Resume()
   {
      m_paused=false;
      m_consecutiveLosses=0;
   }

   int ConsecutiveLosses() const
   {
      return m_consecutiveLosses;
   }
};

#endif
