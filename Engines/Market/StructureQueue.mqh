#ifndef __ARES_STRUCTUREQUEUE_MQH__
#define __ARES_STRUCTUREQUEUE_MQH__

#include "StructureEvent.mqh"

class CStructureQueue
{
private:
   SStructureEvent m_items[];

public:
   void Clear()
   {
      ArrayResize(m_items,0);
   }

   int Count() const
   {
      return ArraySize(m_items);
   }

   void Push(const SStructureEvent &event)
   {
      int n=ArraySize(m_items);
      ArrayResize(m_items,n+1);
      m_items[n]=event;
   }

   bool Pop(SStructureEvent &event)
   {
      int n=ArraySize(m_items);
      if(n==0)
         return false;

      event=m_items[0];

      for(int i=1;i<n;i++)
         m_items[i-1]=m_items[i];

      ArrayResize(m_items,n-1);
      return true;
   }
};

#endif
