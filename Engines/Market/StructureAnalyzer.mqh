#ifndef __ARES_STRUCTUREANALYZER_MQH__
#define __ARES_STRUCTUREANALYZER_MQH__

#include "../Data/DataEngine.mqh"

class CStructureAnalyzer
{
private:
   CDataEngine *m_engine;

public:
   CStructureAnalyzer()
   {
      m_engine=NULL;
   }

   bool Initialize(CDataEngine &engine)
   {
      m_engine=&engine;
      return(true);
   }

   bool IsReady() const
   {
      return(m_engine!=NULL && m_engine->Bars()>=3);
   }

   bool GetLastThree(SCandle &c0,SCandle &c1,SCandle &c2) const
   {
      if(!IsReady())
         return(false);

      return m_engine->Get(0,c0)
          && m_engine->Get(1,c1)
          && m_engine->Get(2,c2);
   }
};

#endif
