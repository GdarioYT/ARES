#ifndef __ARES_BOSDETECTOR_MQH__
#define __ARES_BOSDETECTOR_MQH__

#include "StructureAnalyzer.mqh"
#include "StructureState.mqh"

// ============================================================================
// ARES - BOSDetector.mqh
// Detecta Break of Structure (BOS) consultando el último tipo de estructura
// registrado en CStructureAnalyzer.
//   BOS Alcista  → nuevo HH (precio rompe el máximo previo)
//   BOS Bajista  → nuevo LL  (precio rompe el mínimo previo)
// ============================================================================

class CBOSDetector
{
private:
   CStructureAnalyzer *m_structure;
   SStructureState     m_last;

public:
   CBOSDetector()
   {
      m_structure = NULL;
   }

   void Initialize(CStructureAnalyzer &structure)
   {
      m_structure = &structure;
   }

   void Reset()
   {
      m_last = SStructureState();
   }

   bool Update(const SStructureState &state)
   {
      bool changed = (state.Type != m_last.Type);
      m_last = state;
      return changed;
   }

   SStructureState Last() const
   {
      return m_last;
   }

   bool IsBullishBOS() const
   {
      return (m_structure != NULL &&
              m_structure->LastStructure() == STRUCTURE_HH);
   }

   bool IsBearishBOS() const
   {
      return (m_structure != NULL &&
              m_structure->LastStructure() == STRUCTURE_LL);
   }
};

#endif
