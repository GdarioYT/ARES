#ifndef __ARES_DATAVALIDATOR_MQH__
#define __ARES_DATAVALIDATOR_MQH__

#include "../../Core/Types.mqh"

class CDataValidator
{
public:
   bool Validate(const SCandle &candle) const
   {
      if(candle.High < candle.Low)
         return false;

      if(candle.Open > candle.High || candle.Open < candle.Low)
         return false;

      if(candle.Close > candle.High || candle.Close < candle.Low)
         return false;

      return true;
   }
};

#endif
