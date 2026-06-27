#ifndef __ARES_STRUCTUREFACTORY_MQH__
#define __ARES_STRUCTUREFACTORY_MQH__

#include "StructureConfig.mqh"
#include "StructureContext.mqh"
#include "StructureStatistics.mqh"
#include "StructureJournal.mqh"

class CStructureFactory
{
public:
   static SStructureConfig DefaultConfig()
   {
      return SStructureConfig();
   }

   static CStructureStatistics CreateStatistics()
   {
      return CStructureStatistics();
   }

   static CStructureContext CreateContext()
   {
      return CStructureContext();
   }

   static CStructureJournal CreateJournal()
   {
      return CStructureJournal();
   }
};

#endif
