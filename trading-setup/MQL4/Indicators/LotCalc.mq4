//+------------------------------------------------------------------+
//|                                                      LotCalc.mq4 |
//|                                                        Krazy Owl |
//|                                          https://there.somewhere |
//+------------------------------------------------------------------+
#property copyright "Krazy Owl"
#property link      "https://there.somewhere"
#property version   "0.01"
#property strict
#property indicator_chart_window


extern int       StopLevel = 30;
extern double    Risk = 2.0;
extern color     FontColor = Black;
extern color     StopLineColour = Red;

int normStopLevel;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
//---
   double digits = MarketInfo(Symbol(), MODE_DIGITS);
   if (digits == 3 || digits == 5) {
      normStopLevel = StopLevel * 10;
   }
   else {
      normStopLevel = StopLevel;
   }
   drawStopLine(Ask - (normStopLevel * Point));
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   double sl = ObjectGet("StopLine", OBJPROP_PRICE1);
   if (sl <= Ask && sl >= Bid) {
      return(0);
   }
   double price, pips, points, stop_distance_from_level;
   // sell
   if (sl > Ask) {
      price = Bid;
      stop_distance_from_level = sl - Bid;
   }
   // buy
   else {
      price = Ask;
      stop_distance_from_level = Ask - sl;
   }
   points = stop_distance_from_level / Point;
   if (Digits == 3 || Digits == 5) {
      pips = points / 10;
   }
   else {
      pips = points;
   }
   //double tick = MarketInfo(Symbol(),MODE_TICKVALUE);
   double risk_sum = AccountBalance() / 100 * Risk;
   double lots = risk_sum / (MarketInfo(Symbol(), MODE_TICKVALUE) * points);
   lots = NormalizeDouble(lots, 2);
   double loss_size = lots * (MarketInfo(Symbol(), MODE_TICKVALUE) * points);
   string label_text = "Lots by SL=" + DoubleToString(pips, 0) + " pips, lot=" + DoubleToStr(lots, 2) + ", risk=" + DoubleToStr(loss_size, 2) + "$ for %=" + DoubleToStr(Risk, 2);
   drawLabel(label_text);
   return(0);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+

int deinit()
{
   ObjectDelete("StopLine");
   ObjectDelete("lotcalc");
   return(0);
}

void drawStopLine(double price)
{
   if(ObjectFind(0,"StopLine") != 0) {
         ObjectCreate("StopLine", OBJ_HLINE, 0, 0, price);
   }
   ObjectSet("StopLine", OBJPROP_COLOR, StopLineColour);
   ObjectSet("StopLine", OBJPROP_WIDTH, 1);
   ObjectSet("StopLine", OBJPROP_STYLE, STYLE_DASHDOT);
}

void drawLabel(string txt)
{
   if(ObjectFind(0,"lotcalc") != 0) {
         ObjectCreate("lotcalc", OBJ_LABEL, 0, 0, 0);
   }
   ObjectSetText("lotcalc", txt, 10, "System", FontColor);
   ObjectSet("lotcalc", OBJPROP_XDISTANCE, 7);
   ObjectSet("lotcalc", OBJPROP_YDISTANCE, 10);
   ObjectSet("lotcalc", OBJPROP_CORNER, 2);
}
