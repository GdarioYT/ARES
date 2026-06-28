#ifndef __ARES_TRADESETUP_MQH__
#define __ARES_TRADESETUP_MQH__

#include "ConfluenceEngine.mqh"

enum ETradeSetupType
{
   SETUP_NONE=0,
   SETUP_BUY,
   SETUP_SELL
};

struct STradeSetup
{
   ETradeSetupType type;
   double confidence;
   bool valid;

   void Reset()
   {
      type=SETUP_NONE;
      confidence=0.0;
      valid=false;
   }
};

class CTradeSetup
{
private:
   STradeSetup m_setup;

public:
   CTradeSetup(){ m_setup.Reset(); }

   bool Build(const CInstitutionalSignal &signal,
              const CConfluenceEngine &confluence)
   {
      m_setup.Reset();

      if(confluence.Score()<0.75)
         return false;

      if(signal.IsLong())
         m_setup.type=SETUP_BUY;
      else if(signal.IsShort())
         m_setup.type=SETUP_SELL;
      else
         return false;

      m_setup.confidence=confluence.Score();
      m_setup.valid=true;
      return true;
   }

   const STradeSetup &Setup() const { return m_setup; }
};

#endif
