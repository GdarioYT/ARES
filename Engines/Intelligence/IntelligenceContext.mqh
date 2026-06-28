#ifndef __ARES_INTELLIGENCECONTEXT_MQH__
#define __ARES_INTELLIGENCECONTEXT_MQH__

#include "../Market/MarketContext.mqh"
#include "../Pattern/PatternResult.mqh"

struct SIntelligenceContext
{
   SMarketContext market;
   SPatternResult pattern;
   
   // Evidencias (Fases 1 a 5)
   bool contextValid;        // Fase 1: Tendencia, Sesión (Obligatorio)
   bool structureValid;      // Fase 2: BOS o CHOCH (Obligatorio)
   bool liquidityValid;      // Fase 3: Sweep o Inducement o EQH/EQL (Obligatorio)
   bool displacementValid;   // Fase 4: Impulso fuerte o FVG (Obligatorio)
   
   // Confluencias (Fase 5 y adicionales)
   bool isPremiumDiscount;   // POI en zona de descuento/premium (Confluencia)
   bool hasInducement;       // Inducement explícito
   bool hasSweep;            // Barrido explícito
   bool isMitigated;         // Bloque ya mitigado (Suele ser negativo o veto)

   int    totalScore;
   double confidence;
   bool   valid;

   void Reset()
   {
      market.Reset();
      pattern.Reset();
      
      contextValid = false;
      structureValid = false;
      liquidityValid = false;
      displacementValid = false;
      
      isPremiumDiscount = false;
      hasInducement = false;
      hasSweep = false;
      isMitigated = false;

      totalScore = 0;
      confidence = 0.0;
      valid = false;
   }
};

#endif
