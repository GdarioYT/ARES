#ifndef __ARES_SYMBOLDATA_MQH__
#define __ARES_SYMBOLDATA_MQH__

#include "../../Core/Types.mqh"
#include "DataEngine.mqh"

class CSymbolData
{
private:
   string      m_symbol;
   CDataEngine m_engine;

public:
   bool Initialize(const string symbol,const int capacity=5000)
   {
      m_symbol=symbol;
      return m_engine.Initialize(capacity);
   }

   string Symbol() const
   {
      return m_symbol;
   }

   bool Push(const SCandle &candle)
   {
      return m_engine.PushCandle(candle);
   }

   int Bars() const
   {
      return m_engine.Bars();
   }

   bool Last(SCandle &candle) const
   {
      return m_engine.Last(candle);
   }

   void Reset()
   {
      m_engine.Reset();
   }
};

#endif
