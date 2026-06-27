#ifndef __ARES_CHOCHDETECTOR_MQH__
#define __ARES_CHOCHDETECTOR_MQH__

#include "StructureState.mqh"

class CCHOCHDetector
{
private:
   SStructureState m_previous;
   bool            m_initialized;

public:
   CCHOCHDetector()
   {
      Reset();
   }

   void Reset()
   {
      m_previous = SStructureState();
      m_initialized = false;
   }

   bool Update(const SStructureState &state)
   {
      if(!m_initialized)
      {
         m_previous = state;
         m_initialized = true;
         return false;
      }

      bool choch =
         (m_previous.Type == STRUCTURE_HH && state.Type == STRUCTURE_LL) ||
         (m_previous.Type == STRUCTURE_HL && state.Type == STRUCTURE_LH) ||
         (m_previous.Type == STRUCTURE_LL && state.Type == STRUCTURE_HH) ||
         (m_previous.Type == STRUCTURE_LH && state.Type == STRUCTURE_HL);

      m_previous = state;
      return choch;
   }
};

#endif
