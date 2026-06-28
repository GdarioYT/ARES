#ifndef __ARES_STRUCTUREANALYZER_MQH__
#define __ARES_STRUCTUREANALYZER_MQH__

// ============================================================================
// ARES - StructureAnalyzer.mqh (Skeleton V2)
// Ubicación:
// ARES/Engines/Market/StructureAnalyzer.mqh
//
// NOTA:
// Esta versión añade la infraestructura para memoria estructural (HH/HL/LH/LL)
// sin cambiar la responsabilidad principal del analizador.
// Debe adaptarse a las interfaces existentes del proyecto.
// ============================================================================

enum EStructureType
{
   STRUCTURE_NONE = 0,
   STRUCTURE_HH,
   STRUCTURE_HL,
   STRUCTURE_LH,
   STRUCTURE_LL
};

class CStructureAnalyzer
{
private:
   double m_lastHigh;
   double m_prevHigh;
   double m_lastLow;
   double m_prevLow;
   EStructureType m_lastStructure;

public:
   CStructureAnalyzer()
   {
      Reset();
   }

   void Reset()
   {
      m_lastHigh=0.0;
      m_prevHigh=0.0;
      m_lastLow=0.0;
      m_prevLow=0.0;
      m_lastStructure=STRUCTURE_NONE;
   }

   void RegisterHigh(const double price)
   {
      m_prevHigh=m_lastHigh;
      m_lastHigh=price;

      if(m_prevHigh!=0.0)
         m_lastStructure=(m_lastHigh>m_prevHigh)?STRUCTURE_HH:STRUCTURE_LH;
   }

   void RegisterLow(const double price)
   {
      m_prevLow=m_lastLow;
      m_lastLow=price;

      if(m_prevLow!=0.0)
         m_lastStructure=(m_lastLow>m_prevLow)?STRUCTURE_HL:STRUCTURE_LL;
   }

   EStructureType LastStructure() const { return m_lastStructure; }

   double LastHigh() const { return m_lastHigh; }
   double PreviousHigh() const { return m_prevHigh; }

   double LastLow() const { return m_lastLow; }
   double PreviousLow() const { return m_prevLow; }

   bool IsHH() const { return m_lastStructure==STRUCTURE_HH; }
   bool IsHL() const { return m_lastStructure==STRUCTURE_HL; }
   bool IsLH() const { return m_lastStructure==STRUCTURE_LH; }
   bool IsLL() const { return m_lastStructure==STRUCTURE_LL; }
};

#endif
