#ifndef __ARES_DISPLACEMENTDETECTOR_MQH__
#define __ARES_DISPLACEMENTDETECTOR_MQH__

#include "../Data/DataEngine.mqh"

class CDisplacementDetector
{
private:
   double m_multiplier; // Multiplier over average ATR or candle body

public:
   CDisplacementDetector()
   {
      m_multiplier = 2.0; // Needs to be 2x the average body size
   }

   void SetMultiplier(double multiplier) { m_multiplier = multiplier; }

   bool AnalyzeBullish(CDataEngine &data, int index, int lookback = 10)
   {
      if(data.Bars() < index + lookback) return false;

      SCandle current;
      if(!data.Get(index, current)) return false;

      double bodySize = current.Close - current.Open;
      if(bodySize <= 0) return false; // Not a bullish candle

      double avgBody = 0.0;
      for(int i = 1; i <= lookback; i++)
      {
         SCandle prev;
         if(data.Get(index + i, prev))
            avgBody += MathAbs(prev.Close - prev.Open);
      }
      avgBody /= lookback;

      return (bodySize > avgBody * m_multiplier);
   }

   bool AnalyzeBearish(CDataEngine &data, int index, int lookback = 10)
   {
      if(data.Bars() < index + lookback) return false;

      SCandle current;
      if(!data.Get(index, current)) return false;

      double bodySize = current.Open - current.Close;
      if(bodySize <= 0) return false; // Not a bearish candle

      double avgBody = 0.0;
      for(int i = 1; i <= lookback; i++)
      {
         SCandle prev;
         if(data.Get(index + i, prev))
            avgBody += MathAbs(prev.Close - prev.Open);
      }
      avgBody /= lookback;

      return (bodySize > avgBody * m_multiplier);
   }
};

#endif
