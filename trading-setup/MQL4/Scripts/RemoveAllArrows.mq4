//+------------------------------------------------------------------+
//|                                              RemoveAllArrows.mq4 |
//|                   Copyright © 2010, Bloody_Trader Software Corp. |
//|                                          http://www.phpcoder.ws/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Bloody_Trader Software Corp."
#property link      "http://www.phpcoder.ws/"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----OBJ_TREND
   return (ObjectsDeleteAll (NULL, OBJ_ARROW) && ObjectsDeleteAll (NULL, OBJ_TREND)&& ObjectsDeleteAll (NULL, OBJ_CHANNEL)&& ObjectsDeleteAll (NULL, OBJ_FIBO));
//----
  }
//+------------------------------------------------------------------+