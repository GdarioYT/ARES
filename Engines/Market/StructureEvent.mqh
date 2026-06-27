#ifndef __ARES_STRUCTUREEVENT_MQH__
#define __ARES_STRUCTUREEVENT_MQH__

#include "StructureState.mqh"

enum EStructureEventType
{
   EVENT_NONE=0,
   EVENT_NEW_SWING,
   EVENT_BOS,
   EVENT_CHOCH
};

struct SStructureEvent
{
   EStructureEventType Event;
   SStructureState     State;
   datetime            Time;

   SStructureEvent()
   {
      Event=EVENT_NONE;
      Time=0;
   }
};

#endif
