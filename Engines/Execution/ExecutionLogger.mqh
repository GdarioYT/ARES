#ifndef __ARES_EXECUTIONLOGGER_MQH__
#define __ARES_EXECUTIONLOGGER_MQH__

#include "ExecutionReport.mqh"

class CExecutionLogger
{
private:
   SExecutionReport m_last;

public:
   void Log(const SExecutionReport &report)
   {
      m_last=report;
   }

   const SExecutionReport &LastReport() const
   {
      return m_last;
   }

   bool HasReadyOrder() const
   {
      return m_last.status==EXECUTION_READY;
   }

   bool HasRejectedOrder() const
   {
      return m_last.status==EXECUTION_REJECTED;
   }
};

#endif
