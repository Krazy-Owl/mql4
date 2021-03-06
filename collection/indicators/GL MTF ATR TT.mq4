//+------------------------------------------------------------------+
//|                                                 GL_Month_ATR.mq4 |
//+------------------------------------------------------------------+
#property copyright "©  unknown author,  ALEXAV,  Tankk,  8  марта  2019,  http://forexsystemsru.com/" 
#property link      "https://forexsystemsru.com/indikatory-foreks/86203-indikatory-sobranie-sochinenii-tankk.html"   ///"https://forexsystemsru.com/1259817-post7617.html"   ///https://forexsystemsru.com/1198113-post65.html"   //http://forexsystemsru.com/indikatory-foreks-f41/" 
//---
#property indicator_chart_window
//---
extern ENUM_TIMEFRAMES TimeFrame=PERIOD_D1;
extern int             CountAtrMTF=10;
extern int             DrawMTF=10;
extern bool            ShowCurrent=true;
extern color           SupportColor=clrDodgerBlue;
extern color           ResistanceColor=clrDarkOrange;
extern ENUM_LINE_STYLE SupResStyle=STYLE_SOLID;
extern int             SupResWidth=2;
extern bool            SupResFill=true;
extern bool            SupResInside=true;
extern color           OpenColor=clrLime;  //LightCyan;  //Red;
extern ENUM_LINE_STYLE OpenStyle=STYLE_DOT;  //DASH;
extern int             OpenWidth=1;
extern color           TextColor=clrMagenta;  //Maroon;
extern int             TextSize=9;
//---
string PREF;  //="Month_ATR ";
double RatesMid[];  //[24];
bool FirstUpdeit=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   TimeFrame = fmax(TimeFrame,_Period);   ///TFK = TimeFrame/_Period;  
   CountAtrMTF = fmax(CountAtrMTF,1);                         
   DrawMTF = fmax(DrawMTF,1);                         
   //---
   PREF = stringMTF(TimeFrame)+": GL MTF ATR ["+(string)CountAtrMTF+"*"+(string)DrawMTF+"] ";
//--- массив для демонстрации быстрого варианта 
   ArrayResize(RatesMid,CountAtrMTF+DrawMTF);   ///if (ArrayRange(RatesMid,0)!=CountAtrMTF) ArrayResize(RatesMid,TimeFrame*2);
//--- indicator buffers mapping
   if (OpenStyle!=STYLE_SOLID) OpenWidth=0;
   if (SupResStyle!=STYLE_SOLID) SupResWidth=0;
//---
return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)  { Delete_Obj(PREF); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool RectangleCreate(const long            chart_ID=0,        // ID графика 
                     const string          name="Rectangle",  // имя прямоугольника 
                     const int             sub_window=0,      // номер подокна  
                     datetime              time1=0,           // время первой точки 
                     double                price1=0,          // цена первой точки 
                     datetime              time2=0,           // время второй точки 
                     double                price2=0,          // цена второй точки 
                     const color           clr=clrRed,        // цвет прямоугольника 
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линий прямоугольника 
                     const int             width=1,           // толщина линий прямоугольника 
                     const bool            fill=false,// заливка прямоугольника цветом 
                     const bool            back=true,// на заднем плане 
                     const bool            selection=false,    // выделить для перемещений 
                     const bool            hidden=false,       // скрыт в списке объектов 
                     const long            z_order=0) // приоритет на нажатие мышью 
{
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": не удалось создать прямоугольник! Код ошибки = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,SupResStyle);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,SupResWidth);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,SupResFill);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//---
return(true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PutText(string name,const string text,double price,datetime time)
{
   ObjectDelete(0,name);
   ObjectCreate(0,name,OBJ_TEXT,0,time,price);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,TextSize);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
   ObjectSetInteger(0,name,OBJPROP_COLOR,TextColor);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
}
//+------------------------------------------------------------------+
//|                                                                  |
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
   datetime t1=0,t2=0;
   double hi=0,lo=0,Mid=0,sr=0,heigth=0,insideR=0,insideT=0;
   string txt="";
   //---
   if (NewBarTF(TimeFrame)) Delete_Obj(PREF);
   //---
   // расчёт при первом запуске индикатора
   if(FirstUpdeit)
     {
      // берётся текущий день и количество дней для расчёта из настроек
      // z - день для которого рассчитываются уровни
      for(int z=0;z<=DrawMTF;z++)
        {
         // sd - смещение бара первого дня, который используется для расчёта текущего
         int sd=z+CountAtrMTF;
         RatesMid[z] = 0;
         // для каждого дня z считается сумма всех дневных диапазонов и сохраняется в RatesMid[z]
         for(int per=sd;per>z;per--)
           {
            hi=iHigh(NULL,TimeFrame,per);
            lo=iLow(NULL,TimeFrame,per);
            RatesMid[z] += hi-lo;
           }
        }
      FirstUpdeit=false;
     }
   //---
   // начиная с последнего закрытого бара, считаем для каждого последующего, двигаясь назад в прошлое
   for(int i=1;i<DrawMTF;i++)
     {
      // считаем средний диапазон каждого дня
      sr=RatesMid[i]/CountAtrMTF;
      // высота равна десятой части диапазона
      heigth=sr*0.1;
      // время окончания текущего бара (начала следующего бара)
      t1=iTime(NULL,TimeFrame,i-1);
      // время начала текущего бара
      t2=iTime(NULL,TimeFrame,i);
      // максимум бара
      hi=iHigh(NULL,TimeFrame,i);
      // минимум бара
      lo=iLow(NULL,TimeFrame,i);
      
      if(SupResInside)
        {
         insideR=sr-heigth;
         insideT=sr+heigth*0.5;
        }
      else
        {
         //insideR=sr+heigth;
         insideR = 1.1 * sr;
         //insideT=sr+heigth*1.5;
         insideT = 1.15 * sr;
        }
      // RectangleCreate(chart_ID, name, sub_window, время_первой_точки, цена_первой_точки, время_второй_точки, цена_второй_точки, цвет_прямоугольник, и прочие раскраски...)

      // для сопротивления:
      // время_первой_точки = t1 = конец дня
      // цена_первой_точки = lo + sr = на средний дневной диапазон выше, чем минимум дня
      // время_второй_точки = t2 = начало дня
      // цена_второй_точки = lo + insideR = на средний диапазон + 10% выше, чем минимум дня
      
      // для поддержки:
      // время_первой_точки = t1 = конец дня
      // цена_первой_точки = hi - sr = на средний дневной диапазон ниже, чем максимум дня
      // время_второй_точки = t2 = начало дня
      // цена_второй_точки = hi - insideR = на средний дневной диапазон + 10% ниже, чем максимум дня

      if (!ExistObj(PREF+"Resistance"+(string)i))  RectangleCreate(0,PREF+"Resistance"+(string)i,0,t1,lo+sr,t2,lo+insideR,ResistanceColor,SupResStyle,SupResWidth,SupResFill,false,false,false,0);
      if (!ExistObj(PREF+"Support"+(string)i))  RectangleCreate(0,PREF+"Support"+(string)i,0,t1,hi-sr,t2,hi-insideR,SupportColor,SupResStyle,SupResWidth,SupResFill,false,false,false,0);

      if (!ExistObj(PREF+"Open"+(string)i))  drawLine(t1,iOpen(NULL,TimeFrame,i),t2,PREF+"Open"+(string)i);

      txt="   "+(string)(NormalizeDouble(sr/_Point,0));
      if (!ExistObj(PREF+"TXT"+(string)i))  PutText(PREF+"TXT"+(string)i,txt,lo+insideT,t2);
     }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

if (ShowCurrent)
 {     
   sr=RatesMid[0]/CountAtrMTF;
   heigth=sr*0.1;
   t1=Time[0];
   t2=iTime(NULL,TimeFrame,0);
   hi=iHigh(NULL,TimeFrame,0);
   lo=iLow(NULL,TimeFrame,0);
   if(SupResInside)
     {
      insideR=sr-heigth;
      insideT=sr+heigth*0.5;
     }
   else
     {
      insideR=sr+heigth;
      insideT=sr+heigth*1.5;
     }
   txt="   "+(string)(NormalizeDouble(sr/_Point,0));

   if (!ExistObj(PREF+"Resistance"+(string)0))
    {
     RectangleCreate(0,PREF+"Resistance"+(string)0,0,t1,lo+sr,t2,lo+insideR,ResistanceColor,SupResStyle,SupResWidth,SupResFill,false,false,false,0);
     RectangleCreate(0,PREF+"Support"+(string)0,0,t1,hi-sr,t2,hi-insideR,SupportColor,SupResStyle,SupResWidth,SupResFill,false,false,false,0);
     drawLine(t1,iOpen(NULL,TimeFrame,0),t2,PREF+"Open"+(string)0);
     PutText(PREF+"TXT"+(string)0,txt,lo+insideT,t2);
    }
   else
    {
     if (ObjectGet(PREF+"Resistance"+(string)0,OBJPROP_TIME1)!=t1)
      {
       ObjectSetInteger(0,PREF+"Resistance"+(string)0,OBJPROP_TIME1,t1);
       ObjectSetInteger(0,PREF+"Support"+(string)0,OBJPROP_TIME1,t1);
       ObjectSetInteger(0,PREF+"Open"+(string)0,OBJPROP_TIME1,t1);
      }
     if (ObjectGet(PREF+"Resistance"+(string)0,OBJPROP_PRICE1)!=lo+sr)
      {
       ObjectSetDouble(0,PREF+"Resistance"+(string)0,OBJPROP_PRICE1,lo+sr);
       ObjectSetDouble(0,PREF+"Resistance"+(string)0,OBJPROP_PRICE2,lo+insideR);
       ObjectSetDouble(0,PREF+"TXT"+(string)0,OBJPROP_PRICE,lo+insideT);
      }
     if (ObjectGet(PREF+"Support"+(string)0,OBJPROP_PRICE1)!=hi-sr)
      {
       ObjectSetDouble(0,PREF+"Support"+(string)0,OBJPROP_PRICE1,hi-sr);
       ObjectSetDouble(0,PREF+"Support"+(string)0,OBJPROP_PRICE2,hi-insideR);
      }
    }   
//+------------------------------------------------------------------+
 }  //конец if (ShowCurrent)
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//---
return(rates_total);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Delete_Obj_Name(string name)
  {
   for(int k=ObjectsTotal()-1; k>=0; k --)
     {
      string Obj_Name=ObjectName(k);
      if(StringFind(name,Obj_Name)>=0)
        {
         ObjectDelete(Obj_Name);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Delete_Obj(string Prefix)
  {
   for(int k=ObjectsTotal()-1; k>=0; k --)
     {
      string Obj_Name=ObjectName(k);
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));

      if(Head==Prefix)
        {
         ObjectDelete(Obj_Name);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(datetime t1,double y,datetime t2,string name)
  {
   ObjectDelete(name);
   ObjectCreate(name,OBJ_TREND,0,t1,y,t2,y);
   ObjectSet(name,OBJPROP_STYLE,OpenStyle);
   ObjectSet(name,OBJPROP_COLOR,OpenColor);
   ObjectSet(name,OBJPROP_WIDTH,OpenWidth);
   ObjectSet(name,OBJPROP_RAY,false);
   ObjectSet(name,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ExistObj(string Name)
  {
   int obj_total=ObjectsTotal();
   string name;
   for(int i=0; i<obj_total; i++)
     {
      name=ObjectName(i);
      if(StringFind(name,Name)>=0)
        {
         return (true);
        }
     }
   return (false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string stringMTF(int perMTF)
{  
   if (perMTF==0)      perMTF=_Period;
   if (perMTF==1)      return("M1");
   if (perMTF==5)      return("M5");
   if (perMTF==15)     return("M15");
   if (perMTF==30)     return("M30");
   if (perMTF==60)     return("H1");
   if (perMTF==240)    return("H4");
   if (perMTF==1440)   return("D1");
   if (perMTF==10080)  return("W1");
   if (perMTF==43200)  return("MN1");
   if (perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||       /// нестандартные периоды для грфиков Renko
               10 || 11 || 12 || 13 || 14 || 16 || 17 || 18)  return("M"+(string)_Period);
//------
   return("Ошибка периода");
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                          ALMA VHF Filter MTF TT                      %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datetime LastBarOpenTime=0; 
//------
bool NewBarTF(int period) 
{
   datetime BarOpenTime=iTime(NULL,period,0);
   if (BarOpenTime!=LastBarOpenTime) {
       LastBarOpenTime=BarOpenTime;
       return (true); } 
   else 
       return (false);
}
//+++======================================================================+++
//+++           StochasticX8 +Index +Matrix AA TT [x18x9x18x5]             +++
//+++======================================================================+++