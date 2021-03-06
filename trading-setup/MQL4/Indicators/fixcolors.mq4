//+------------------------------------------------------------------+
//|                                                    fixcolors.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern color MN1_color = clrYellow;
extern color W1D1_color = clrBlue;
extern color H4_color = clrRed;
extern color H1_color = clrGreen;
extern color default_color = clrBlack;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ChartSetInteger(0,CHART_EVENT_OBJECT_CREATE,true);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, // тип события
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) // имя объекта
  {
//---
   if(id == CHARTEVENT_OBJECT_CREATE && 
      (ObjectType(sparam) == OBJ_RECTANGLE || ObjectType(sparam) == OBJ_TREND)) {
      int period = Period();
      int clr = default_color;
      if (period == PERIOD_MN1) {
         clr = MN1_color;
      }
      else if (period == PERIOD_D1 || period == PERIOD_W1) {
         clr = W1D1_color;
      }
      else if (period == PERIOD_H4) {
         clr = H4_color;
      }
      else if (period == PERIOD_H1) {
         clr = H1_color;
      }
      ObjectSet(sparam, OBJPROP_COLOR, clr);
   }
  }
//+------------------------------------------------------------------+
