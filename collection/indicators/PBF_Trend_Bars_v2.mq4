#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 Lime
#property indicator_color4 Red
#property indicator_color5 Lime
#property indicator_color6 Red

extern int Length1 = 13;
extern int Length2 = 34;
extern int Length3 = 89;
extern int Position1 = 35;
extern int Position2 = 0;
extern int Position3 = -35;

double g_ibuf_116[];
double g_ibuf_120[];
double g_ibuf_124[];
double g_ibuf_128[];
double g_ibuf_132[];
double g_ibuf_136[];
double gda_140[];
double gda_144[];
double gda_148[];
bool gi_152 = TRUE;
datetime g_time_156;

int init() {
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 159);
   SetIndexBuffer(0, g_ibuf_116);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 159);
   SetIndexBuffer(1, g_ibuf_120);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 159);
   SetIndexBuffer(2, g_ibuf_124);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 159);
   SetIndexBuffer(3, g_ibuf_128);
   SetIndexStyle(4, DRAW_ARROW);
   SetIndexArrow(4, 159);
   SetIndexBuffer(4, g_ibuf_132);
   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 159);
   SetIndexBuffer(5, g_ibuf_136);
   ArraySetAsSeries(gda_140, TRUE);
   ArraySetAsSeries(gda_144, TRUE);
   ArraySetAsSeries(gda_148, TRUE);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   string ls_0;
   int period_64;
   double ld_68;
   double ld_76;
   double ima_on_arr_96;
   double ima_on_arr_104;
   double ima_on_arr_112;
   double ima_on_arr_120;

   int li_24 = IndicatorCounted();
   if (li_24 < 0) return (-1);
   if (li_24 > 0) li_24--;
   int li_16 = Bars - li_24;
   bool li_28 = FALSE;
   if (g_time_156 != Time[0]) li_28 = TRUE;
   g_time_156 = Time[0];
   if (li_28) {
      ArrayResize(gda_140, Bars);
      ArrayResize(gda_144, Bars);
      ArrayResize(gda_148, Bars);
      if (li_24 > 0) {
         for (int li_20 = Bars - 1; li_20 > 0; li_20--) {
            gda_140[li_20] = gda_140[li_20 - 1];
            gda_144[li_20] = gda_144[li_20 - 1];
            gda_148[li_20] = gda_148[li_20 - 1];
         }
      }
   }
   double ld_32 = 0;
   double ld_40 = 0;
   double ld_48 = Length1 / 2.0;
   if (MathCeil(ld_48) - ld_48 <= 0.5) ld_32 = MathCeil(ld_48);
   else ld_32 = MathFloor(ld_48);
   double ld_56 = MathSqrt(Length1);
   if (MathCeil(ld_56) - ld_56 <= 0.5) ld_40 = MathCeil(ld_56);
   else ld_40 = MathFloor(ld_56);
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      period_64 = ld_32;
      ld_68 = 2 * iMA(NULL, 0, period_64, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      ld_76 = iMA(NULL, 0, Length1, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      gda_140[li_20] = ld_68 - ld_76;
   }
   int period_84 = ld_40;
   ld_32 = 0;
   ld_40 = 0;
   ld_48 = Length2 / 2;
   if (MathCeil(ld_48) - ld_48 <= 0.5) ld_32 = MathCeil(ld_48);
   else ld_32 = MathFloor(ld_48);
   ld_56 = MathSqrt(Length2);
   if (MathCeil(ld_56) - ld_56 <= 0.5) ld_40 = MathCeil(ld_56);
   else ld_40 = MathFloor(ld_56);
   period_64 = ld_32;
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      ld_68 = 2 * iMA(NULL, 0, period_64, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      ld_76 = iMA(NULL, 0, Length2, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      gda_144[li_20] = ld_68 - ld_76;
   }
   int period_88 = ld_40;
   ld_32 = 0;
   ld_40 = 0;
   ld_48 = Length3 / 2;
   if (MathCeil(ld_48) - ld_48 <= 0.5) ld_32 = MathCeil(ld_48);
   else ld_32 = MathFloor(ld_48);
   ld_56 = MathSqrt(Length3);
   if (MathCeil(ld_56) - ld_56 <= 0.5) ld_40 = MathCeil(ld_56);
   else ld_40 = MathFloor(ld_56);
   period_64 = ld_32;
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      ld_68 = 2 * iMA(NULL, 0, period_64, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      ld_76 = iMA(NULL, 0, Length3, 0, MODE_LWMA, PRICE_CLOSE, li_20);
      gda_148[li_20] = ld_68 - ld_76;
   }
   int period_92 = ld_40;
   for (li_20 = li_16 - 1; li_20 >= 0; li_20--) {
      if (li_24 == 0) {
         g_ibuf_116[li_20] = EMPTY_VALUE;
         g_ibuf_120[li_20] = EMPTY_VALUE;
         g_ibuf_124[li_20] = EMPTY_VALUE;
         g_ibuf_128[li_20] = EMPTY_VALUE;
         g_ibuf_132[li_20] = EMPTY_VALUE;
         g_ibuf_136[li_20] = EMPTY_VALUE;
      }
      ld_68 = iMAOnArray(gda_140, 0, period_84, 0, MODE_LWMA, li_20);
      ld_76 = iMAOnArray(gda_144, 0, period_88, 0, MODE_LWMA, li_20);
      ima_on_arr_96 = iMAOnArray(gda_148, 0, period_92, 0, MODE_LWMA, li_20);
      ima_on_arr_104 = iMAOnArray(gda_140, 0, period_84, 0, MODE_LWMA, li_20 + 1);
      ima_on_arr_112 = iMAOnArray(gda_144, 0, period_88, 0, MODE_LWMA, li_20 + 1);
      ima_on_arr_120 = iMAOnArray(gda_148, 0, period_92, 0, MODE_LWMA, li_20 + 1);
      f0_0(g_ibuf_116, g_ibuf_120, li_20, ld_68, ima_on_arr_104, Position1);
      f0_0(g_ibuf_124, g_ibuf_128, li_20, ld_76, ima_on_arr_112, Position2);
      f0_0(g_ibuf_132, g_ibuf_136, li_20, ima_on_arr_96, ima_on_arr_120, Position3);
   }
   return (0);
}

void f0_0(double &ada_0[], double &ada_4[], int ai_8, double ad_12, double ad_20, double ad_28) {
   if (ad_12 > ad_20) {
      ada_0[ai_8] = ad_28;
      return;
   }
   ada_4[ai_8] = ad_28;
}