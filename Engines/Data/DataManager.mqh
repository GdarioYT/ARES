#ifndef __ARES_DATAMANAGER_MQH__
#define __ARES_DATAMANAGER_MQH__

#include "../../Core/Types.mqh"
#include "TimeSeries.mqh"

class CDataManager
{
private:
   CTimeSeries m_series;

public:
   bool Initialize(const int capacity)
   {
      return m_series.Initialize(capacity);
   }

   bool Push(const SCandle &candle)
   {
      return m_series.Add(candle);
   }

   int Bars() const
   {
      return m_series.Count();
   }

   bool Last(SCandle &out) const
   {
      return m_series.Last(out);
   }

   bool Get(const int index,SCandle &out) const
   {
      return m_series.Get(index,out);
   }

   void Clear()
   {
      m_series.Clear();
   }
};

#endif
