//+------------------------------------------------------------------+
//|                                               BasketChartPro.mq4 |
//|                   Copyright © 2012, Bloody Trader Software Corp. |
//|                                        http://bloody-trader.info |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Bloody Trader Software Corp."
#property link      "http://bloody-trader.info"

#property indicator_chart_window

#include <WinUser32.mqh>

#define CHART_CMD_UPDATE_DATA  33324

extern string Currency = "##T101##";
extern int TimeFrame = 0;
extern int basket_type = 17; //тип корзины
extern double InitialBalance = 10000;
extern int MaxBars = 1000;
extern bool DebugMode = true;

//настройки для файла истории
string my_copyright = "(C)opyright 2011, bloody_trader";
string hist_filename;
int HistoryFileHandle = -1;
int mojo_sequence[13];

//переменные корзины
string Pair[14]; //названия инструментов
double pair_values[14]; //цена покупки инструментов корзины в начале расчета
int basket_length; //количество пар в корзине
int min_bars; //длина общей истории корзины по самой короткой истории из всех входящих в неё пар

//технические переменные
int last_bar, last_fpos;
double b_open, b_close, b_high, b_low, b_volume;
double tmp_b_open, tmp_b_close, tmp_b_high, tmp_b_low, tmp_b_volume;
bool first_run = true;

//флаги ошибок
bool critical_error_init = false;
bool critical_error_happened = false;

datetime shortest_history_time = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   setBasketType(); //установить названия инструментов для выбранного типа корзины

   //найти начальную точку отсчета в истории для каждого инструмента
   datetime bar_time;
   for (int i = 0; i < basket_length; i++) {
      bar_time = iTime(Pair[i], TimeFrame, iBars(Pair[i], TimeFrame) - 1);
      if (DebugMode) Print ("Latest bar for ", Pair[i], " is ", DateToString (bar_time));
      if (bar_time > shortest_history_time) shortest_history_time = bar_time;
   }
   Print ("Starting from date: ", DateToString (shortest_history_time));
   
   //проверить, что смещения для всех инструментов совпадают
   int last_bar_shift = iBarShift(Pair[0], TimeFrame, shortest_history_time, true);
   int current_bar_shift;
   if (DebugMode) Print ("Bar shift for ", Pair[0], " = ", iBarShift(Pair[0], TimeFrame, shortest_history_time, true));
   
   /*
   for (i = 1; i < basket_length; i++) {
      if (DebugMode) Print ("Bar shift for ", Pair[i], " = ", iBarShift(Pair[i], TimeFrame, shortest_history_time, true));
      current_bar_shift = iBarShift(Pair[i], TimeFrame, shortest_history_time, true);
      if (current_bar_shift != last_bar_shift) {
         Print ("WARNING: history messed up! Bar shifts are not equal!");
      }
   }
   */
   
   double olhc[4];
   bool result;
   int count = 0;
   datetime this_euro_bar_time;
   
   
   for (i = iBars(Pair[0], TimeFrame) - 1; i > 0; i--) {
      this_euro_bar_time = iTime(Pair[0], TimeFrame, i);
      for (int j = 1; j < basket_length; j++) {
         result = getBarByTime(this_euro_bar_time, Pair[j], olhc);
         if (!result) {
            Print ("Bar at ", DateToString (), " is fucked up (", Pair[j], ")");
            count++;
         }
      }
   }
   Print ("Total = ", count, " fucked up bars");
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (critical_error_init || critical_error_happened) return (-1);

   double olhc[4];
//----
   return(0);
  }
//+------------------------------------------------------------------+

bool getBarByTime(datetime bartime, string instrument, double &olhc[4])
{
   int shift = iBarShift(instrument, TimeFrame, bartime);
   datetime real_time = iTime(instrument, TimeFrame, shift);
   
   olhc[0] = iOpen(instrument, TimeFrame, shift);
   olhc[1] = iLow(instrument, TimeFrame, shift);
   olhc[2] = iHigh(instrument, TimeFrame, shift);
   olhc[3] = iClose(instrument, TimeFrame, shift);

   for (int i = 0; i < 4; i++) {
      if (olhc[i] == 0) {
         Print ("Critical error: one or more values of getBarByTime == 0");
         critical_error_happened = true;
      }
   }
   
   if (real_time != bartime) return (false);
   return (true);
}

//добавить к истории новый бар
int saveHistoryBar (int history_handle, int bar_time, double bar_open, double bar_low, double bar_high, double bar_close, double bar_volume, int last_fpos, bool complete = true)
{
   if (history_handle <= 0) {
      Print ("Saving bar failed. History file is not accessible");
      return (-1);
   }

   //перематываем файловый указатель
   FileSeek(history_handle, last_fpos, SEEK_SET);

   //пишем данные
   FileWriteInteger(history_handle, bar_time, LONG_VALUE);
   FileWriteDouble(history_handle, bar_open, DOUBLE_VALUE);
   FileWriteDouble(history_handle, bar_low, DOUBLE_VALUE);
   FileWriteDouble(history_handle, bar_high, DOUBLE_VALUE);
   FileWriteDouble(history_handle, bar_close, DOUBLE_VALUE);
   FileWriteDouble(history_handle, bar_volume, DOUBLE_VALUE);
   FileFlush(history_handle);

   //сохранить указатель на последнюю запись
   if (complete) {
      last_fpos = FileTell(history_handle);   
   }
   return (last_fpos);
}

//создать файл истории, заполнить заголовок и вернуть его хендл
int createHistoryFile(int timeframe) //таймфрейм в минутах!!!
{
   //Имя файла истории
   string hist_filename = Currency + timeframe + ".hst";
   
   //пытаемся открыть файл
   int history_file_handle = FileOpenHistory(hist_filename, FILE_BIN|FILE_WRITE);
   
   //если не удалось - вылетаем с ошибкой :(
   if (history_file_handle < 0) {
      Print ("Fatal error! ", hist_filename, " could not be opened!!!");
      return (-1);
   }

   //заполняем заголовок файла истории
   FileWriteInteger(history_file_handle, 400, LONG_VALUE); //version
   FileWriteString(history_file_handle, my_copyright, 64); //fixed length field
   FileWriteString(history_file_handle, Currency, 12); //fixed length field
   FileWriteInteger(history_file_handle, timeframe, LONG_VALUE); //таймфрейм для которого создается история
   FileWriteInteger(history_file_handle, 2, LONG_VALUE); //количество цифр после запятой
   FileWriteInteger(history_file_handle, 0, LONG_VALUE); //timesign
   FileWriteInteger(history_file_handle, 0, LONG_VALUE); //last sync
   FileWriteArray(history_file_handle, mojo_sequence, 0, 13); //пустой массив заполненный нулями
   FileFlush(history_file_handle);

   return (history_file_handle);   
}
  
//+------------------------------------------------------------------+

//functions for debug and fancy output
/*
string BoolToStr (bool answer)
{
   if (answer) {
      return (" true");
   }
   else return (" false");
}
*/

//возвращает время в виде строки вида dd.mm.yyyy hh:mm:ss
string DateToString (datetime time) 
{
   string fulldate = TimeDay (time) + "." + TimeMonth (time) + "." + TimeYear (time) + " " + TimeHour (time) + ":" + TimeMinute (time) + ":" + TimeSeconds (time);
   return (fulldate);
}


//расчет стоимости пункта для заданной пары на заданном баре с учетом high/low/open/close
double calculatePoint (string pair, int timeframe, int mode, int shift)
{
   //первая валюта
   string currency_1 = StringSubstr (pair, 0, 3);
   //вторая валюта
   string currency_2 = StringSubstr (pair, 3, 3);

   double point, quote;
   string cross_pair;
   
   //для валютных пар с обратными котировками (xxx/usd)
   if (currency_2 == "USD") {
      //Print ("Point for ", pair, " = 1");
//      Print (pair, " is xxx/usd");
      return (1);
   }

   //с прямыми котировками (usd/xxx)
   if (currency_1 == "USD") {
//      Print (pair, " is usd/xxx");
      //котировка по паре с учетом типа цены high/low/open/close
      //размер пункта * лот / котировку по паре
      quote = getQuote (pair, timeframe, mode, shift);
      if (quote == 0) {
         Print ("Error getting quote for ", pair);
         quote = 1;
      }
      point = MarketInfo (pair, MODE_POINT) * 1000 / quote;
      //Print ("Point for ", pair, " = ", DoubleToStr (point, 4));
      //if (point == 0) errQuote (pair, shift);
      return (point);
   }
   
   //для кросс-курсов (xxx/yyy)
   if (pair == "EURGBP") {
      point = getQuote ("GBPUSD", timeframe, mode, shift);
      //Print ("Point for ", pair, " = ", DoubleToStr (point, 4));
      //if (point == 0) errQuote (pair, shift);
      return (point);
   }
   
   //размер пункта * лот / котировку по паре usd/yyy
   //Print (pair, " is xxx/yyy");
   cross_pair = StringConcatenate ("USD", currency_2);

   quote = getQuote (cross_pair, timeframe, mode, shift);
   if (quote == 0) {
      Print ("Error getting quote for ", cross_pair);
      quote = 1;
   }
   
   point = MarketInfo (pair, MODE_POINT) * 1000 / quote;
   //Print ("Point for ", pair, " = ", DoubleToStr (point, 4));
   //if (point == 0) errQuote (pair, shift);
   return (point);
}

//котировка по паре с учетом типа цены high/low/open/close
double getQuote (string pair, int timeframe, int mode, int shift)
{
   double quote;
   
   switch (mode) {
      case PRICE_OPEN:
         quote = iOpen (pair, timeframe, shift);
         break;
      case PRICE_CLOSE:
         quote = iClose (pair, timeframe, shift);
         break;
      case PRICE_LOW:
         quote = iLow (pair, timeframe, shift);
         break;
      case PRICE_HIGH:
         quote = iHigh (pair, timeframe, shift);
         break;
      default:
         quote = 0;
   }
   
   //if (quote == 0) Print ("ERROR! Quote = 0! ", pair, " shift=", shift, " total=", iBars (pair, timeframe));
   //Print ("getQuote for ", pair, " = ", DoubleToStr (quote, 4));
   return (quote);
}

//обновить график в открытом окне
int updateChart ()
{
   static int hwnd = 0;
   
   if(hwnd == 0) 
   {
      //trying to detect the chart window for updating
      hwnd = WindowHandle(Currency, TimeFrame);
   }

   if (hwnd!= 0) {
      if (PostMessageA(hwnd,WM_COMMAND,CHART_CMD_UPDATE_DATA,0) == 0) {
         hwnd = 0;
      }
      else return (0);
   }
   return (-1);
}

void setBasketType()
{
   //варианты корзины   
   switch (basket_type) {
      case 1: Pair[0] = "EURUSD"; Pair[7]  = "";
         Pair[1] = "";                   Pair[8]  = "";
         Pair[2] = "";                   Pair[9]  = "";
         Pair[3] = "";                   Pair[10] = "";
         Pair[4] = "";                   Pair[11] = "";
         Pair[5] = "";                   Pair[12] = "";
         Pair[6] = "";                   Pair[13] = "";
         
         basket_length = 1;
         break;
    case 2: Pair[0] = "GBPUSD"; Pair[7]  = "";
      Pair[1] = "EURJPY"; Pair[8]  = "";
      Pair[2] = "";                   Pair[9]  = "";
      Pair[3] = "";                   Pair[10] = "";
      Pair[4] = "";                   Pair[11] = "";
      Pair[5] = "";                   Pair[12] = "";
      Pair[6] = "";                   Pair[13] = "";
      basket_length = 2;
      break;
    case 4: Pair[0] = "GBPUSD"; Pair[7]  = "";
      Pair[1] = "EURUSD"; Pair[8]  = "";
      Pair[2] = "GBPJPY"; Pair[9]  = "";
      Pair[3] = "EURJPY"; Pair[10] = "";
      Pair[4] = "";                   Pair[11] = "";
      Pair[5] = "";                   Pair[12] = "";
      Pair[6] = "";                   Pair[13] = "";
      basket_length = 4;
      break;
    case 5: Pair[0] = "EURUSD"; Pair[7]  = "";
      Pair[1] = "GBPUSD"; Pair[8]  = "";
      Pair[2] = "USDCAD"; Pair[9]  = "";
      Pair[3] = "USDCHF"; Pair[10] = "";
      Pair[4] = "";                   Pair[11] = "";
      Pair[5] = "";                   Pair[12] = "";
      Pair[6] = "";                   Pair[13] = "";
      basket_length = 4;
      break;
    case 8: Pair[0] = "GBPUSD"; Pair[7]  = "NZDJPY";
      Pair[1] = "EURUSD"; Pair[8]  = "";
      Pair[2] = "AUDUSD"; Pair[9]  = "";
      Pair[3] = "NZDUSD"; Pair[10] = "";
      Pair[4] = "GBPJPY"; Pair[11] = "";
      Pair[5] = "EURJPY"; Pair[12] = "";
      Pair[6] = "AUDJPY"; Pair[13] = "";
      basket_length = 8;
      break;
/*
    case 10:Pair[0] = ""; Pair[7]  = "";
            Pair[1] = ""; Pair[8]  = "";
            Pair[2] = ""; Pair[9]  = "";
            Pair[3] = ""; Pair[10] = "";
            Pair[4] = ""; Pair[11] = "";
            Pair[5] = ""; Pair[12] = "";
            Pair[6] = ""; Pair[13] = "";
      basket_length = 14;
      break;
*/
    case 9: Pair[0] = "#IBM"; Pair[7]  = "#INTC";
            Pair[1] = "#MCD"; Pair[8]  = "#QQQ";
            Pair[2] = "#JPM"; Pair[9]  = "#SPY";
            Pair[3] = "#JNJ"; Pair[10] = "#T";
            Pair[4] = "#XOM"; Pair[11] = "#PFE";
            Pair[5] = "#HPQ"; Pair[12] = "#PG";
            Pair[6] = "#MSFT"; Pair[13] = "#WMT";
      basket_length = 14;
      break;

    case 10:Pair[0] = "EURUSD"; Pair[7]  = "GBPJPY";
            Pair[1] = "GBPUSD"; Pair[8]  = "EURJPY";
            Pair[2] = "AUDUSD"; Pair[9]  = "AUDJPY";
            Pair[3] = "NZDUSD"; Pair[10] = "NZDJPY";
            Pair[4] = "AUDCHF"; Pair[11] = "CADJPY";
            Pair[5] = "EURCHF"; Pair[12] = "USDJPY";
            Pair[6] = "GBPCHF"; Pair[13] = "CHFJPY";
      basket_length = 14;
      break;

    case 11:Pair[0] = "EURUSD"; Pair[7]  = "GBPJPY";
            Pair[1] = "GBPUSD"; Pair[8]  = "EURJPY";
            Pair[2] = "AUDUSD"; Pair[9]  = "AUDJPY";
            Pair[3] = "NZDUSD"; Pair[10] = "NZDJPY";
            Pair[4] = "AUDCHF"; Pair[11] = "CADJPY";
            Pair[5] = "EURCHF"; Pair[12] = "SGDJPY";
            Pair[6] = "GBPCHF"; Pair[13] = "CHFJPY";
      basket_length = 14;
      break;

    case 14:Pair[0] = "GBPUSD"; Pair[5]  = "GBPJPY";
      Pair[1] = "EURUSD"; Pair[6]  = "EURJPY";
      Pair[2] = "AUDUSD"; Pair[7]  = "AUDJPY";
      Pair[3] = "NZDUSD"; Pair[8] = "NZDJPY";
      Pair[4] = "EURGBP"; Pair[9] = "CADJPY";
      //Pair[5] = "";       Pair[12] = "";
      //Pair[6] = "";       Pair[13] = "";
      basket_length = 10;
      break;

   //classical T101
    case 15:Pair[0] = "GBPUSD"; Pair[7]  = "CADJPY";
            Pair[1] = "EURGBP"; Pair[8]  = "AUDUSD";
            Pair[2] = "GBPCHF"; Pair[9]  = "USDJPY";
            Pair[3] = "CHFJPY"; Pair[10] = "EURUSD";
            Pair[4] = "AUDJPY"; Pair[11] = "EURCHF";
            Pair[5] = "EURJPY"; Pair[12] = "GBPJPY";
            Pair[6] = "USDCHF"; Pair[13] = "USDCAD";
      basket_length = 14;
      break;

   //alternative
    case 16:Pair[0] = "AUDUSD"; Pair[7]  = "USDCHF";
            Pair[1] = "NZDJPY"; Pair[8]  = "EURGBP";
            Pair[2] = "GBPCHF"; Pair[9]  = "NZDUSD";
            Pair[3] = "EURUSD"; Pair[10] = "GBPUSD";
            Pair[4] = "EURCHF"; Pair[11] = "EURJPY";
            Pair[5] = "CHFJPY"; Pair[12] = "AUDJPY";
            Pair[6] = "USDCAD"; Pair[13] = "GBPJPY";
      basket_length = 14;
      break;
   //bb set1
    case 17:Pair[0] = "EURUSD"; Pair[7]  = "GBPJPY";
            Pair[1] = "GBPUSD"; Pair[8]  = "EURJPY";
            Pair[2] = "AUDUSD"; Pair[9]  = "AUDJPY";
            Pair[3] = "NZDUSD"; Pair[10] = "NZDJPY";
            Pair[4] = "AUDCHF"; Pair[11] = "CADJPY";
            Pair[5] = "EURCHF"; Pair[12] = "USDJPY";
            Pair[6] = "GBPCHF"; Pair[13] = "CHFJPY";
      basket_length = 14;
      break;
      
    default: break;

   }
}