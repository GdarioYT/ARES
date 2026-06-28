#ifndef __ARES_INTELLIGENCEEVALUATOR_MQH__
#define __ARES_INTELLIGENCEEVALUATOR_MQH__

#include "IntelligenceContext.mqh"

enum EIntelligenceGrade
{
   INTELLIGENCE_REJECT=0,
   INTELLIGENCE_ACCEPT,
   INTELLIGENCE_HIGH_CONFIDENCE
};

class CIntelligenceEvaluator
{
private:
   EIntelligenceGrade m_grade;
   int                m_scoreThreshold;

public:
   CIntelligenceEvaluator()
   {
      m_grade = INTELLIGENCE_REJECT;
      m_scoreThreshold = 80; // Umbral recomendado por el Master Plan
   }

   void SetThreshold(const int threshold) { m_scoreThreshold = threshold; }

   EIntelligenceGrade Evaluate(SIntelligenceContext &ctx)
   {
      m_grade = INTELLIGENCE_REJECT;
      ctx.totalScore = 0;
      ctx.confidence = 0.0;

      // 1. Vetoes y Fases Obligatorias
      if(!ctx.valid) return m_grade;
      if(ctx.isMitigated) return m_grade; // Zonas mitigadas se rechazan
      if(!ctx.contextValid) return m_grade;
      if(!ctx.structureValid) return m_grade;
      if(!ctx.liquidityValid) return m_grade;
      if(!ctx.displacementValid) return m_grade;

      // 2. Sistema de Puntuación (Max 100)
      // Puntos base por cumplir las fases obligatorias (60 puntos)
      ctx.totalScore += 20; // Contexto OK
      ctx.totalScore += 20; // Estructura OK
      ctx.totalScore += 20; // Desplazamiento OK

      // 3. Confluencias (Suman puntos adicionales)
      if(ctx.hasSweep) ctx.totalScore += 10;
      if(ctx.hasInducement) ctx.totalScore += 10;
      
      // Si la liquidez es válida pero no tiene sweep ni inducement, asumimos que fue EQH/EQL (10 pts)
      if(ctx.liquidityValid && !ctx.hasSweep && !ctx.hasInducement) ctx.totalScore += 10;

      // Premium/Discount es confluencia fuerte (+20)
      if(ctx.isPremiumDiscount) ctx.totalScore += 20;

      if(ctx.totalScore > 100) ctx.totalScore = 100;

      ctx.confidence = ctx.totalScore / 100.0;

      // 4. Calificación final
      if(ctx.totalScore >= m_scoreThreshold)
      {
         if(ctx.totalScore >= 90)
            m_grade = INTELLIGENCE_HIGH_CONFIDENCE;
         else
            m_grade = INTELLIGENCE_ACCEPT;
      }

      return m_grade;
   }

   EIntelligenceGrade Grade() const
   {
      return m_grade;
   }
};

#endif
