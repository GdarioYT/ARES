#property strict
#property version "1.000"
#include "Core/Constants.mqh"
#include "Core/Config.mqh"
#include "Core/ErrorCodes.mqh"
#include "Core/Logger.mqh"
#include "Core/Types.mqh"
#include "Engines/Data/DataEngine.mqh"

CDataEngine DataEngine;

int OnInit()
{
 CLogger::Info(ARES_NAME);
 return(DataEngine.Initialize()?INIT_SUCCEEDED:INIT_FAILED);
}

void OnTick()
{
 MqlRates r[];
 ArraySetAsSeries(r,true);
 if(CopyRates(_Symbol,InpTimeframe,0,1,r)==1)
    DataEngine.PushBar(r[0]);
}

void OnDeinit(const int reason){}
