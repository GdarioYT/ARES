#ifndef __ARES_LIQUIDITYDETECTOR_MQH__
#define __ARES_LIQUIDITYDETECTOR_MQH__

#include "../Data/DataEngine.mqh"
#include "StructureAnalyzer.mqh"

enum ELiquidityEvent
{
   LIQUIDITY_NONE = 0,
   LIQUIDITY_SWEEP_HIGH,
   LIQUIDITY_SWEEP_LOW
};

class CLiquidityDetector
{
private:
   CDataEngine        *m_data;
   CStructureAnalyzer *m_structure;
   ELiquidityEvent     m_lastEvent;

public:
   CLiquidityDetector()
   {
      m_data=NULL;
      m_structure=NULL;
      m_lastEvent=LIQUIDITY_NONE;
   }

   bool Initialize(CDataEngine &data,CStructureAnalyzer &structure)
   {
      m_data=&data;
      m_structure=&structure;
      m_lastEvent=LIQUIDITY_NONE;
      return true;
   }

   ELiquidityEvent Analyze(const double high,
                           const double low)
   {
      m_lastEvent=LIQUIDITY_NONE;

      if(m_structure==NULL)
         return m_lastEvent;

      if(m_structure->LastHigh()>0.0 &&
         high>m_structure->LastHigh())
      {
         m_lastEvent=LIQUIDITY_SWEEP_HIGH;
      }

      if(m_structure->LastLow()>0.0 &&
         low<m_structure->LastLow())
      {
         m_lastEvent=LIQUIDITY_SWEEP_LOW;
      }

      return m_lastEvent;
   }

   ELiquidityEvent LastEvent() const
   {
      return m_lastEvent;
   }

   bool HasHighSweep() const
   {
      return m_lastEvent==LIQUIDITY_SWEEP_HIGH;
   }

   bool HasLowSweep() const
   {
      return m_lastEvent==LIQUIDITY_SWEEP_LOW;
   }
};

#endif
