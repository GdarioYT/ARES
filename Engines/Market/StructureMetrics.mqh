#ifndef __ARES_STRUCTUREMETRICS_MQH__
#define __ARES_STRUCTUREMETRICS_MQH__

#include "StructureStatistics.mqh"

struct SStructureMetrics
{
   double BullishRatio;
   double BearishRatio;
   int    TotalSwings;

   SStructureMetrics()
   {
      BullishRatio=0.0;
      BearishRatio=0.0;
      TotalSwings=0;
   }
};

class CStructureMetricsBuilder
{
public:
   static void Build(const CStructureStatistics &stats,SStructureMetrics &out)
   {
      int bull=stats.HH()+stats.HL();
      int bear=stats.LH()+stats.LL();
      int total=bull+bear;

      out.TotalSwings=total;
      if(total>0)
      {
         out.BullishRatio=(double)bull/total;
         out.BearishRatio=(double)bear/total;
      }
      else
      {
         out.BullishRatio=0.0;
         out.BearishRatio=0.0;
      }
   }
};

#endif
