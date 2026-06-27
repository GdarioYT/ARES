#ifndef __ARES_DATAENGINE_MQH__
#define __ARES_DATAENGINE_MQH__
#include "../../Core/Types.mqh"
#include "CandleBuffer.mqh"
class CDataEngine{
private:
 ENUM_ENGINE_STATE m_state;
 CCandleBuffer m_buffer;
public:
 CDataEngine(){m_state=ENGINE_CREATED;}
 bool Initialize(){m_state=ENGINE_READY;return(true);}
 bool PushBar(const MqlRates &r){
   SCandle c;
   c.Time=r.time;
   c.Open=r.open;
   c.High=r.high;
   c.Low=r.low;
   c.Close=r.close;
   c.TickVolume=r.tick_volume;
   return m_buffer.Add(c);
 }
 int Count()const{return m_buffer.Count();}
};
#endif