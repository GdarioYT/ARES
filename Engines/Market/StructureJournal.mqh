#ifndef __ARES_STRUCTUREJOURNAL_MQH__
#define __ARES_STRUCTUREJOURNAL_MQH__

#include "StructureEvent.mqh"

class CStructureJournal
{
private:
   SStructureEvent m_lastEvent;

public:
   void Reset()
   {
      m_lastEvent = SStructureEvent();
   }

   void Record(const SStructureEvent &event)
   {
      m_lastEvent = event;
   }

   const SStructureEvent &LastEvent() const
   {
      return m_lastEvent;
   }

   bool HasEvent() const
   {
      return (m_lastEvent.Event != EVENT_NONE);
   }
};

#endif
