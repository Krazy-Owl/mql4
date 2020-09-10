#property indicator_separate_window
#property indicator_levelcolor Green
#property indicator_levelstyle 0
#property indicator_buffers 6
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 Lime
#property indicator_color4 Yellow
#property indicator_color5 Red
#property indicator_color6 Green
#property indicator_width1 3
#property indicator_level1 35.0
#property indicator_width2 3
#property indicator_level2 -35.0

//#include <stdlib.mqh>
#import "stdlib.ex4"
   bool CompareDoubles(double a0, double a1);

double gda_92[];
double gda_96[];
double gda_100[];
double gda_104[];
double gda_108[];
double gda_112[];
bool gi_116 = TRUE;
double gda_120[];
double gda_124[];
double gda_128[];
double gda_132[];
double gda_136[];
double gda_140[];
double gda_144[];
double gda_148[];
double gda_152[];
datetime gt_156;

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, gda_92);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, gda_96);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, gda_100);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 167);
   SetIndexBuffer(3, gda_104);
   SetIndexStyle(4, DRAW_ARROW);
   SetIndexArrow(4, 119);
   SetIndexBuffer(4, gda_108);
   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 119);
   SetIndexBuffer(5, gda_112);
   ArraySetAsSeries(gda_120, TRUE);
   ArraySetAsSeries(gda_124, TRUE);
   ArraySetAsSeries(gda_128, TRUE);
   ArraySetAsSeries(gda_132, TRUE);
   ArraySetAsSeries(gda_136, TRUE);
   ArraySetAsSeries(gda_140, TRUE);
   ArraySetAsSeries(gda_144, TRUE);
   ArraySetAsSeries(gda_148, TRUE);
   ArraySetAsSeries(gda_152, TRUE);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   string ls_0;
   int li_72;
   double ld_76;
   double ld_84;

int li_16 = 13;
   int li_20 = 21;
   int li_32 = IndicatorCounted();
   if (li_32 < 0) return (-1);
   if (li_32 > 0) li_32--;
   int li_24 = Bars - li_32;
   bool li_36 = FALSE;
   if (gt_156 != Time[0]) li_36 = TRUE;
   gt_156 = Time[0];
   if (li_36) {
      ArrayResize(gda_120, Bars);
      ArrayResize(gda_124, Bars);
      ArrayResize(gda_128, Bars);
      ArrayResize(gda_132, Bars);
      ArrayResize(gda_136, Bars);
      ArrayResize(gda_140, Bars);
      ArrayResize(gda_144, Bars);
      ArrayResize(gda_148, Bars);
      ArrayResize(gda_152, Bars);
      if (li_32 > 0) {
         for (int li_28 = Bars - 1; li_28 > 0; li_28--) {
            gda_120[li_28] = gda_120[li_28 - 1];
            gda_124[li_28] = gda_124[li_28 - 1];
            gda_128[li_28] = gda_128[li_28 - 1];
            gda_132[li_28] = gda_132[li_28 - 1];
            gda_136[li_28] = gda_136[li_28 - 1];
            gda_140[li_28] = gda_140[li_28 - 1];
            gda_144[li_28] = gda_144[li_28 - 1];
            gda_148[li_28] = gda_148[li_28 - 1];
            gda_152[li_28] = gda_152[li_28 - 1];
         }
      }
   }
   for (li_28 = li_24 - 1; li_28 >= 0; li_28--) {
      gda_120[li_28] = f0_0(li_20, 1, gda_136, li_28);
      gda_124[li_28] = f0_0(li_20, 2, gda_140, li_28);
      gda_128[li_28] = f0_0(li_20, 3, gda_144, li_28);
      gda_132[li_28] = 6.25 * f0_0(li_20, 0, gda_148, li_28);
   }
   double ld_40 = 0;
   double ld_48 = 0;
   double ld_56 = li_16 / 2;
   if (MathCeil(ld_56) - ld_56 <= 0.5) ld_40 = MathCeil(ld_56);
   else ld_40 = MathFloor(ld_56);
   double ld_64 = MathSqrt(li_16);
   if (MathCeil(ld_64) - ld_64 <= 0.5) ld_48 = MathCeil(ld_64);
   else ld_48 = MathFloor(ld_64);
   for (li_28 = li_24 - 1; li_28 >= 0; li_28--) {
      li_72 = ld_40;
      ld_76 = 2 * iMAOnArray(gda_132, 0, li_72, 0, MODE_LWMA, li_28);
      ld_84 = iMAOnArray(gda_132, 0, li_16, 0, MODE_LWMA, li_28);
      gda_152[li_28] = ld_76 - ld_84;
   }
   li_72 = ld_48;
   for (li_28 = li_24 - 1; li_28 >= 0; li_28--) {
      ld_76 = iMAOnArray(gda_152, 0, li_72, 0, MODE_LWMA, li_28);
      if (ld_76 >= 35.0) {
         gda_92[li_28] = EMPTY_VALUE;
         gda_96[li_28] = ld_76;
         if (gda_92[li_28 + 1] != EMPTY_VALUE) gda_96[li_28 + 1] = gda_92[li_28 + 1];
         gda_100[li_28] = EMPTY_VALUE;
      } else {
         if (ld_76 <= -35.0) {
            gda_92[li_28] = EMPTY_VALUE;
            gda_96[li_28] = EMPTY_VALUE;
            gda_100[li_28] = ld_76;
            if (gda_92[li_28 + 1] != EMPTY_VALUE) gda_100[li_28 + 1] = gda_92[li_28 + 1];
         } else {
            gda_92[li_28] = ld_76;
            gda_96[li_28] = EMPTY_VALUE;
            gda_100[li_28] = EMPTY_VALUE;
            if (gda_96[li_28 + 1] != EMPTY_VALUE) gda_92[li_28 + 1] = gda_96[li_28 + 1];
            if (gda_100[li_28 + 1] != EMPTY_VALUE) gda_92[li_28 + 1] = gda_100[li_28 + 1];
         }
      }
      if (gda_124[li_28] > 7) gda_104[li_28] = ld_76 + 5.0;
      if (gda_128[li_28] < -1.0 * 7) gda_104[li_28] = ld_76 - 5.0;
      if (gda_124[li_28] > 8) gda_108[li_28] = ld_76 + 10.0;
      if (gda_128[li_28] < -1.0 * 8) gda_112[li_28] = ld_76 - 10.0;
   }
   return (0);
}

double f0_0(int ai_0, int ai_4, double &ada_8[], int ai_12) {
   int li_16 = 0;
   double ld_20 = 0;
   double ld_28 = 0;
   double ld_36 = 0;
   double ld_44 = 0;
   double ld_52 = 0;
   double ld_60 = 0;
   int li_68 = 0;
   double ld_72 = 0;
   double ld_80 = 0;
   double ld_88 = 0;
   double ld_96 = 0;
   double ld_104 = 0;
   double ld_112 = 0;
   double ld_120 = 0;
   double ld_128 = 0;
   double ld_136 = 0;
   double ld_144 = 0;
   double ld_152 = 0;
   double ld_160 = 0;
   if (ai_0 < 2) li_16 = 2;
   if (ai_0 > 1000) li_16 = 1000;
   if (ai_0 >= 2 && ai_0 <= 1000) li_16 = ai_0;
   li_68 = MathRound(li_16 / 5.0);
   if (li_16 > 7) {
      ld_28 = High[iHighest(NULL, 0, MODE_HIGH, li_68, ai_12)] - Low[iLowest(NULL, 0, MODE_LOW, li_68, ai_12)];
      if (ld_28 == 0.0 && li_68 == 1) ld_128 = MathAbs(Close[ai_12] - (Close[ai_12 + li_68]));
      else ld_128 = ld_28;
      ld_36 = High[iHighest(NULL, 0, MODE_HIGH, li_68, li_68 + 1 + ai_12)] - Low[iLowest(NULL, 0, MODE_LOW, li_68, li_68 + ai_12)];
      if (ld_36 == 0.0 && li_68 == 1) ld_136 = MathAbs(Close[ai_12 + li_68] - (Close[ai_12 + li_68 * 2]));
      else ld_136 = ld_36;
      ld_44 = High[iHighest(NULL, 0, MODE_HIGH, li_68, 2 * li_68 + ai_12)] - Low[iLowest(NULL, 0, MODE_LOW, li_68, li_68 * 2 + ai_12)];
      if (ld_44 == 0.0 && li_68 == 1) ld_144 = MathAbs(Close[ai_12 + li_68 * 2] - (Close[ai_12 + 3 * li_68]));
      else ld_144 = ld_44;
      ld_52 = High[iHighest(NULL, 0, MODE_HIGH, li_68, 3 * li_68 + ai_12)] - Low[iLowest(NULL, 0, MODE_LOW, li_68, 3 * li_68 + ai_12)];
      if (ld_52 == 0.0 && li_68 == 1) ld_152 = MathAbs(Close[ai_12 + 3 * li_68] - (Close[ai_12 + li_68 * 4]));
      else ld_152 = ld_52;
      ld_60 = High[iHighest(NULL, 0, MODE_HIGH, li_68, 4 * li_68 + ai_12)] - Low[iLowest(NULL, 0, MODE_LOW, li_68, li_68 * 4 + ai_12)];
      if (ld_60 == 0.0 && li_68 == 1) ld_160 = MathAbs(Close[ai_12 + li_68 * 4] - (Close[ai_12 + 5 * li_68]));
      else ld_160 = ld_60;
      ld_72 = 0.2 * ((ld_128 + ld_136 + ld_144 + ld_152 + ld_160) / 5.0);
      ada_8[ai_12] = ld_20;
      if (li_16 <= 7) {
         if (MathAbs(Close[ai_12] - (Close[ai_12 + 1])) > High[ai_12] - Low[ai_12]) ld_20 = MathAbs(Close[ai_12] - (Close[ai_12 + 1]));
         else ld_20 = High[ai_12] - Low[ai_12];
         if (CompareDoubles(High[ai_12], Low[ai_12])) ld_20 = MathAbs(Close[ai_12] - (Close[ai_12 + 1]));
         ld_72 = 0.2 * iMAOnArray(ada_8, 0, 5, 0, MODE_SMA, ai_12);
      }
      if (ld_72 > 0.0) {
         if (ai_4 == 1) return ((Open[ai_12] - iMA(NULL, 0, li_16, 0, MODE_SMA, PRICE_MEDIAN, ai_12)) / ld_72);
         if (ai_4 == 2) return ((High[ai_12] - iMA(NULL, 0, li_16, 0, MODE_SMA, PRICE_MEDIAN, ai_12)) / ld_72);
         if (ai_4 == 3) return ((Low[ai_12] - iMA(NULL, 0, li_16, 0, MODE_SMA, PRICE_MEDIAN, ai_12)) / ld_72);
         if (ai_4 == 0) return ((Close[ai_12] - iMA(NULL, 0, li_16, 0, MODE_SMA, PRICE_MEDIAN, ai_12)) / ld_72);
      }
   }
   return (0);
}