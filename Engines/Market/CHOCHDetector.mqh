#ifndef __ARES_CHOCHDETECTOR_MQH__
#define __ARES_CHOCHDETECTOR_MQH__

#include "StructureAnalyzer.mqh"
#include "BOSDetector.mqh"

class CCHOCHDetector
{
private:
   CStructureAnalyzer *m_structure;
   EStructureClass     m_previous;

public:
   CCHOCHDetector()
   {
      m_structure=NULL;
      m_previous=STRUCTURE_UNKNOWN;
   }

   bool Initialize(CStructureAnalyzer &structure)
   {
      m_structure=&structure;
      m_previous=STRUCTURE_UNKNOWN;
      return true;
   }

   bool Update()
   {
      if(m_structure==NULL)
         return false;

      m_previous=m_structure->LastStructure();
      return true;
   }

   bool IsBullishCHOCH() const
   {
      if(m_structure==NULL)
         return false;

      EStructureClass current=m_structure->LastStructure();

      return (m_previous==STRUCTURE_LL || m_previous==STRUCTURE_LH) &&
             (current==STRUCTURE_HL || current==STRUCTURE_HH);
   }

   bool IsBearishCHOCH() const
   {
      if(m_structure==NULL)
         return false;

      EStructureClass current=m_structure->LastStructure();

      return (m_previous==STRUCTURE_HH || m_previous==STRUCTURE_HL) &&
             (current==STRUCTURE_LH || current==STRUCTURE_LL);
   }
};

#endif
