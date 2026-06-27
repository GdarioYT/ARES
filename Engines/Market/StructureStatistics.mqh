#ifndef __ARES_STRUCTURESTATISTICS_MQH__
#define __ARES_STRUCTURESTATISTICS_MQH__

#include "StructureEvent.mqh"

class CStructureStatistics
{
private:
   int m_hh,m_hl,m_lh,m_ll,m_bos,m_choch;

public:
   CStructureStatistics(){Reset();}

   void Reset()
   {
      m_hh=m_hl=m_lh=m_ll=m_bos=m_choch=0;
   }

   void Add(const SStructureEvent &event)
   {
      switch(event.State.Type)
      {
         case STRUCTURE_HH: m_hh++; break;
         case STRUCTURE_HL: m_hl++; break;
         case STRUCTURE_LH: m_lh++; break;
         case STRUCTURE_LL: m_ll++; break;
         case STRUCTURE_BOS_BULL:
         case STRUCTURE_BOS_BEAR: m_bos++; break;
         case STRUCTURE_CHOCH_BULL:
         case STRUCTURE_CHOCH_BEAR: m_choch++; break;
         default: break;
      }
   }

   int HH() const { return m_hh; }
   int HL() const { return m_hl; }
   int LH() const { return m_lh; }
   int LL() const { return m_ll; }
   int BOS() const { return m_bos; }
   int CHOCH() const { return m_choch; }
};

#endif
