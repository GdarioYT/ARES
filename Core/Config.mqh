#ifndef __ARES_CONFIG_MQH__
#define __ARES_CONFIG_MQH__

// --- Configuración General ---
input ENUM_TIMEFRAMES InpTimeframe   = PERIOD_M15;
input int             InpHistoryBars = 5000;

// --- Filtro de Sesión ---
// Offset del servidor MT5 respecto a UTC.
// Ejemplo: Si tu broker usa UTC+2, pon 2. Si usa UTC+3, pon 3.
// Para verificarlo: compara la hora del servidor en MT5 con UTC.
input int  InpServerUTCOffset = 2;     // Offset UTC del servidor del broker
input bool InpSessionFilterOn = true;  // true = solo opera en Londres/NY

// --- Swing Detector ---
// Número de velas a cada lado del pivot para validar un swing.
// 2 = ventana de 5 velas (recomendado). 3 = ventana de 7 velas (más estricto).
input int InpSwingLookback = 2;

#endif
