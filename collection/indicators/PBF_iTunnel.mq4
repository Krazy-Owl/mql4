#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Red

double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];
bool gi_120 = TRUE;

int init() {
   IndicatorBuffers(7);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, g_ibuf_92);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, g_ibuf_96);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, g_ibuf_100);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3, g_ibuf_104);
   SetIndexBuffer(4, g_ibuf_108);
   SetIndexBuffer(5, g_ibuf_112);
   SetIndexBuffer(6, g_ibuf_116);
   return (0);
}


int deinit() {
   return (0);
}


int start() {

   string ls_0;
   double ld_28;
   double ima_on_arr_36;
   double ima_on_arr_44;

   int li_24 = IndicatorCounted();
   if (li_24 < 0) return (-1);
   if (li_24 > 0) li_24--;
   int li_16 = Bars - li_24;
   for (int li_20 = li_16 - 1; li_20 >= 0; li_20--) g_ibuf_108[li_20] = iMA(NULL, 0, 17, 0, MODE_SMA, PRICE_CLOSE, li_20);
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      ld_28 = 0.5 * iATR(NULL, 0, 17, li_20);
      g_ibuf_112[li_20] = iMAOnArray(g_ibuf_108, 0, 5, 0, MODE_SMA, li_20) + ld_28;
      g_ibuf_116[li_20] = iMAOnArray(g_ibuf_108, 0, 5, 0, MODE_SMA, li_20) - ld_28;
   }
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      ima_on_arr_36 = iMAOnArray(g_ibuf_112, 0, 10.0 * 0.5, 0, MODE_EMA, li_20);
      ima_on_arr_44 = iMAOnArray(g_ibuf_116, 0, 10.0 * 0.5, 0, MODE_EMA, li_20);
      g_ibuf_92[li_20] = EMPTY_VALUE;
      g_ibuf_100[li_20] = EMPTY_VALUE;
      g_ibuf_96[li_20] = EMPTY_VALUE;
      g_ibuf_104[li_20] = EMPTY_VALUE;
      if (g_ibuf_112[li_20] > ima_on_arr_36) {
         g_ibuf_92[li_20 + 1] = g_ibuf_112[li_20 + 1];
         g_ibuf_92[li_20] = g_ibuf_112[li_20];
      }
      if (g_ibuf_116[li_20] > ima_on_arr_44) {
         g_ibuf_96[li_20 + 1] = g_ibuf_116[li_20 + 1];
         g_ibuf_96[li_20] = g_ibuf_116[li_20];
      }
      if (g_ibuf_112[li_20] < ima_on_arr_36) {
         g_ibuf_100[li_20 + 1] = g_ibuf_112[li_20 + 1];
         g_ibuf_100[li_20] = g_ibuf_112[li_20];
      }
      if (g_ibuf_116[li_20] < ima_on_arr_44) {
         g_ibuf_104[li_20 + 1] = g_ibuf_116[li_20 + 1];
         g_ibuf_104[li_20] = g_ibuf_116[li_20];
      }
   }
   return (0);
}