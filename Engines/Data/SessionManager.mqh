#ifndef __ARES_SESSIONMANAGER_MQH__
#define __ARES_SESSIONMANAGER_MQH__

class CSessionManager
{
public:
   bool IsMarketOpen() const
   {
      MqlDateTime tm;
      TimeToStruct(TimeCurrent(),tm);

      if(tm.day_of_week==0 || tm.day_of_week==6)
         return false;

      return true;
   }

   int CurrentHour() const
   {
      MqlDateTime tm;
      TimeToStruct(TimeCurrent(),tm);
      return tm.hour;
   }
};

#endif
