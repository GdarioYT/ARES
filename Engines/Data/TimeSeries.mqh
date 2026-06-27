#ifndef __ARES_TIMESERIES_MQH__
#define __ARES_TIMESERIES_MQH__

#include "../../Core/Types.mqh"
#include "CandleBuffer.mqh"

class CTimeSeries
{
private:
   CCandleBuffer m_buffer;

public:
   bool Initialize(const int capacity)
   {
      return m_buffer.Reserve(capacity);
   }

   bool Add(const SCandle &candle)
   {
      return m_buffer.Add(candle);
   }

   int Count() const
   {
      return m_buffer.Count();
   }

   bool Last(SCandle &out) const
   {
      return m_buffer.Last(out);
   }

   bool Get(const int index,SCandle &out) const
   {
      return m_buffer.Get(index,out);
   }

   void Clear()
   {
      m_buffer.Clear();
   }
};

#endif
