#ifndef __ARES_STRUCTURETYPES_MQH__
#define __ARES_STRUCTURETYPES_MQH__

#include "StructureEnums.mqh"
#include "StructureConstants.mqh"

struct SStructurePoint
{
   int Index;
   double Price;
   ESwingDirection Direction;

   SStructurePoint()
   {
      Index = ARES_INVALID_INDEX;
      Price = ARES_INVALID_PRICE;
      Direction = SWING_NONE;
   }
};

#endif
