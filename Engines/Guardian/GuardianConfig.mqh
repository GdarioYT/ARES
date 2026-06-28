#ifndef __ARES_GUARDIANCONFIG_MQH__
#define __ARES_GUARDIANCONFIG_MQH__

class CGuardianConfig
{
private:
   double m_maxRisk;
   int    m_maxConsecutiveLosses;
   bool   m_enablePause;

public:
   CGuardianConfig()
   {
      Reset();
   }

   void Reset()
   {
      m_maxRisk=0.50;
      m_maxConsecutiveLosses=3;
      m_enablePause=true;
   }

   void SetMaxRisk(double value){m_maxRisk=value;}
   double MaxRisk() const {return m_maxRisk;}

   void SetMaxConsecutiveLosses(int value){m_maxConsecutiveLosses=value;}
   int MaxConsecutiveLosses() const {return m_maxConsecutiveLosses;}

   void EnablePause(bool value){m_enablePause=value;}
   bool PauseEnabled() const {return m_enablePause;}
};

#endif
