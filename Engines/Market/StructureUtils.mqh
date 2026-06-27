#ifndef __ARES_STRUCTUREUTILS_MQH__
#define __ARES_STRUCTUREUTILS_MQH__

#include "StructureState.mqh"

class CStructureUtils
{
public:
   static bool IsBullish(const EMarketStructure type)
   {
      return (type==STRUCTURE_HH ||
              type==STRUCTURE_HL ||
              type==STRUCTURE_BOS_BULL ||
              type==STRUCTURE_CHOCH_BULL);
   }

   static bool IsBearish(const EMarketStructure type)
   {
      return (type==STRUCTURE_LL ||
              type==STRUCTURE_LH ||
              type==STRUCTURE_BOS_BEAR ||
              type==STRUCTURE_CHOCH_BEAR);
   }

   static bool IsBOS(const EMarketStructure type)
   {
      return (type==STRUCTURE_BOS_BULL ||
              type==STRUCTURE_BOS_BEAR);
   }

   static bool IsCHOCH(const EMarketStructure type)
   {
      return (type==STRUCTURE_CHOCH_BULL ||
              type==STRUCTURE_CHOCH_BEAR);
   }
};

#endif
