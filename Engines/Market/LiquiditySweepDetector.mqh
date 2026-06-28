#ifndef __ARES_LIQUIDITYSWEEPDETECTOR_MQH__
#define __ARES_LIQUIDITYSWEEPDETECTOR_MQH__

enum ELiquiditySweepType
{
   LIQSWEEP_NONE=0,
   LIQSWEEP_HIGH,
   LIQSWEEP_LOW
};

struct SLiquiditySweep
{
   ELiquiditySweepType type;
   double level;
   int index;
   bool valid;

   void Reset()
   {
      type=LIQSWEEP_NONE;
      level=0.0;
      index=-1;
      valid=false;
   }
};

class CLiquiditySweepDetector
{
private:
   SLiquiditySweep m_last;

public:
   CLiquiditySweepDetector()
   {
      m_last.Reset();
   }

   bool Analyze(const MqlRates &current,
                const double referenceHigh,
                const double referenceLow,
                const int index)
   {
      m_last.Reset();

      if(current.high>referenceHigh && current.close<referenceHigh)
      {
         m_last.type=LIQSWEEP_HIGH;
         m_last.level=referenceHigh;
      }
      else if(current.low<referenceLow && current.close>referenceLow)
      {
         m_last.type=LIQSWEEP_LOW;
         m_last.level=referenceLow;
      }
      else
      {
         return false;
      }

      m_last.index=index;
      m_last.valid=true;
      return true;
   }

   const SLiquiditySweep &LastSweep() const { return m_last; }
   bool HasSweep() const { return m_last.valid; }
};

#endif
