#ifndef __ARES_STRUCTUREVERSION_MQH__
#define __ARES_STRUCTUREVERSION_MQH__

#define ARES_STRUCTURE_ENGINE_MAJOR 1
#define ARES_STRUCTURE_ENGINE_MINOR 0
#define ARES_STRUCTURE_ENGINE_PATCH 0

inline string StructureEngineVersion()
{
   return StringFormat("%d.%d.%d",
                       ARES_STRUCTURE_ENGINE_MAJOR,
                       ARES_STRUCTURE_ENGINE_MINOR,
                       ARES_STRUCTURE_ENGINE_PATCH);
}

#endif
