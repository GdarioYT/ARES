#ifndef __ARES_PIPELINE_MQH__
#define __ARES_PIPELINE_MQH__

#include "EngineManager.mqh"

class CPipeline
{
private:
   CEngineManager *m_manager;

public:
   CPipeline()
   {
      m_manager=NULL;
   }

   bool Initialize(CEngineManager &manager)
   {
      m_manager=&manager;
      return true;
   }

   bool Execute()
   {
      return (m_manager!=NULL);
   }
};

#endif
