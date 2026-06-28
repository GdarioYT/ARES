#ifndef __ARES_ENTRYENGINE_MQH__
#define __ARES_ENTRYENGINE_MQH__

#include "TradeSetup.mqh"

enum EEntryState
{
   ENTRY_INVALID = 0,
   ENTRY_READY,
   ENTRY_WAIT
};

struct SEntrySignal
{
   EEntryState state;
   ETradeSetupType type;

   double confidence;

   bool valid;

   void Reset()
   {
      state = ENTRY_INVALID;
      type = SETUP_NONE;

      confidence = 0.0;

      valid = false;
   }
};

class CEntryEngine
{
private:

   SEntrySignal m_signal;

public:

   CEntryEngine()
   {
      m_signal.Reset();
   }

   bool Evaluate(const CTradeSetup &setup)
   {
      m_signal.Reset();

      const STradeSetup &cfg = setup.Setup();

      if(!cfg.valid)
         return false;

      m_signal.state = ENTRY_READY;
      m_signal.type = cfg.type;
      m_signal.confidence = cfg.confidence;
      m_signal.valid = true;

      return true;
   }

   const SEntrySignal &Signal() const
   {
      return m_signal;
   }

   bool HasEntry() const
   {
      return m_signal.valid;
   }

   bool IsBuy() const
   {
      return m_signal.type == SETUP_BUY;
   }

   bool IsSell() const
   {
      return m_signal.type == SETUP_SELL;
   }
};

#endif
