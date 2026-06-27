#ifndef __ARES_STRUCTUREVALIDATOR_MQH__
#define __ARES_STRUCTUREVALIDATOR_MQH__

#include "StructureState.mqh"

class CStructureValidator
{
public:
   static bool IsValid(const SStructureState &state)
   {
      if(state.Type==STRUCTURE_UNDEFINED)
         return false;

      if(state.SwingIndex<0)
         return false;

      if(state.Price<=0.0)
         return false;

      return true;
   }

   static bool IsSwing(EMarketStructure type)
   {
      return (type==STRUCTURE_HH ||
              type==STRUCTURE_HL ||
              type==STRUCTURE_LH ||
              type==STRUCTURE_LL);
   }
};

#endif
