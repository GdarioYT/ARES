#ifndef __ARES_STRUCTURECONFIG_MQH__
#define __ARES_STRUCTURECONFIG_MQH__

struct SStructureConfig
{
   int  MinSwingDistance;
   int  MaxLookbackBars;
   bool EnableBOS;
   bool EnableCHOCH;

   SStructureConfig()
   {
      MinSwingDistance = 5;
      MaxLookbackBars  = 500;
      EnableBOS        = true;
      EnableCHOCH      = true;
   }
};

#endif
