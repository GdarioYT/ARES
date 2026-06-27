#ifndef __ARES_STRUCTURESTATE_MQH__
#define __ARES_STRUCTURESTATE_MQH__

enum EMarketStructure
{
   STRUCTURE_UNDEFINED=0,
   STRUCTURE_HH,
   STRUCTURE_HL,
   STRUCTURE_LH,
   STRUCTURE_LL,
   STRUCTURE_BOS_BULL,
   STRUCTURE_BOS_BEAR,
   STRUCTURE_CHOCH_BULL,
   STRUCTURE_CHOCH_BEAR
};

struct SStructureState
{
   EMarketStructure Type;
   int              SwingIndex;
   double           Price;

   SStructureState()
   {
      Type=STRUCTURE_UNDEFINED;
      SwingIndex=-1;
      Price=0.0;
   }
};

#endif
