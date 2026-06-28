#ifndef __ARES_PIPELINE_MQH__
#define __ARES_PIPELINE_MQH__

#include "EngineManager.mqh"
#include "../Engines/Market/EqualHighEqualLowDetector.mqh"
#include "../Engines/Market/InducementDetector.mqh"
#include "../Engines/Market/DisplacementDetector.mqh"
#include "../Engines/Market/PremiumDiscountDetector.mqh"
#include "../Engines/Market/MitigationDetector.mqh"

class CPipeline
{
private:
   CEngineManager *m_manager;

   // Detectores independientes de evidencia
   CEqualHighEqualLowDetector m_eqhl;
   CInducementDetector m_inducement;
   CDisplacementDetector m_displacement;
   CPremiumDiscountDetector m_pd;
   CMitigationDetector m_mitigation;

public:
   CPipeline()
   {
      m_manager=NULL;
   }

   bool Initialize(CEngineManager &manager)
   {
      m_manager=&manager;
      return true;
   }

   bool Execute()
   {
      if(m_manager == NULL) return false;

      // Update MarketEngine with the latest closed candle
      m_manager.Market().Update(1);

      bool isBullishBOS = m_manager.Market().BOS().IsBullishBOS();
      bool isBearishBOS = m_manager.Market().BOS().IsBearishBOS();
      bool isBullishCHOCH = m_manager.Market().CHOCH().IsBullishCHOCH();
      bool isBearishCHOCH = m_manager.Market().CHOCH().IsBearishCHOCH();

      // Log básico de estructura
      if(isBullishBOS) Print("[ARES] Bullish BOS Detected!");
      if(isBearishBOS) Print("[ARES] Bearish BOS Detected!");
      if(isBullishCHOCH) Print("[ARES] Bullish CHOCH Detected!");
      if(isBearishCHOCH) Print("[ARES] Bearish CHOCH Detected!");

      // Actualizar detectores de liquidez
      m_eqhl.Analyze(*m_manager.Market().Structure());
      
      SCandle currentCandle;
      if(!m_manager.Data().Get(1, currentCandle)) return false;
      m_pd.Analyze(*m_manager.Market().Structure(), currentCandle.Close);

      // 1. Run Pattern Engine
      SPatternContext pContext;
      SMarketSnapshot snapshot = {};
      pContext.FromMarket(snapshot);
      pContext.valid = true; 
      pContext.score = 1.0;

      SPatternResult pResult;
      m_manager.Pattern().Analyze(pContext, pResult);

      // Si detectamos un FVG o un OB, disparamos el flujo de Evidencia
      if(pResult.detected) 
      {
         string pName = "";
         if(pResult.pattern == PATTERN_TYPE_FVG) pName = "FVG";
         else if(pResult.pattern == PATTERN_TYPE_OB) pName = "Order Block";

         if(pName != "") 
         {
            string dir = (pResult.direction == PATTERN_LONG) ? "Bullish" : "Bearish";
            Print("==================================================================");
            Print("[ARES] ", dir, " ", pName, " Detected at ", DoubleToString(pResult.priceBottom, 5), " - ", DoubleToString(pResult.priceTop, 5));
             
            // 2. Preparamos Contexto de Inteligencia
            SIntelligenceContext iCtx;
            iCtx.Reset();
            iCtx.valid = true;
            iCtx.pattern = pResult;

            // FASE 1: Contexto
            iCtx.contextValid = true; 

            // FASE 2: Estructura
            iCtx.structureValid = (isBullishBOS || isBearishBOS || isBullishCHOCH || isBearishCHOCH);
            if(!iCtx.structureValid && m_manager.Market().Structure().LastStructure() != STRUCTURE_UNDEFINED) {
                iCtx.structureValid = true; // Permite operar a favor del rango estructural activo
            }

            // FASE 3: Liquidez
            iCtx.hasSweep = false; 
            if(pResult.direction == PATTERN_LONG)
               m_inducement.AnalyzeBullish(*m_manager.Market().Structure(), currentCandle.Close, pResult.priceTop);
            else
               m_inducement.AnalyzeBearish(*m_manager.Market().Structure(), currentCandle.Close, pResult.priceBottom);
               
            iCtx.hasInducement = m_inducement.HasInducement();
            iCtx.liquidityValid = (m_eqhl.HasEqualLevel() || iCtx.hasInducement || iCtx.hasSweep);
            if(!iCtx.liquidityValid) iCtx.liquidityValid = true; // Fallback prueba

            // FASE 4: Desplazamiento
            if(pResult.direction == PATTERN_LONG) {
                iCtx.displacementValid = m_displacement.AnalyzeBullish(*m_manager.Data(), 1, 5);
            } else {
                iCtx.displacementValid = m_displacement.AnalyzeBearish(*m_manager.Data(), 1, 5);
            }
            if(!iCtx.displacementValid) iCtx.displacementValid = true; // Fallback prueba

            // FASE 5: Mitigación y PD
            if(pResult.direction == PATTERN_LONG) {
                iCtx.isMitigated = m_mitigation.IsBullishMitigated(pResult.priceTop, currentCandle.Low);
                iCtx.isPremiumDiscount = m_pd.IsDiscount();
            } else {
                iCtx.isMitigated = m_mitigation.IsBearishMitigated(pResult.priceBottom, currentCandle.High);
                iCtx.isPremiumDiscount = m_pd.IsPremium();
            }

            // 3. Evaluar Intelligence Engine
            EIntelligenceGrade grade;
            bool passedIntelligence = m_manager.Intelligence().Analyze(iCtx, grade);
            
            Print("[ARES] --- EVIDENCE SCORE ---");
            Print("[ARES] Context: ", iCtx.contextValid, " | Structure: ", iCtx.structureValid, " | Liquidity: ", iCtx.liquidityValid);
            Print("[ARES] Displacement: ", iCtx.displacementValid, " | Mitigated: ", iCtx.isMitigated, " | PD Confluence: ", iCtx.isPremiumDiscount);
            Print("[ARES] TOTAL SCORE: ", iCtx.totalScore, "/100 -> ", passedIntelligence ? "ACEPTADO" : "RECHAZADO");

            // 4. Decision & Guardian
            if(passedIntelligence)
            {
               SDecisionContext dCtx;
               dCtx.Reset();
               dCtx.Update(iCtx, grade);
               
               dCtx.entryPrice = (pResult.direction == PATTERN_LONG) ? pResult.priceTop : pResult.priceBottom;
               dCtx.stopLoss = (pResult.direction == PATTERN_LONG) ? pResult.priceBottom : pResult.priceTop;
               
               double dist = MathAbs(dCtx.entryPrice - dCtx.stopLoss);
               dCtx.takeProfit = (pResult.direction == PATTERN_LONG) ? (dCtx.entryPrice + dist*2.5) : (dCtx.entryPrice - dist*2.5);

               bool passedDecision = m_manager.Decision().Evaluate(dCtx);
               Print("[ARES] --- DECISION ENGINE ---");
               if(passedDecision)
               {
                  Print("[ARES] Riesgo Aceptado. Lote: ", DoubleToString(dCtx.lotSize, 2), " | R:R ", DoubleToString(dCtx.riskRewardRatio, 2));
                  
                  SGuardianContext gCtx;
                  gCtx.Reset();
                  gCtx.decision = dCtx;
                  
                  bool passedGuardian = m_manager.Guardian().Evaluate(gCtx);
                  if(passedGuardian)
                  {
                     Print("[ARES] >>> TRADE LISTO PARA EJECUCION <<<");
                  }
                  else
                  {
                     Print("[ARES] VETO POR GUARDIAN: Riesgo excesivo o drawdown");
                  }
               }
               else
               {
                  Print("[ARES] VETO POR DECISION: R:R insuficiente");
               }
            }
         }
      }

      return true;
   }
};

#endif
