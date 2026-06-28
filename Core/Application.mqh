#ifndef __ARES_APPLICATION_MQH__
#define __ARES_APPLICATION_MQH__

#include "EngineManager.mqh"
#include "SystemRunner.mqh"

class CApplication
{
private:
   CEngineManager m_engines;
   CSystemRunner  m_runner;

public:
   bool Initialize()
   {
      if(!m_engines.Initialize())
         return false;

      return m_runner.Initialize(m_engines);
   }

   bool Tick()
   {
      return m_runner.Run();
   }

   void Shutdown()
   {
   }

   CEngineManager *Engines()
   {
      return &m_engines;
   }

   CSystemRunner *Runner()
   {
      return &m_runner;
   }
};

#endif
