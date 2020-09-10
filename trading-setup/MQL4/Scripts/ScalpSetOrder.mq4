//+------------------------------------------------------------------+
//|                                                ScalpSetOrder.mq4 |
//|                           Copyright 2012, bloody_trader Software |
//|                                    http://www.bloody-trader.info |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, bloody_trader Software"
#property link      "http://www.bloody-trader.info"

#include <ScalpLibrary.mqh>
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   double order_price, sl_price, tp_price;
   int order_type = getTradeDirection();
   if (order_type == 0) {
      Print ("Trade direction could not be determined. Check target lines!!!");
      return (-1);
   }
   slippage = adjustValue(slippage);
//----
   if (ObjectFind(order_target) != -1) {
      order_price = ObjectGet(order_target, OBJPROP_PRICE1);  
   }
   else {
      Print ("Order target line could not be found.");
      return (-1);
   }
   
   if (ObjectFind(stoploss_target) != -1) {
      sl_price = ObjectGet(stoploss_target, OBJPROP_PRICE1);  
   }
   else {
      Print ("Stoploss target line could not be found.");
      return (-1);
   }

   if (ObjectFind(takeprofit_target) != -1) {
      tp_price = ObjectGet(takeprofit_target, OBJPROP_PRICE1);  
   }
   else {
      Print ("Takeprofit target line could not be found.");
      return (-1);
   }
//----
   int ticket, error;
   int order_color;
   if (order_type == OP_BUYSTOP) { order_color = Green; } else order_color = Blue;
   ticket = OrderSend (Symbol(), order_type, scalp_lot, NormalizeDouble (order_price, Digits), slippage, NormalizeDouble (sl_price, Digits), NormalizeDouble (tp_price, Digits), "Scalp Trade", 313131, 0, order_color);
   if (ticket < 0) {
      error = GetLastError();
      Print("OrderSend failed with error #", error, " (", ErrorDescription(error), ")");
   }
   else PlaySound ("ok.wav");
//----   
   return(0);
  }
//+------------------------------------------------------------------+