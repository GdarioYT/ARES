#ifndef __ARES_STRUCTUREFILTER_MQH__
#define __ARES_STRUCTUREFILTER_MQH__

#include "StructureSignal.mqh"

class CStructureFilter
{
public:
   static bool Accept(const SStructureSignal &signal,
                      const EStructureBias requiredBias,
                      const bool requireBOS=false,
                      const bool requireCHOCH=false)
   {
      if(requiredBias!=BIAS_NEUTRAL && signal.Bias!=requiredBias)
         return false;

      if(requireBOS && !signal.HasBOS)
         return false;

      if(requireCHOCH && !signal.HasCHOCH)
         return false;

      return true;
   }
};

#endif
