#ifndef __ARES_STRUCTUREBUFFER_MQH__
#define __ARES_STRUCTUREBUFFER_MQH__

#include "StructureEvent.mqh"

class CStructureBuffer
{
private:
   SStructureEvent m_events[];
   int             m_maxSize;

public:
   CStructureBuffer(const int maxSize=256)
   {
      m_maxSize=maxSize;
      ArrayResize(m_events,0);
   }

   void Clear()
   {
      ArrayResize(m_events,0);
   }

   int Size() const
   {
      return ArraySize(m_events);
   }

   void Push(const SStructureEvent &event)
   {
      int n=ArraySize(m_events);

      if(n>=m_maxSize)
      {
         for(int i=1;i<n;i++)
            m_events[i-1]=m_events[i];
         n--;
         ArrayResize(m_events,n);
      }

      ArrayResize(m_events,n+1);
      m_events[n]=event;
   }

   bool Get(const int index,SStructureEvent &event) const
   {
      if(index<0 || index>=ArraySize(m_events))
         return false;

      event=m_events[index];
      return true;
   }
};

#endif
