#ifndef __ARES_CONFIG_MQH__
#define __ARES_CONFIG_MQH__

// --- Configuración General ---
input ENUM_TIMEFRAMES InpTimeframe   = PERIOD_M15;
input int             InpHistoryBars = 5000;

// --- Filtro de Sesión ---
// Offset del servidor MT5 respecto a UTC.
// Brokers europeos (ICMarkets, Pepperstone, etc.):
//   UTC+2 en invierno (oct-mar)
//   UTC+3 en verano/DST (mar-oct)  ← MARZO 2026 usa este
// Para verificar: compara la hora del servidor MT5 con tu reloj local.
input int  InpServerUTCOffset   = 3;    // FIX: UTC+3 para brokers europeos en verano
input bool InpSessionFilterOn   = true; // true = solo opera en Londres/NY
input bool InpSessionDebugMode  = false; // true = log de sesión en cada señal (solo para debug)

// --- Swing Detector ---
// Número de velas a cada lado del pivot para validar un swing.
// 2 = ventana de 5 velas (recomendado). 3 = ventana de 7 velas (más estricto).
input int InpSwingLookback = 2;

#endif
