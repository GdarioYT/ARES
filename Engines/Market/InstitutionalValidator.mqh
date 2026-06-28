#ifndef __ARES_INSTITUTIONALVALIDATOR_MQH__
#define __ARES_INSTITUTIONALVALIDATOR_MQH__

#include "InstitutionalEntryEngine.mqh"

class CInstitutionalValidator
{
private:
   double m_minConfluence;

public:
   CInstitutionalValidator()
   {
      m_minConfluence=0.75;
   }

   void SetMinimumConfluence(const double value)
   {
      m_minConfluence=value;
   }

   bool Validate(const CInstitutionalCoordinator &coordinator) const
   {
      return coordinator.Confluence().Score()>=m_minConfluence;
   }

   bool Validate(const CInstitutionalEntryEngine &engine,
                 const CInstitutionalCoordinator &coordinator) const
   {
      if(!engine.Ready())
         return false;

      return Validate(coordinator);
   }
};

#endif
