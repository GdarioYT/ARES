#ifndef __ARES_SESSIONFILTER_MQH__
#define __ARES_SESSIONFILTER_MQH__

// ============================================================================
// ARES - SessionFilter.mqh
// Filtro de sesión de mercado. Solo permite operar durante las horas de
// mayor liquidez institucional: Londres y Nueva York.
//
// Horas en UTC (el servidor MT5 suele usar UTC o UTC+2/3):
//   Londres:    07:00 - 16:00 UTC
//   Nueva York: 13:00 - 21:00 UTC
//   Overlap:    13:00 - 16:00 UTC (mayor volumen del día)
//
// NOTA: Si tu broker usa UTC+2 (hora europea sin DST), ajusta con m_offsetHours.
// ============================================================================
class CSessionFilter
{
private:
   int  m_londonOpen;   // Hora UTC apertura Londres
   int  m_londonClose;  // Hora UTC cierre Londres
   int  m_nyOpen;       // Hora UTC apertura NY
   int  m_nyClose;      // Hora UTC cierre NY
   int  m_offsetHours;  // Offset del servidor respecto a UTC (ej: 2 para UTC+2)
   bool m_enabled;

public:
   CSessionFilter()
   {
      // Valores por defecto: UTC base
      m_londonOpen  = 7;
      m_londonClose = 16;
      m_nyOpen      = 13;
      m_nyClose     = 21;
      m_offsetHours = 0; // Ajustar según broker
      m_enabled     = true;
   }

   //--- Configuración
   void SetEnabled(const bool enabled)      { m_enabled = enabled; }
   void SetOffset(const int offsetHours)    { m_offsetHours = offsetHours; }

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

   //--- Evaluación: ¿Estamos en sesión activa?
   bool IsActiveSession(const datetime time = 0) const
   {
      if(!m_enabled) return true; // Si está desactivado, siempre permite

      datetime t = (time == 0) ? TimeCurrent() : time;

      MqlDateTime dt;
      TimeToStruct(t, dt);

      // Convertir hora del servidor a UTC
      int hourUTC = dt.hour - m_offsetHours;
      if(hourUTC < 0)  hourUTC += 24;
      if(hourUTC > 23) hourUTC -= 24;

      // ¿Estamos en Londres?
      bool isLondon = (hourUTC >= m_londonOpen && hourUTC < m_londonClose);

      // ¿Estamos en Nueva York?
      bool isNewYork = (hourUTC >= m_nyOpen && hourUTC < m_nyClose);

      // No operar los lunes antes de las 8 UTC (apertura asiática sin liquidez)
      bool isMondayAsian = (dt.day_of_week == 1 && hourUTC < 8);

      // No operar los viernes después de las 20 UTC (cierre de semana)
      bool isFridayClose = (dt.day_of_week == 5 && hourUTC >= 20);

      if(isMondayAsian || isFridayClose) return false;

      return isLondon || isNewYork;
   }

   //--- Info para logs
   string CurrentSessionName() const
   {
      datetime t = TimeCurrent();
      MqlDateTime dt;
      TimeToStruct(t, dt);
      int hourUTC = dt.hour - m_offsetHours;
      if(hourUTC < 0)  hourUTC += 24;

      bool isLondon = (hourUTC >= m_londonOpen  && hourUTC < m_londonClose);
      bool isNY     = (hourUTC >= m_nyOpen      && hourUTC < m_nyClose);

      if(isLondon && isNY) return "OVERLAP";
      if(isLondon)         return "LONDON";
      if(isNY)             return "NEW YORK";
      return "CLOSED";
   }
};

#endif
