#ifndef __ARES_CANDLEBUFFER_MQH__
#define __ARES_CANDLEBUFFER_MQH__

#include "../../Core/Types.mqh"

class CCandleBuffer
{
private:
   SCandle m_data[];
   int      m_capacity;

public:
   CCandleBuffer()
   {
      m_capacity=0;
   }

   bool Reserve(const int capacity)
   {
      if(capacity<=0)
         return(false);

      m_capacity=capacity;
      return(ArrayResize(m_data,capacity)==capacity);
   }

   void Clear()
   {
      ArrayResize(m_data,0);
      m_capacity=0;
   }

   int Count() const
   {
      return(ArraySize(m_data));
   }

   bool Add(const SCandle &candle)
   {
      int sz=ArraySize(m_data);
      if(ArrayResize(m_data,sz+1)!=sz+1)
         return(false);

      m_data[sz]=candle;
      return(true);
   }

   bool Get(const int index,SCandle &out) const
   {
      if(index<0 || index>=ArraySize(m_data))
         return(false);

      out=m_data[index];
      return(true);
   }

   bool Last(SCandle &out) const
   {
      int sz=ArraySize(m_data);
      if(sz==0)
         return(false);

      out=m_data[sz-1];
      return(true);
   }

   bool UpdateLast(const SCandle &candle)
   {
      int sz=ArraySize(m_data);
      if(sz==0) return false;
      m_data[sz-1] = candle;
      return true;
   }
};

#endif
