#ifndef __ARES_SYSTEMRUNNER_MQH__
#define __ARES_SYSTEMRUNNER_MQH__

#include "Pipeline.mqh"
#include "SystemContext.mqh"

class CSystemRunner
{
private:
   CPipeline      m_pipeline;
   CEngineManager *m_manager;
   SSystemContext  m_context;
   bool            m_initialized;

public:
   CSystemRunner()
   {
      m_manager=NULL;
      m_initialized=false;
      m_context.Reset();
   }

   bool Initialize(CEngineManager &manager)
   {
      m_manager=&manager;
      m_initialized=m_pipeline.Initialize(manager);
      return m_initialized;
   }

   bool Run()
   {
      if(!m_initialized)
         return false;

      return m_pipeline.Execute();
   }

   SSystemContext &Context()
   {
      return m_context;
   }
};

#endif
