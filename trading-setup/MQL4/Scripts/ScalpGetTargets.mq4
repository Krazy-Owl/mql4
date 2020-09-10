//+------------------------------------------------------------------+
//|                                              ScalpGetTargets.mq4 |
//|                           Copyright 2012, bloody_trader Software |
//|                                    http://www.bloody-trader.info |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, bloody_trader Software"
#property link      "http://www.bloody-trader.info"

#include <ScalpLibrary.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   targets_distance = adjustValue (targets_distance);
//----

   double price = NormalizeDouble (Ask, Digits);
   double sl = NormalizeDouble (price - targets_distance * Point, Digits);
   double tp = NormalizeDouble (price + targets_distance * Point, Digits);

   //
   if(ObjectFind(order_target)<0) {
      ObjectCreate(order_target, OBJ_HLINE, 0, 0, price);
      ObjectSet (order_target, OBJPROP_COLOR, DarkTurquoise);
      ObjectSet (order_target, OBJPROP_STYLE, STYLE_DOT);
   }
   //
   else ObjectSet(order_target, OBJPROP_PRICE1, price);

   //
   if(ObjectFind(stoploss_target)<0) {
      ObjectCreate(stoploss_target, OBJ_HLINE, 0, 0, NormalizeDouble (sl, Digits));
      ObjectSet (stoploss_target, OBJPROP_COLOR, Red);
      ObjectSet (stoploss_target, OBJPROP_STYLE, STYLE_DOT);
   }
   else ObjectSet (stoploss_target, OBJPROP_PRICE1, NormalizeDouble (sl, Digits));

   //
   if(ObjectFind(takeprofit_target)<0) {
      ObjectCreate(takeprofit_target, OBJ_HLINE, 0, 0, NormalizeDouble (tp, Digits));
      ObjectSet (takeprofit_target, OBJPROP_COLOR, Green);
      ObjectSet (takeprofit_target, OBJPROP_STYLE, STYLE_DOT);
   }
   else ObjectSet (takeprofit_target, OBJPROP_PRICE1, NormalizeDouble (tp, Digits));

   //
   if(ObjectFind(stoploss_bar_target)<0) {
      ObjectCreate(stoploss_bar_target, OBJ_VLINE, 0, Time[10], 0);
      ObjectSet (stoploss_bar_target, OBJPROP_COLOR, Red);
      ObjectSet (stoploss_bar_target, OBJPROP_STYLE, STYLE_DOT);
   }
   else ObjectSet (stoploss_bar_target, OBJPROP_TIME1, Time[10]);

   //
   if(ObjectFind(price_bar_target)<0) {
      ObjectCreate(price_bar_target, OBJ_VLINE, 0, Time[5], 0);
      ObjectSet (price_bar_target, OBJPROP_COLOR, DarkTurquoise);
      ObjectSet (price_bar_target, OBJPROP_STYLE, STYLE_DOT);
   }
   else ObjectSet (price_bar_target, OBJPROP_TIME1, Time[5]);


//----
   return(0);
  }
//+------------------------------------------------------------------+