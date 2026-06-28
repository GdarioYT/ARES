#ifndef __ARES_MARKETENGINE_MQH__
#define __ARES_MARKETENGINE_MQH__

#include "SwingDetector.mqh"
#include "StructureAnalyzer.mqh"
#include "StructureContext.mqh"
#include "StructureSignal.mqh"

class CMarketEngine
{
private:
   CSwingDetector      m_swings;
   CStructureAnalyzer  m_analyzer;
   CStructureContext   m_context;
   SStructureSignal    m_signal;

public:
   bool Initialize(CDataEngine &data)
   {
      return m_swings.Initialize(data);
   }

   bool Update(const int index)
   {
      ESwingType swing=m_swings.Detect(index);
      if(swing==SWING_NONE)
         return false;

      m_analyzer.Update(swing,m_swings.LastSwingHigh(),m_swings.LastSwingLow());
      m_context.Update(m_analyzer.Snapshot());
      CStructureSignalBuilder::Build(m_context,m_signal);
      return true;
   }

   const SStructureSignal &Signal() const
   {
      return m_signal;
   }
};

#endif
