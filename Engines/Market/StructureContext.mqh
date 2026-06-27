#ifndef __ARES_STRUCTURECONTEXT_MQH__
#define __ARES_STRUCTURECONTEXT_MQH__

#include "StructureSnapshot.mqh"

class CStructureContext
{
private:
   SStructureSnapshot m_snapshot;

public:
   void Update(const SStructureSnapshot &snapshot)
   {
      m_snapshot = snapshot;
   }

   const SStructureSnapshot &Snapshot() const
   {
      return m_snapshot;
   }

   bool Bullish() const
   {
      return (m_snapshot.Current.Type==STRUCTURE_HH ||
              m_snapshot.Current.Type==STRUCTURE_HL ||
              m_snapshot.Current.Type==STRUCTURE_BOS_BULL ||
              m_snapshot.Current.Type==STRUCTURE_CHOCH_BULL);
   }

   bool Bearish() const
   {
      return (m_snapshot.Current.Type==STRUCTURE_LL ||
              m_snapshot.Current.Type==STRUCTURE_LH ||
              m_snapshot.Current.Type==STRUCTURE_BOS_BEAR ||
              m_snapshot.Current.Type==STRUCTURE_CHOCH_BEAR);
   }
};

#endif
