#ifndef __ARES_TIMEFRAMEDATA_MQH__
#define __ARES_TIMEFRAMEDATA_MQH__

#include "../../Core/Types.mqh"
#include "SymbolData.mqh"

class CTimeframeData
{
private:
   ENUM_TIMEFRAMES m_timeframe;
   CSymbolData     m_symbolData;

public:
   bool Initialize(const string symbol,
                   const ENUM_TIMEFRAMES timeframe,
                   const int capacity=5000)
   {
      m_timeframe=timeframe;
      return m_symbolData.Initialize(symbol,capacity);
   }

   ENUM_TIMEFRAMES Timeframe() const
   {
      return m_timeframe;
   }

   bool Push(const SCandle &candle)
   {
      return m_symbolData.Push(candle);
   }

   int Bars() const
   {
      return m_symbolData.Bars();
   }

   bool Last(SCandle &candle) const
   {
      return m_symbolData.Last(candle);
   }

   void Reset()
   {
      m_symbolData.Reset();
   }
};

#endif
