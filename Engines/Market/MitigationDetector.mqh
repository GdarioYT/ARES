#ifndef __ARES_MITIGATIONDETECTOR_MQH__
#define __ARES_MITIGATIONDETECTOR_MQH__



class CMitigationDetector
{
public:
   // Comprueba si un bloque alcista (demanda) fue mitigado
   bool IsBullishMitigated(double blockTop, double currentLow)
   {
      return currentLow <= blockTop;
   }

   // Comprueba si un bloque bajista (oferta) fue mitigado
   bool IsBearishMitigated(double blockBottom, double currentHigh)
   {
      return currentHigh >= blockBottom;
   }
};

#endif
