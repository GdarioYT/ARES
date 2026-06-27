#ifndef __ARES_STRUCTURECLOCK_MQH__
#define __ARES_STRUCTURECLOCK_MQH__

class CStructureClock
{
private:
   datetime m_lastUpdate;

public:
   CStructureClock()
   {
      Reset();
   }

   void Reset()
   {
      m_lastUpdate = 0;
   }

   void Update(const datetime time)
   {
      m_lastUpdate = time;
   }

   datetime LastUpdate() const
   {
      return m_lastUpdate;
   }

   bool IsInitialized() const
   {
      return (m_lastUpdate != 0);
   }
};

#endif
