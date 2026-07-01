#ifndef __ARES_SESSIONFILTER_MQH__
#define __ARES_SESSIONFILTER_MQH__

// ============================================================================
// ARES - SessionFilter.mqh  (v2 - fix offset UTC+3)
// Filtro de sesión de mercado. Solo permite operar durante las horas de
// mayor liquidez institucional: Londres y Nueva York.
//
// IMPORTANTE sobre el offset del broker:
//   - Brokers europeos usan UTC+2 en invierno, UTC+3 en verano (DST)
//   - Marzo 2026: ya está en horario de verano → UTC+3
//   - Para evitar errores: usa InpServerUTCOffset=3 en primavera/verano
//
// Sesiones en UTC:
//   Londres:    07:00 - 16:00 UTC
//   Nueva York: 13:00 - 21:00 UTC
// ============================================================================
class CSessionFilter
{
private:
   int  m_londonOpen;
   int  m_londonClose;
   int  m_nyOpen;
   int  m_nyClose;
   int  m_offsetHours;
   bool m_enabled;
   bool m_debugMode;

   int ServerHourToUTC(const int serverHour) const
   {
      int utc = serverHour - m_offsetHours;
      if(utc < 0)  utc += 24;
      if(utc > 23) utc -= 24;
      return utc;
   }

public:
   CSessionFilter()
   {
      m_londonOpen  = 7;
      m_londonClose = 16;
      m_nyOpen      = 13;
      m_nyClose     = 21;
      m_offsetHours = 3;    // FIX: default UTC+3 (verano europeo, marzo-octubre)
      m_enabled     = true;
      m_debugMode   = false;
   }

   void SetEnabled(const bool enabled)   { m_enabled = enabled; }
   void SetOffset(const int offset)      { m_offsetHours = offset; }
   void SetDebugMode(const bool debug)   { m_debugMode = debug; }

   void SetLondon(const int open, const int close)
   {
      m_londonOpen  = open;
      m_londonClose = close;
   }

   void SetNewYork(const int open, const int close)
   {
      m_nyOpen  = open;
      m_nyClose = close;
   }

   bool IsActiveSession(const datetime time = 0) const
   {
      if(!m_enabled) return true;

      datetime t = (time == 0) ? TimeCurrent() : time;

      MqlDateTime dt;
      TimeToStruct(t, dt);

      int hourUTC = ServerHourToUTC(dt.hour);

      bool isLondon  = (hourUTC >= m_londonOpen  && hourUTC < m_londonClose);
      bool isNewYork = (hourUTC >= m_nyOpen       && hourUTC < m_nyClose);

      // Protección lunes asiático y cierre de semana
      bool isMondayAsian = (dt.day_of_week == 1 && hourUTC < 8);
      bool isFridayClose = (dt.day_of_week == 5 && hourUTC >= 20);

      bool active = (isLondon || isNewYork) && !isMondayAsian && !isFridayClose;

      // Log de debug — solo cuando cambia el estado (para no spamear)
      if(m_debugMode)
      {
         Print("[ARES][Session] Servidor: ", dt.hour, "h | UTC: ", hourUTC,
               "h | Offset: ", m_offsetHours,
               " | Londres: ", isLondon, " | NY: ", isNewYork,
               " | ACTIVA: ", active);
      }

      return active;
   }

   string CurrentSessionName() const
   {
      datetime t = TimeCurrent();
      MqlDateTime dt;
      TimeToStruct(t, dt);
      int hourUTC = ServerHourToUTC(dt.hour);

      bool isLondon = (hourUTC >= m_londonOpen  && hourUTC < m_londonClose);
      bool isNY     = (hourUTC >= m_nyOpen       && hourUTC < m_nyClose);

      if(isLondon && isNY) return "OVERLAP (Lon+NY)";
      if(isLondon)         return "LONDON";
      if(isNY)             return "NEW YORK";
      return "CLOSED";
   }
};

#endif
