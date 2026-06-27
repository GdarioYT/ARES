#ifndef __ARES_TYPES_MQH__
#define __ARES_TYPES_MQH__
enum ENUM_ENGINE_STATE{ENGINE_CREATED,ENGINE_READY};
struct SCandle{
 datetime Time;
 double Open;
 double High;
 double Low;
 double Close;
 long TickVolume;
};
#endif