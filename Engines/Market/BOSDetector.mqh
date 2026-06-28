#ifndef __ARES_BOSDETECTOR_MQH__
#define __ARES_BOSDETECTOR_MQH__

#include "StructureState.mqh"

class CBOSDetector
{
private:
   SStructureState m_last;

public:
   void Reset()
   {
      m_last=SStructureState();
   }

   bool Update(const SStructureState &state)
   {
      bool changed=(state.Type!=m_last.Type);
      m_last=state;
      return changed;
   }

   const SStructureState &Last() const
   {
      return m_last;
   }
};



   bool IsBullishBOS() const
   {
      return (m_structure!=NULL &&
              m_structure->LastStructure()==STRUCTURE_HH);
   }

   bool IsBearishBOS() const
   {
      return (m_structure!=NULL &&
              m_structure->LastStructure()==STRUCTURE_LL);
   }

#endif
