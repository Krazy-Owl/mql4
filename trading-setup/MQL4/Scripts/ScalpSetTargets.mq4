//+------------------------------------------------------------------+
//|                                              ScalpSetTargets.mq4 |
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
   datetime sl_bar_time, price_bar_time;
   int sl_bar_shift, order_bar_shift;
   double sl_value, tp_value, order_value;
   
//----
   default_tp = adjustValue(default_tp);
   default_sl = adjustValue(default_sl);
   order_offset = adjustValue (order_offset);
   sl_offset = adjustValue (sl_offset);
   
   int order_type = getTradeDirection();
   if (order_type == 0) {
      Print ("Unable to determine trade setup. One or more target line could not be found.");
      return (-1);
   }
//----
   //если планируем покупку
   if (order_type == OP_BUYSTOP) {
      //ищем "стоповый" бар
      if (ObjectFind(stoploss_bar_target) != -1) {
         sl_bar_time = ObjectGet(stoploss_bar_target, OBJPROP_TIME1);
         sl_bar_shift = iBarShift (NULL, 0, sl_bar_time, false);
         sl_value = iLow (NULL, 0, sl_bar_shift) - sl_offset * Point;
         if (ObjectFind (stoploss_target) != -1) {
            ObjectSet (stoploss_target, OBJPROP_PRICE1, NormalizeDouble (sl_value, Digits));
         }
         else {
            Print ("Stoploss target line could not be found");
            return (-1);
         }
      }
      else {
         Print ("Stoploss bar line could not be found");
         return (-1);
      }

      //ищем "фрактальный" бар для покупки
      if (ObjectFind(price_bar_target) != -1) {
         price_bar_time = ObjectGet(price_bar_target, OBJPROP_TIME1);
         order_bar_shift = iBarShift (NULL, 0, price_bar_time, false);
         order_value = iHigh (NULL, 0, order_bar_shift) + (order_offset + MarketInfo(Symbol(), MODE_SPREAD))  * Point;
         if (ObjectFind (order_target) != -1) {
            ObjectSet (order_target, OBJPROP_PRICE1, NormalizeDouble (order_value, Digits));
         }
         else {
            Print ("Order target line could not be found");
            return (-1);
         }
      }
      else {
         Print ("Order bar line could not be found");
         return (-1);
      }
      
      //выставляем тейкпрофит по дефолту
      if (ObjectFind(takeprofit_target) != -1) {
         tp_value = order_value + default_tp * Point;
         ObjectSet (takeprofit_target, OBJPROP_PRICE1, NormalizeDouble (tp_value, Digits));
      }
      else {
         Print ("Takeprofit target line not found.");
         return (-1);
      }
   }
   //если планируем продажу
   else {
      //ищем "стоповый" бар
      if (ObjectFind(stoploss_bar_target) != -1) {
         sl_bar_time = ObjectGet(stoploss_bar_target, OBJPROP_TIME1);
         sl_bar_shift = iBarShift (NULL, 0, sl_bar_time, false);
         sl_value = iHigh (NULL, 0, sl_bar_shift) + (sl_offset + MarketInfo(Symbol(), MODE_SPREAD)) * Point;
         if (ObjectFind (stoploss_target) != -1) {
            ObjectSet (stoploss_target, OBJPROP_PRICE1, NormalizeDouble (sl_value, Digits));
         }
         else {
            Print ("Stoploss target line could not be found");
            return (-1);
         }
      }
      else {
         Print ("Stoploss bar line could not be found");
         return (-1);
      }

      //ищем "фрактальный" бар для покупки
      if (ObjectFind(price_bar_target) != -1) {
         price_bar_time = ObjectGet(price_bar_target, OBJPROP_TIME1);
         order_bar_shift = iBarShift (NULL, 0, price_bar_time, false);
         order_value = iLow (NULL, 0, order_bar_shift) - order_offset * Point;
         if (ObjectFind (order_target) != -1) {
            ObjectSet (order_target, OBJPROP_PRICE1, NormalizeDouble (order_value, Digits));
         }
         else {
            Print ("Order target line could not be found");
            return (-1);
         }
      }
      else {
         Print ("Order bar line could not be found");
         return (-1);
      }

      //выставляем тейкпрофит по дефолту
      if (ObjectFind(takeprofit_target) != -1) {
         tp_value = order_value - default_tp * Point;
         ObjectSet (takeprofit_target, OBJPROP_PRICE1, NormalizeDouble (tp_value, Digits));
      }
      else {
         Print ("Takeprofit target line not found.");
         return (-1);
      }
      
   
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+