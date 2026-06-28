#ifndef __ARES_LEARNINGENGINE_MQH__
#define __ARES_LEARNINGENGINE_MQH__

#include "LearningContext.mqh"

class CLearningEngine
{
private:
   int m_samples;
   double m_totalPnL;

public:
   CLearningEngine()
   {
      Reset();
   }

   void Reset()
   {
      m_samples=0;
      m_totalPnL=0.0;
   }

   void Update(const SLearningContext &ctx)
   {
      if(!ctx.completed)
         return;

      ++m_samples;
      m_totalPnL+=ctx.pnl;
   }

   int Samples() const
   {
      return m_samples;
   }

   double AveragePnL() const
   {
      if(m_samples==0)
         return 0.0;

      return m_totalPnL/(double)m_samples;
   }
};

#endif
