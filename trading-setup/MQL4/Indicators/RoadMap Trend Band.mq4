//+------------------------------------------------------------------+
//|                                           RoadMap Trend Band.mq4 |
//+------------------------------------------------------------------+
#property copyright   "Copyright © Indalico 03/06/2020"
#property link        "http://www.mql4.com"
#property description "The indicator plots a MTF trend band and shows the trend strenght RSI composite value."
#property description "For the band, the colors are green if the price is above the average and red if it is below it."
#property description "For the RSI composite, the colors are green if the RSI is greater than 50 and red if it is less."
#property strict
#property indicator_chart_window

extern bool   RefreshOnBarClose  = false;             // Refresh on bar close On/Off??
extern int    MA_Periods         = 200;               // Moving average periods
extern ENUM_MA_METHOD MA_Method  = MODE_SMA;          // Moving average type
extern color  TrendUpColor       = clrLime;           // Trend up button color
extern color  TrendDnColor       = clrRed;            // Trend down button color
extern int    ButtonWidth        = 26;                // Buttons width
extern int    ButtonHeight       = 13;                // Buttons height
extern color  ButtonBorderColor  = clrGray;           // Buttons border color
extern color  ButtonBackColor    = clrGray;           // Buttons back color
extern string FontType           = "Calibri Bold";    // Text font type
extern int    FontSize           = 9;                 // Text font size
extern color  FontColor          = clrWhite;          // Text font color

extern ENUM_BASE_CORNER Corner   = CORNER_RIGHT_LOWER;// Select the corner 
extern int    Xpos               = 1;                 // X axis position
extern int    Ypos               = 1;                 // Y axis position                   

int    Xstep,Y1,Y2,Y3,period,Clr;
int    timelist[]= {1,5,15,30,60,240,1440,10080};
string headlist[]= {"M1","M5","M15","M30","H1","H4","D1","W1"};
double close,mav,four2,four9,day2,day9,week2,week9,RSIsum;
string TF,sRSI;

//+------------------------------------------------------------------+
int deinit() {DeleteAll(); return(0);}
//+------------------------------------------------------------------+

int init()
{
        if(Corner==0) {Xstep=0; Y1=0; Y2=ButtonHeight+2; Y3=2*ButtonHeight;}
   else if(Corner==1) {Xstep=ButtonWidth; Y1=0; Y2=ButtonHeight+2; Y3=2*ButtonHeight;}
   else if(Corner==2) {Xstep=0; Y1=ButtonHeight; Y2=2*ButtonHeight+2; Y3=3*ButtonHeight;}
   else if(Corner==3) {Xstep=ButtonWidth; Y1=ButtonHeight; Y2=2*ButtonHeight+2; Y3=3*ButtonHeight;}
   
   for(int i=0; i<8; i++)
      {
         TF=headlist[i];
         DrawButton(0,"Head"+string(i),0,Xstep,Y1,ButtonWidth,ButtonHeight,Corner,TF,FontType,FontSize,FontColor,ButtonBackColor,ButtonBorderColor);
         DrawButton(0,"Mavg"+string(i),0,Xstep,Y2,ButtonWidth,ButtonHeight,Corner,"",FontType,FontSize,FontColor,ButtonBackColor,ButtonBorderColor);
         Xstep +=ButtonWidth;
      }
   
        if(Corner==0) {Xstep=0; Y3 +=4;}
   else if(Corner==1) {Xstep=ButtonWidth*8; Y3 +=4;}
   else if(Corner==2) {Xstep=0; Y3 +=7;}
   else if(Corner==3) {Xstep=ButtonWidth*8; Y3 +=7;}
   
   DrawButton(0,"Rsi",0,Xstep,Y3,ButtonWidth*8,ButtonHeight+3,Corner,"",FontType,FontSize+2,FontColor,ButtonBackColor,ButtonBorderColor);
   return(0);
}

//+------------------------------------------------------------------+

int start()
{
   if(RefreshOnBarClose)
      {
         static int lastBar; 
         if(Bars == lastBar) return(0);
         lastBar=Bars;
      }
   
   for(int i=0; i<8; i++)
      {
         period = timelist[i];
         close  = iClose(NULL,period,0);
         mav    = iMA(NULL,period,MA_Periods,0,MA_Method,PRICE_CLOSE,0);
         if(close >= mav) {Clr=TrendUpColor;} else {Clr=TrendDnColor;}
         ObjectSetInteger(0,"Mavg"+string(i),OBJPROP_BGCOLOR,Clr);
      }

   for(int i=50; i>=0; i--)
      {            
         four2  = iRSI(NULL,240,2,PRICE_CLOSE,0);
         four9  = iRSI(NULL,240,9,PRICE_CLOSE,0);
         day2   = iRSI(NULL,1440,2,PRICE_CLOSE,0);
         day9   = iRSI(NULL,1440,9,PRICE_CLOSE,0);
         week2  = iRSI(NULL,10080,2,PRICE_CLOSE,0);
         week9  = iRSI(NULL,10080,9,PRICE_CLOSE,0);
         RSIsum = (four2+four9+day2+day9+week2+week9)/6;
      }
   
   sRSI = DoubleToString(RSIsum,2); 
   ObjectSetString(0,"Rsi",OBJPROP_TEXT,"RSI(2)+RSI(9):  "+sRSI);
   if(RSIsum >= 50) {Clr=TrendUpColor;} else {Clr=TrendDnColor;}
   ObjectSetInteger(0,"Rsi",OBJPROP_COLOR,Clr);

   return(0);
}

//+------------------------------------------------------------------+

void DrawButton(const long chartID,const string name,const int subwindow,const int x,const int y,const int width,const int height,const int corner,
                  const string text,const string font,const int fontsize,const color clr,const color backclr,const color borderclr,
                  const bool state=false,const bool back=false,const bool selection=false,const bool hidden=true,const long zorder=0)
{
   ResetLastError();
   ObjectCreate(chartID,name,OBJ_BUTTON,subwindow,0,0);
   ObjectSetInteger(chartID,name,OBJPROP_XDISTANCE,Xpos+x);
   ObjectSetInteger(chartID,name,OBJPROP_YDISTANCE,Ypos+y);
   ObjectSetInteger(chartID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chartID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chartID,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(chartID,name,OBJPROP_FONTSIZE,fontsize);
   ObjectSetInteger(chartID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chartID,name,OBJPROP_BGCOLOR,backclr);
   ObjectSetInteger(chartID,name,OBJPROP_BORDER_COLOR,borderclr);
   ObjectSetInteger(chartID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chartID,name,OBJPROP_STATE,state);
   ObjectSetInteger(chartID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chartID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chartID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chartID,name,OBJPROP_ZORDER,zorder);
   ObjectSetString(chartID,name,OBJPROP_TEXT,text);
   ObjectSetString(chartID,name,OBJPROP_FONT,font);
}

//+------------------------------------------------------------------+

void DeleteAll()
{
   for(int i=0; i<8; i++)
      {      
         ObjectDelete(StringConcatenate("Head"+(string)i));
         ObjectDelete(StringConcatenate("Mavg"+(string)i));
      }
   ObjectDelete("Rsi");
}

//+------------------------------------------------------------------+
