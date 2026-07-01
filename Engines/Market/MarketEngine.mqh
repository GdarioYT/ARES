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
   datetime            m_lastBarTime;

public:
   CMarketEngine()
   {
      m_data        = NULL;
      m_lastBarTime = 0;
   }

   bool Initialize(CDataEngine &data, const int swingLookback = 2)
   {
      m_data        = &data;
      m_lastBarTime = 0;

      if(!m_structure.Initialize(data, swingLookback))
         return false;

      m_bos.Initialize(m_structure);
      m_choch.Initialize(m_structure);

      return true;
   }

   bool Update(const int index)
   {
      if(m_data == NULL) return false;

      // Guard: procesar cada barra solo UNA VEZ por tick
      // Sin esto, la misma vela cerrada se analizaba en cada tick → BOS spam
      SCandle c;
      if(!m_data.Get(index, c)) return false;
      if(c.Time == m_lastBarTime) return true;
      m_lastBarTime = c.Time;

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
