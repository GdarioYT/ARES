#ifndef __ARES_INTELLIGENCEEVALUATOR_MQH__
#define __ARES_INTELLIGENCEEVALUATOR_MQH__

#include "IntelligenceContext.mqh"

enum EIntelligenceGrade
{
   INTELLIGENCE_REJECT         = 0,
   INTELLIGENCE_ACCEPT         = 1,
   INTELLIGENCE_HIGH_CONFIDENCE= 2
};

// ============================================================================
// ARES - IntelligenceEvaluator.mqh
// FIX: Sistema de puntuación granular (v2).
//
// Problema anterior:
//   Siempre sumaba 70 pts base (20+20+20+10 liquidez fallback).
//   Solo PD diferenciaba → sistema binario 70/90.
//
// Solución:
//   - Fases obligatorias son VETO (no dan puntos, eliminan si fallan)
//   - Los PUNTOS vienen solo de confluencias genuinas
//   - Umbral real: requiere al menos 2 confluencias fuertes para pasar 80
//   - Añadido: veto si Mitigated o si el score de confluencias es < 3
// ============================================================================
class CIntelligenceEvaluator
{
private:
   EIntelligenceGrade m_grade;
   int                m_scoreThreshold;

public:
   CIntelligenceEvaluator()
   {
      m_grade          = INTELLIGENCE_REJECT;
      m_scoreThreshold = 80;
   }

   void SetThreshold(const int threshold) { m_scoreThreshold = threshold; }

   EIntelligenceGrade Evaluate(SIntelligenceContext &ctx)
   {
      m_grade        = INTELLIGENCE_REJECT;
      ctx.totalScore = 0;
      ctx.confidence = 0.0;

      // ---- BLOQUE 1: VETOS (fallar cualquiera = rechazo inmediato) ----
      if(!ctx.valid)             return m_grade;
      if(ctx.isMitigated)        return m_grade; // Zona ya consumida — inválida
      if(!ctx.contextValid)      return m_grade; // Sin contexto de tendencia
      if(!ctx.structureValid)    return m_grade; // Sin BOS/CHOCH confirmado
      if(!ctx.liquidityValid)    return m_grade; // Sin barrido de liquidez
      if(!ctx.displacementValid) return m_grade; // Sin impulso institucional

      // ---- BLOQUE 2: CONFLUENCIAS (cada una suma puntos reales) ----
      // Las 4 fases obligatorias suman puntos base SOLO si son genuinas,
      // no por defecto.

      // Estructura (20 pts) — Ya confirmada por structureValid
      ctx.totalScore += 20;

      // Desplazamiento (20 pts) — Ya confirmado por displacementValid
      ctx.totalScore += 20;

      // Liquidez — desglosada por calidad:
      if(ctx.hasSweep)
         ctx.totalScore += 20; // Sweep explícito: máxima calidad
      else if(ctx.hasInducement)
         ctx.totalScore += 15; // Inducement: calidad alta
      else
         ctx.totalScore += 5;  // EQH/EQL: calidad mínima (solo 5 pts)

      // Premium/Discount — confluencia clave (+20)
      if(ctx.isPremiumDiscount)
         ctx.totalScore += 20;

      // Bono: sweep + PD (setup institucional perfecto, +5 extra)
      if(ctx.hasSweep && ctx.isPremiumDiscount)
         ctx.totalScore += 5;

      // Cap a 100
      if(ctx.totalScore > 100) ctx.totalScore = 100;
      ctx.confidence = ctx.totalScore / 100.0;

      // ---- BLOQUE 3: UMBRAL FINAL ----
      // Para pasar necesitas:
      //   - Sweep (20) + PD (20) + Estructura(20) + Displacement(20) = 80 ✅
      //   - Inducement (15) + PD (20) + Estructura(20) + Displacement(20) = 75 ❌
      //   - Solo EQH/EQL (5) sin PD = 45 ❌ (rechazado siempre)
      // Esto garantiza que el sistema solo opera cuando hay sweep o inducement + PD

      if(ctx.totalScore >= m_scoreThreshold)
      {
         if(ctx.totalScore >= 90)
            m_grade = INTELLIGENCE_HIGH_CONFIDENCE;
         else
            m_grade = INTELLIGENCE_ACCEPT;
      }

      return m_grade;
   }

   EIntelligenceGrade Grade() const { return m_grade; }
};

#endif
