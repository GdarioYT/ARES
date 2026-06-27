#ifndef __ARES_STRUCTURECACHE_MQH__
#define __ARES_STRUCTURECACHE_MQH__

#include "StructureSnapshot.mqh"

class CStructureCache
{
private:
   SStructureSnapshot m_snapshot;
   bool               m_valid;

public:
   CStructureCache()
   {
      Clear();
   }

   void Clear()
   {
      m_valid=false;
   }

   void Store(const SStructureSnapshot &snapshot)
   {
      m_snapshot=snapshot;
      m_valid=true;
   }

   bool Load(SStructureSnapshot &snapshot) const
   {
      if(!m_valid)
         return false;
      snapshot=m_snapshot;
      return true;
   }

   bool IsValid() const
   {
      return m_valid;
   }
};

#endif
