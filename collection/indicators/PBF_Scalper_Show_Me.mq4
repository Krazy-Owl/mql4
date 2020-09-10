#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Yellow

double g_ibuf_92[];
bool gi_96 = TRUE;
int g_time_100 = 0;
bool gi_104 = FALSE;
bool gi_unused_108 = TRUE;
double g_high_112 = 0.0;
double g_low_120 = 0.0;
double g_low_128 = 0.0;
double g_high_136 = 0.0;

int init() {
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 159);
   SetIndexBuffer(0, g_ibuf_92);
   SetIndexEmptyValue(0, 0.0);
   return (0);
}

int start() {
   string ls_0;
   int li_24 = IndicatorCounted();
   if (li_24 < 0) return (-1);
   if (li_24 > 0) li_24--;
   int li_16 = Bars - li_24;
   for (int li_20 = li_16 - 1; li_20 > 0; li_20--) {
      if (li_16 == Bars) g_ibuf_92[li_20] = 0;
      if (gi_104 == FALSE) {
         if (High[li_20 + 1] < High[li_20 + 2] && g_time_100 == 0) {
            g_time_100 = Time[li_20 + 2];
            g_high_112 = High[li_20 + 2];
            g_low_120 = Low[li_20 + 1];
         }
         if (High[li_20] > g_high_112) {
            g_time_100 = 0;
            g_high_112 = 0;
            g_low_120 = 0;
         }
         if (Close[li_20] < g_low_120 && g_time_100 != 0) {
            g_time_100 = iBarShift(NULL, 0, g_time_100);
            gi_104 = TRUE;
            g_ibuf_92[g_time_100] = High[g_time_100] + Point;
            g_time_100 = 0;
         }
      }
      if (gi_104 == TRUE) {
         if (Low[li_20 + 1] > Low[li_20 + 2] && g_time_100 == 0) {
            g_time_100 = Time[li_20 + 2];
            g_low_128 = Low[li_20 + 2];
            g_high_136 = High[li_20 + 1];
         }
         if (Low[li_20] < g_low_128) {
            g_time_100 = 0;
            g_low_128 = 0;
            g_high_136 = 0;
         }
         if (Close[li_20] > g_high_136 && g_time_100 != 0) {
            g_time_100 = iBarShift(NULL, 0, g_time_100);
            gi_104 = FALSE;
            g_ibuf_92[g_time_100] = Low[g_time_100] - Point;
            g_time_100 = 0;
         }
      }
   }
   return (0);
}