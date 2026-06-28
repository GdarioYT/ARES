#ifndef __ARES_INSTITUTIONALTRADEFLOW_MQH__
#define __ARES_INSTITUTIONALTRADEFLOW_MQH__

#include "InstitutionalCoordinator.mqh"
#include "TradeCoordinator.mqh"

class CInstitutionalTradeFlow
{
private:
   CInstitutionalCoordinator *m_institutional;
   CTradeCoordinator         *m_trade;

public:
   CInstitutionalTradeFlow()
   {
      m_institutional=NULL;
      m_trade=NULL;
   }

   bool Initialize(CInstitutionalCoordinator &institutional,
                   CTradeCoordinator &trade)
   {
      m_institutional=&institutional;
      m_trade=&trade;
      return true;
   }

   bool Ready() const
   {
      return (m_institutional!=NULL &&
              m_trade!=NULL);
   }

   const CInstitutionalCoordinator &Institutional() const
   {
      return *m_institutional;
   }

   CTradeCoordinator &Trade()
   {
      return *m_trade;
   }
};

#endif
