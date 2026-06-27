#ifndef __ARES_STRUCTURESIGNAL_MQH__
#define __ARES_STRUCTURESIGNAL_MQH__

#include "StructureContext.mqh"

enum EStructureBias
{
   BIAS_NEUTRAL=0,
   BIAS_BULLISH,
   BIAS_BEARISH
};

struct SStructureSignal
{
   EStructureBias Bias;
   bool HasBOS;
   bool HasCHOCH;

   SStructureSignal()
   {
      Bias=BIAS_NEUTRAL;
      HasBOS=false;
      HasCHOCH=false;
   }
};

class CStructureSignalBuilder
{
public:
   static void Build(const CStructureContext &context,SStructureSignal &signal)
   {
      signal=SStructureSignal();

      if(context.Bullish())
         signal.Bias=BIAS_BULLISH;
      else if(context.Bearish())
         signal.Bias=BIAS_BEARISH;

      EMarketStructure t=context.Snapshot().Current.Type;
      signal.HasBOS=(t==STRUCTURE_BOS_BULL || t==STRUCTURE_BOS_BEAR);
      signal.HasCHOCH=(t==STRUCTURE_CHOCH_BULL || t==STRUCTURE_CHOCH_BEAR);
   }
};

#endif
