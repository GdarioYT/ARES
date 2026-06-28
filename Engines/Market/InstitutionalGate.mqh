#ifndef __ARES_INSTITUTIONALGATE_MQH__
#define __ARES_INSTITUTIONALGATE_MQH__

#include "InstitutionalValidator.mqh"
#include "InstitutionalTradeFlow.mqh"

class CInstitutionalGate
{
private:
   CInstitutionalValidator m_validator;

public:
   void SetMinimumConfluence(const double value)
   {
      m_validator.SetMinimumConfluence(value);
   }

   bool Allow(const CInstitutionalEntryEngine &engine,
              const CInstitutionalCoordinator &coordinator) const
   {
      return m_validator.Validate(engine,coordinator);
   }
};

#endif
