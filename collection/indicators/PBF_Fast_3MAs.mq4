#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Aqua
#property indicator_color2 Fuchsia
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_color5 Yellow

extern int PLength_Signal = 2;
extern int PLength1 = 13;
extern int PLength2 = 17;
extern bool Plot2MA = TRUE;
extern bool PlotSignal = FALSE;

double g_ibuf_112[];
double g_ibuf_116[];
double g_ibuf_120[];
double g_ibuf_124[];
double g_ibuf_128[];
double g_ibuf_132[];
double g_ibuf_136[];
bool gi_140 = TRUE;
double gd_144 = 0.0;
double gd_152 = 0.0;
double gd_unused_160 = 0.0;
double gd_unused_168 = 0.0;
double gd_unused_176 = 0.0;
double gd_unused_184 = 0.0;

int init() {
   gi_140 = TRUE;
   IndicatorBuffers(8);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, g_ibuf_112);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, g_ibuf_116);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, g_ibuf_120);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3, g_ibuf_124);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(4, g_ibuf_128);
   SetIndexBuffer(5, g_ibuf_132);
   SetIndexBuffer(6, g_ibuf_136);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   string ls_0;
   int period_44;
   double ld_48;
   double ima_56;
   double ima_on_arr_64;
   double ld_72;
   double ld_80;
   double ld_88;
   double ld_96;
   double ld_104;
   double ima_112;
   double ima_on_arr_120;
   double ld_128;

int li_24 = IndicatorCounted();
   if (li_24 < 0) return (-1);
   if (li_24 > 0) li_24--;
   int li_16 = Bars - li_24;
   double ld_28 = PLength1 / 2;
   if (MathCeil(ld_28) - ld_28 <= 0.5) gd_144 = MathCeil(ld_28);
   else gd_144 = MathFloor(ld_28);
   double ld_36 = MathSqrt(PLength1);
   if (MathCeil(ld_36) - ld_36 <= 0.5) gd_152 = MathCeil(ld_36);
   else gd_152 = MathFloor(ld_36);
   for (int li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      period_44 = gd_144;
      ld_48 = 2.0 * iMA(NULL, 0, period_44, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      ima_56 = iMA(NULL, 0, PLength1, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      g_ibuf_132[li_20] = ld_48 - ima_56;
   }
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      period_44 = gd_152;
      ima_on_arr_64 = iMAOnArray(g_ibuf_132, 0, period_44, 0, MODE_LWMA, li_20);
      ld_72 = 0;
      ld_80 = 0;
      if (g_ibuf_112[li_20 + 1] != EMPTY_VALUE) ld_72 = g_ibuf_112[li_20 + 1];
      else ld_72 = g_ibuf_116[li_20 + 1];
      if (ima_on_arr_64 > ld_72) {
         g_ibuf_112[li_20 + 1] = ld_72;
         g_ibuf_112[li_20] = ima_on_arr_64;
         g_ibuf_116[li_20] = EMPTY_VALUE;
      } else {
         g_ibuf_116[li_20 + 1] = ld_72;
         g_ibuf_116[li_20] = ima_on_arr_64;
         g_ibuf_112[li_20] = EMPTY_VALUE;
      }
      if (Plot2MA == TRUE) {
         ld_88 = PLength2 / 2;
         if (MathCeil(ld_88) - ld_88 <= 0.5) gd_144 = MathCeil(ld_88);
         else gd_144 = MathFloor(ld_88);
         ld_96 = MathSqrt(PLength2);
         if (MathCeil(ld_96) - ld_96 <= 0.5) gd_152 = MathCeil(ld_96);
         else gd_152 = MathFloor(ld_96);
         period_44 = gd_144;
         ld_104 = 2 * iMA(NULL, 0, period_44, 0, MODE_LWMA, PRICE_CLOSE, li_20);
         ima_112 = iMA(NULL, 0, PLength2, 0, MODE_LWMA, PRICE_CLOSE, li_20);
         g_ibuf_136[li_20] = ld_104 - ima_112;
      }
   }
   if (Plot2MA == TRUE) {
      for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
         period_44 = gd_152;
         ima_on_arr_120 = iMAOnArray(g_ibuf_136, 0, period_44, 0, MODE_LWMA, li_20);
         ld_72 = 0;
         if (g_ibuf_120[li_20 + 1] != EMPTY_VALUE) ld_72 = g_ibuf_120[li_20 + 1];
         else ld_72 = g_ibuf_124[li_20 + 1];
         if (ima_on_arr_120 > ld_72) {
            g_ibuf_120[li_20 + 1] = ld_72;
            g_ibuf_120[li_20] = ima_on_arr_120;
            g_ibuf_124[li_20] = EMPTY_VALUE;
         } else {
            g_ibuf_124[li_20 + 1] = ld_72;
            g_ibuf_124[li_20] = ima_on_arr_120;
            g_ibuf_120[li_20] = EMPTY_VALUE;
         }
      }
   }
   if (PlotSignal == TRUE) {
      for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
         if (g_ibuf_112[li_20 + 1] != EMPTY_VALUE) ld_72 = g_ibuf_112[li_20 + 1];
         else ld_72 = g_ibuf_116[li_20 + 1];
         if (g_ibuf_112[li_20] != EMPTY_VALUE) ld_80 = g_ibuf_112[li_20];
         else ld_80 = g_ibuf_116[li_20];
         ld_128 = (ld_72 + ld_80) / 2;
         g_ibuf_128[li_20] = ld_128;
      }
   }
   return (0);
}