#ifndef __ARES_LOGGER_MQH__
#define __ARES_LOGGER_MQH__
class CLogger{public:static void Info(const string s){Print("[ARES] ",s);}static void Error(const string s){Print("[ARES][ERROR] ",s);} };
#endif