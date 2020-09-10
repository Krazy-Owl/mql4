//+----------------------------------------------------------+
//|                              Ehlers fisher transform.mq4 |
//|                                                   mladen |
//+----------------------------------------------------------+
#property  copyright "mladen"
#property  link      "http://fxprosystems.com"

#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  DeepSkyBlue
#property  indicator_color2  Red
#property  indicator_width1  2
#property  indicator_style2  STYLE_DOT
#property  indicator_level1  0

//
//
//
//
//
 
extern string TimeFrame        = "Current time frame";
extern int    period           = 10;
extern int    PriceType        = PRICE_MEDIAN;
extern bool   showSignalLine   = true;
extern bool   alertsAndArrowsOnZeroCross = true;
extern double alertsZeroCrossLevel = 1.0;
extern string note              = "turn on Alert = true; turn off = false";
extern bool   alertsOn          = true;
extern bool   alertsOnCurrent   = true;
extern bool   alertsMessage     = true;
extern bool   alertsSound       = true;
extern bool   alertsNotify      = false;
extern bool   alertsEmail       = false;
extern string soundFile         = "alert2.wav";
extern string  __               = "arrows settings";
extern bool   arrowsShow        = true;
extern string arrowsIdentifier  = "fisher2Arrows";
extern double arrowsUpperGap    = 0.5;
extern double arrowsLowerGap    = 0.5;
extern color  arrowsUpColor     = DeepSkyBlue;
extern color  arrowsDnColor     = Red;

//
//
//
//
//

double buffer1[];
double buffer2[];
double Prices[];
double Values[];
double trend[];
double atrend[];

//
//
//
//
//

string indicatorFileName;
bool   returnBars;
int    timeFrame;
  
//+----------------------------------------------------------+
//|                                                          |
//+----------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(6);
      SetIndexBuffer(0,buffer1);
      SetIndexBuffer(1,buffer2);
      SetIndexBuffer(2,Prices);
      SetIndexBuffer(3,Values);
      SetIndexBuffer(4,trend);
      SetIndexBuffer(5,atrend);
      
      //
      //
      //
      //
      //
      
      indicatorFileName = WindowExpertName();
      returnBars        = TimeFrame == "returnBars";     if (returnBars)     return(0);
      timeFrame         = stringToTimeFrame(TimeFrame);
      
      //
      //
      //
      //
      //
      
   IndicatorShortName(timeFrameToString(timeFrame)+" Ehlers\' Fisher transform ("+period+")");
   return(0);
}

//
//
//
//
//

int deinit()
{
   if (arrowsShow) deleteArrows();
   return(0);
}

//+----------------------------------------------------------+
//|                                                          |
//+----------------------------------------------------------+
//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
           int limit=MathMin(Bars-counted_bars,Bars-1);
           if (returnBars) { buffer1[0] = limit+1; return(0); }
   
            if (timeFrame!=Period())
            {
               limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
               for (int i=limit; i>=0; i--)
               {
                  int y = iBarShift(NULL,timeFrame,Time[i]);             
                     buffer1[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",period,PriceType,showSignalLine,alertsAndArrowsOnZeroCross,"",alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,"",arrowsShow,arrowsIdentifier,arrowsUpperGap,arrowsLowerGap,arrowsUpColor,arrowsDnColor,0,y);
                     buffer2[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",period,PriceType,showSignalLine,alertsAndArrowsOnZeroCross,"",alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,"",arrowsShow,arrowsIdentifier,arrowsUpperGap,arrowsLowerGap,arrowsUpColor,arrowsDnColor,1,y);
               }
            return(0);
            }

            //
            //
            //
            //
            //
         
            for(i=limit; i>=0; i--)
            {  
               Prices[i] = iMA(NULL,0,1,0,MODE_SMA,PriceType,i);
      
               //
               //
               //
               //
               //
                  
               double MaxH = Prices[ArrayMaximum(Prices,period,i)];
               double MinL = Prices[ArrayMinimum(Prices,period,i)];
               if (MaxH!=MinL)
                     Values[i] = 0.33*2*((Prices[i]-MinL)/(MaxH-MinL)-0.5)+0.67*Values[i+1];
               else  Values[i] = 0.00;
                     Values[i] = MathMin(MathMax(Values[i],-0.999),0.999); 

               // 
               //
               //
               //
               //

               buffer1[i] = 0.5*MathLog((1+Values[i])/(1-Values[i]))+0.5*buffer1[i+1];
               if (showSignalLine)
                  buffer2[i] = buffer1[i+1];
                    trend[i] = trend[i+1];
             
                    if (alertsAndArrowsOnZeroCross)
                    {
                      if (buffer1[i] >= alertsZeroCrossLevel) trend[i] =  1; 
                      if (buffer1[i] <= (0 - alertsZeroCrossLevel)) trend[i] = -1; 
                    }
                    else
                    {
                      if (buffer1[i] > buffer2[i]) trend[i] =  1; 
                      if (buffer1[i] < buffer2[i]) trend[i] = -1; 
                    }
                    
                    //
                    //
                    //
                    //
                    //
                    
                    if (arrowsShow)
                    {
                      deleteArrow(Time[i]);
                      if (trend[i]!= trend[i+1])
                      {
                        if (trend[i] == 1) drawArrow(i,arrowsUpColor,233,false);
                        if (trend[i] ==-1) drawArrow(i,arrowsDnColor,234,true);
                      }
                    }                     
  
         }
      
         //
         //
         //
         //
         //
      
   
         if (alertsOn)
         {
           if (alertsOnCurrent)
                int whichBar = 0;
           else     whichBar = 1;
         
           if (trend[whichBar] != trend[whichBar+1])
           if (trend[whichBar] == 1)
                 doAlert("up trend");
           else  doAlert("down trend");       
         }
   return(0);
}
//+------------------------------------------------------------------+


void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Ehlers fisher transform ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsNotify)  SendNotification(StringConcatenate(Symbol(), Period() ," Ehlers fisher transform " +" "+message));
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," Ehlers fisher transform "),message);
             if (alertsSound)   PlaySound(soundFile);
      }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}

//
//
//
//
//

void drawArrow(int i,color theColor,int theCode,bool up)
{
   string name = arrowsIdentifier+":"+Time[i];
   double gap  = iATR(NULL,0,20,i);   
   
      //
      //
      //
      //
      //
      
      ObjectCreate(name,OBJ_ARROW,0,Time[i],0);
         ObjectSet(name,OBJPROP_ARROWCODE,theCode);
         ObjectSet(name,OBJPROP_COLOR,theColor);
  
         if (up)
               ObjectSet(name,OBJPROP_PRICE1,High[i] + arrowsUpperGap * gap);
         else  ObjectSet(name,OBJPROP_PRICE1,Low[i]  - arrowsLowerGap * gap);
}

//
//
//
//
//

void deleteArrows()
{
   string lookFor       = arrowsIdentifier+":";
   int    lookForLength = StringLen(lookFor);
   for (int i=ObjectsTotal()-1; i>=0; i--)
   {
      string objectName = ObjectName(i);
         if (StringSubstr(objectName,0,lookForLength) == lookFor) ObjectDelete(objectName);
   }
}

//
//
//
//
//

void deleteArrow(datetime time)
{
   string lookFor = arrowsIdentifier+":"+time; ObjectDelete(lookFor);
}



