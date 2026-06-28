#ifndef __ARES_MARKETSTRUCTURE_MQH__
#define __ARES_MARKETSTRUCTURE_MQH__

#include "StructureAnalyzer.mqh"
#include "BOSDetector.mqh"
#include "CHOCHDetector.mqh"
#include "LiquidityDetector.mqh"

enum EMarketPhase
{
   MARKET_PHASE_UNKNOWN=0,
   MARKET_PHASE_ACCUMULATION,
   MARKET_PHASE_MARKUP,
   MARKET_PHASE_DISTRIBUTION,
   MARKET_PHASE_MARKDOWN
};

class CMarketStructure
{
private:
   EMarketPhase m_phase;

public:
   CMarketStructure()
   {
      m_phase=MARKET_PHASE_UNKNOWN;
   }

   EMarketPhase Update(const CBOSDetector &bos,
                       const CCHOCHDetector &choch,
                       const CLiquidityDetector &liq)
   {
      if(choch.IsBullishCHOCH())
         m_phase=MARKET_PHASE_ACCUMULATION;
      else if(choch.IsBearishCHOCH())
         m_phase=MARKET_PHASE_DISTRIBUTION;
      else if(bos.IsBullishBOS())
         m_phase=MARKET_PHASE_MARKUP;
      else if(bos.IsBearishBOS())
         m_phase=MARKET_PHASE_MARKDOWN;

      return m_phase;
   }

   EMarketPhase Phase() const { return m_phase; }
};

#endif
