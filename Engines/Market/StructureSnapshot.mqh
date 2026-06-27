#ifndef __ARES_STRUCTURESNAPSHOT_MQH__
#define __ARES_STRUCTURESNAPSHOT_MQH__

#include "StructureStatistics.mqh"

struct SStructureSnapshot
{
   SStructureState Current;
   int HH;
   int HL;
   int LH;
   int LL;
   int BOS;
   int CHOCH;

   SStructureSnapshot()
   {
      HH=HL=LH=LL=BOS=CHOCH=0;
   }
};

class CStructureSnapshotBuilder
{
public:
   static void Build(const SStructureState &state,
                     const CStructureStatistics &stats,
                     SStructureSnapshot &out)
   {
      out.Current=state;
      out.HH=stats.HH();
      out.HL=stats.HL();
      out.LH=stats.LH();
      out.LL=stats.LL();
      out.BOS=stats.BOS();
      out.CHOCH=stats.CHOCH();
   }
};

#endif
