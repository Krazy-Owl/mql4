//+------------------------------------------------------------------+
//|                                                  ScalpConfig.mq4 |
//|                           Copyright 2012, bloody_trader Software |
//|                                    http://www.bloody-trader.info |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, bloody_trader Software"
#property link      "http://www.bloody-trader.info"

//tp&sl
double default_tp = 30;
double default_sl = 15;

int sl_offset = 2;
int order_offset = 2;

int slippage = 3;
double scalp_lot = 0.1;

//��������� ����������� ����� �� ���������
double targets_distance = 5;

//����� ����� ����
#define order_target "order_target"
#define stoploss_target "stoploss_target"
#define takeprofit_target "takeprofit_target"

#define stoploss_bar_target "stoploss_bar_target"
#define price_bar_target "price_bar_target"

//���� � ������� ��������, �� �������� �� 10
double adjustValue (double value)
{
   if (Digits == 3 || Digits == 5) {
      return (value * 10);
   }
   return (value);
}

//���������� ����������� �������� �� ������ ����
int getTradeDirection()
{
   //������������ � ����� �������� ������
   if (ObjectFind(order_target) != -1) {
      double price = ObjectGet(order_target, OBJPROP_PRICE1);
   }
   else {
      Print ("Price level target not found. Try ScalpGetTargets first");
      return (0);
   }

   //������������ � ������� ����-�������
   if (ObjectFind(stoploss_target) != -1) {
      double sl = ObjectGet(stoploss_target, OBJPROP_PRICE1);
   }
   else {
      Print ("Stoploss level target not found. Try ScalpGetTargets first");
      return (0);
   }
    
   if (sl > price) {
      return (OP_SELLSTOP);
   }
   else return (OP_BUYSTOP);
   
}