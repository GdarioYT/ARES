#ifndef __ARES_SWINGDETECTOR_MQH__
#define __ARES_SWINGDETECTOR_MQH__

#include "../Data/DataEngine.mqh"

enum ESwingType
{
   SWING_NONE=0,
   SWING_HIGH,
   SWING_LOW
};

class CSwingDetector
{
private:
   CDataEngine *m_engine;

public:
   CSwingDetector(){ m_engine=NULL; }

   bool Initialize(CDataEngine &engine)
   {
      m_engine=&engine;
      return true;
   }

   ESwingType Detect(const int index)
   {
      if(m_engine==NULL || m_engine->Bars()<index+3)
         return SWING_NONE;

      SCandle c0,c1,c2;
      if(!m_engine->Get(index,c0)) return SWING_NONE;
      if(!m_engine->Get(index+1,c1)) return SWING_NONE;
      if(!m_engine->Get(index+2,c2)) return SWING_NONE;

      if(c1.High>c0.High && c1.High>c2.High)
         return SWING_HIGH;

      if(c1.Low<c0.Low && c1.Low<c2.Low)
         return SWING_LOW;

      return SWING_NONE;
   }
};

#endif
