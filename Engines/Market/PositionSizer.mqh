#ifndef __ARES_POSITIONSIZER_MQH__
#define __ARES_POSITIONSIZER_MQH__

#include "RiskModel.mqh"

class CPositionSizer
{
private:
   double m_minLot;
   double m_maxLot;
   double m_step;

public:
   CPositionSizer()
   {
      m_minLot = 0.01;
      m_maxLot = 100.0;
      m_step   = 0.01;
   }

   void Configure(const double minLot,
                  const double maxLot,
                  const double step)
   {
      m_minLot = minLot;
      m_maxLot = maxLot;
      m_step   = step;
   }

   double Calculate(const SRiskProfile &risk) const
   {
      if(!risk.valid)
         return 0.0;

      double lots = risk.positionSize;

      if(lots < m_minLot)
         lots = m_minLot;

      if(lots > m_maxLot)
         lots = m_maxLot;

      lots = MathFloor(lots / m_step) * m_step;

      return NormalizeDouble(lots, 2);
   }
};

#endif
