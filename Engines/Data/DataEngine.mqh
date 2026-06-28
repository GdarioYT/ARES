#ifndef __ARES_DATAENGINE_MQH__
#define __ARES_DATAENGINE_MQH__
#include "../../Core/Types.mqh"
#include "DataManager.mqh"

class CDataEngine
{
private:
 CDataManager m_manager;
 bool m_initialized;
public:
 CDataEngine(){m_initialized=false;}
 bool Initialize(const int capacity=5000){m_initialized=m_manager.Initialize(capacity);return m_initialized;}
 bool PushBar(const MqlRates &r)
 {
   if(!m_initialized) return false;
   SCandle c;
   c.Time=r.time;
   c.Open=r.open;
   c.High=r.high;
   c.Low=r.low;
   c.Close=r.close;
   c.TickVolume=r.tick_volume;
   return m_manager.Push(c);
 }
 bool PushCandle(const SCandle &c)
 {
   if(!m_initialized) return false;
   return m_manager.Push(c);
 }
 int Bars() const{return m_manager.Bars();}
 bool Last(SCandle &c) const{return m_manager.Last(c);}
 bool Get(const int i,SCandle &c) const{return m_manager.Get(i,c);}
 void Reset(){m_manager.Clear();m_initialized=false;}
};
#endif
