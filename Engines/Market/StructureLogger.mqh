#ifndef __ARES_STRUCTURELOGGER_MQH__
#define __ARES_STRUCTURELOGGER_MQH__

#include "StructureEvent.mqh"

class CStructureLogger
{
private:
   bool m_enabled;

public:
   CStructureLogger()
   {
      m_enabled=true;
   }

   void Enable(const bool enabled)
   {
      m_enabled=enabled;
   }

   bool Enabled() const
   {
      return m_enabled;
   }

   void Log(const SStructureEvent &event)
   {
      if(!m_enabled)
         return;

      PrintFormat("[Structure] Event=%d Type=%d Index=%d Price=%.5f",
                  event.Event,
                  event.State.Type,
                  event.State.SwingIndex,
                  event.State.Price);
   }
};

#endif
