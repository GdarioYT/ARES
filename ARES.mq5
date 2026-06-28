#property strict
#property version   "1.000"
#property copyright "ARES"
#property description "ARES — Adaptive Reasoning Execution System"

#include "Core/Constants.mqh"
#include "Core/Config.mqh"
#include "Core/ErrorCodes.mqh"
#include "Core/Logger.mqh"
#include "Core/Types.mqh"
#include "Core/Application.mqh"

CApplication App;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   CLogger::Info(ARES_NAME + " | Build " + IntegerToString(ARES_BUILD) + " | Starting...");

   if(!App.Initialize())
   {
      CLogger::Error("Initialization failed — check inputs and data");
      return INIT_FAILED;
   }

   CLogger::Info("Ready on " + _Symbol + " | TF: " + EnumToString(InpTimeframe));
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   MqlRates r[];
   ArraySetAsSeries(r, true);

   if(CopyRates(_Symbol, InpTimeframe, 0, 3, r) < 3)
      return;

   if(App.Engines().Data().Bars() == 0)
   {
      MqlRates history[];
      ArraySetAsSeries(history, true);
      int copied = CopyRates(_Symbol, InpTimeframe, 0, InpHistoryBars, history);
      for(int i = copied - 1; i >= 0; i--)
      {
         App.Engines().Data().PushBar(history[i]);
      }
   }
   else
   {
      App.Engines().Data().PushBar(r[1]); // Actualiza la vela recién cerrada
      App.Engines().Data().PushBar(r[0]); // Añade la nueva vela abierta
   }

   App.Tick();
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   App.Shutdown();
   CLogger::Info("Shutdown — reason: " + IntegerToString(reason));
}
