#ifndef __ARES_MARKETENGINE_MQH__
#define __ARES_MARKETENGINE_MQH__

#include "../Data/DataEngine.mqh"
#include "StructureAnalyzer.mqh"
#include "BOSDetector.mqh"
#include "CHOCHDetector.mqh"

class CMarketEngine
{
private:
   CDataEngine        *m_data;
   CStructureAnalyzer  m_structure;
   CBOSDetector        m_bos;
   CCHOCHDetector      m_choch;

public:
   CMarketEngine()
   {
      m_data=NULL;
   }

   bool Initialize(CDataEngine &data, const int swingLookback = 2)
   {
      m_data = &data;

      if(!m_structure.Initialize(data, swingLookback))
         return false;

      m_bos.Initialize(m_structure);
      m_choch.Initialize(m_structure);

      return true;
   }

   bool Update(const int index)
   {
      m_structure.Analyze(index);
      
      SStructureState sState;
      sState.Type = m_structure.LastStructure();
      if(sState.Type == STRUCTURE_HH || sState.Type == STRUCTURE_LH)
         sState.Price = m_structure.LastHigh();
      else if(sState.Type == STRUCTURE_LL || sState.Type == STRUCTURE_HL)
         sState.Price = m_structure.LastLow();
      else
         sState.Price = 0.0;
      
      m_bos.Update(sState);
      m_choch.Update();
      return true;
   }

   CStructureAnalyzer *Structure()
   {
      return &m_structure;
   }

   CBOSDetector *BOS()
   {
      return &m_bos;
   }

   CCHOCHDetector *CHOCH()
   {
      return &m_choch;
   }
};

#endif
