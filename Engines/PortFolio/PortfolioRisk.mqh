#ifndef __ARES_PORTFOLIORISK_MQH__
#define __ARES_PORTFOLIORISK_MQH__

#include "PortfolioContext.mqh"

class CPortfolioRisk
{
private:
   double m_maxExposure;

public:
   CPortfolioRisk()
   {
      m_maxExposure=0.10;
   }

   void SetMaxExposure(const double value)
   {
      m_maxExposure=value;
   }

   bool CanOpen(const SPortfolioContext &ctx) const
   {
      if(!ctx.tradingEnabled)
         return false;

      return ctx.exposure<m_maxExposure;
   }

   double MaxExposure() const
   {
      return m_maxExposure;
   }
};

#endif
