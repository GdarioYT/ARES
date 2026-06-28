#ifndef __ARES_PORTFOLIOENGINE_MQH__
#define __ARES_PORTFOLIOENGINE_MQH__

#include "PortfolioContext.mqh"
#include "PortfolioRisk.mqh"

class CPortfolioEngine
{
private:
   CPortfolioRisk m_risk;

public:
   void SetMaximumExposure(const double value)
   {
      m_risk.SetMaxExposure(value);
   }

   bool CanTrade(const SPortfolioContext &context) const
   {
      return m_risk.CanOpen(context);
   }

   double MaxExposure() const
   {
      return m_risk.MaxExposure();
   }
};

#endif
