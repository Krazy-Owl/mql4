#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Lime
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Brown

extern int MA1_Period = 49;
extern int MA2_Period = 89;

double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];
bool gi_116 = TRUE;

int init() {
   gi_116 = TRUE;
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 167);
   SetIndexBuffer(0, g_ibuf_100);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 167);
   SetIndexBuffer(1, g_ibuf_104);
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 167);
   SetIndexBuffer(2, g_ibuf_108);
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 167);
   SetIndexBuffer(3, g_ibuf_112);
   SetIndexEmptyValue(3, 0.0);
   //Comment("\n\nLoading algorithms...");
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   string ls_0;
   double ima_28;
   double ima_36;
   int li_24 = IndicatorCounted();
   if (li_24 < 0) return (-1);
   if (li_24 > 0) li_24--;
   int li_16 = Bars - li_24;
   for (int li_20 = 0; li_20 < li_16; li_20++) {
      ima_28 = iMA(NULL, 0, MA1_Period, 0, MODE_EMA, PRICE_CLOSE, li_20);
      ima_36 = iMA(NULL, 0, MA2_Period, 0, MODE_EMA, PRICE_CLOSE, li_20);
      if (ima_28 > ima_36) {
         g_ibuf_100[li_20] = ima_28;
         g_ibuf_104[li_20] = ima_36;
         g_ibuf_108[li_20] = 0;
         g_ibuf_112[li_20] = 0;
      } else {
         g_ibuf_100[li_20] = 0;
         g_ibuf_104[li_20] = 0;
         g_ibuf_108[li_20] = ima_28;
         g_ibuf_112[li_20] = ima_36;
      }
   }
   return (0);
}