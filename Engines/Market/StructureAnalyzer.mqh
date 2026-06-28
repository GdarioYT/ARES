#ifndef __ARES_STRUCTUREANALYZER_MQH__
#define __ARES_STRUCTUREANALYZER_MQH__

#include "../Data/DataEngine.mqh"
#include "SwingDetector.mqh"

class CStructureAnalyzer
{
private:
   CDataEngine     *m_engine;
   CSwingDetector   m_detector;

public:
   CStructureAnalyzer()
   {
      m_engine=NULL;
   }

   bool Initialize(CDataEngine &engine)
   {
      m_engine=&engine;
      return m_detector.Initialize(engine);
   }

   bool IsReady() const
   {
      return(m_engine!=NULL && m_engine->Bars()>=3);
   }

   ESwingType Analyze(const int index)
   {
      if(!IsReady())
         return SWING_NONE;

      return m_detector.Detect(index);
   }

   double LastSwingHigh() const
   {
      return m_detector.LastSwingHigh();
   }

   double LastSwingLow() const
   {
      return m_detector.LastSwingLow();
   }
};

#endif
