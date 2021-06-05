#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Crimson
#property indicator_width1  2
#property indicator_level1  50

extern int Tframe1=240;
extern int Tframe2=1440;
extern int Tframe3=10080;
extern int Tframe4=0;
extern int NumBars=500;

double Crsi[];
double four2, four9, day2, day9, week2, week9, mth2, mth9;
double RSItot;
int RSInum;
int fouri, dayi, weeki, monthi, i;

int init()
{
   IndicatorBuffers(1);
   SetIndexBuffer(0,Crsi); SetIndexStyle(0,DRAW_LINE); 
   
   return(0);
}
int deinit() { return(0); }


int start()
{

   for ( i=NumBars; i>=0; i--)
   {
       fouri = iBarShift(Symbol(), Tframe1, Time[i], false); 
       dayi = iBarShift(Symbol(), Tframe2, Time[i], false);
       weeki = iBarShift(Symbol(), Tframe3, Time[i], false); 
       monthi = iBarShift(Symbol(), Tframe4, Time[i], false);
      
      RSInum=0;  RSItot=0;
      
      if(Tframe1>0){
         four2 = iRSI(NULL,Tframe1,2,PRICE_CLOSE,fouri);   
         four9 = iRSI(NULL,Tframe1,9,PRICE_CLOSE,fouri); 
        
        RSInum=RSInum+2;  RSItot=RSItot+four2+four9;
        }  
      if(Tframe2>0){
         day2 = iRSI(NULL,Tframe2,2,PRICE_CLOSE,dayi);   
         day9 = iRSI(NULL,Tframe2,9,PRICE_CLOSE,dayi); 
        
        RSInum=RSInum+2;  RSItot=RSItot+day2+day9;
        }  
      if(Tframe3>0){
         week2 = iRSI(NULL,Tframe3,2,PRICE_CLOSE,weeki);   
         week9 = iRSI(NULL,Tframe3,9,PRICE_CLOSE,weeki); 
        
        RSInum=RSInum+2;  RSItot=RSItot+week2+week9;
        }  
      if(Tframe4>0){
         mth2 = iRSI(NULL,Tframe4,2,PRICE_CLOSE,monthi);   
         mth9 = iRSI(NULL,Tframe4,9,PRICE_CLOSE,monthi); 
        
        RSInum=RSInum+2;  RSItot=RSItot+mth2+mth9;
        }  

         Crsi[i]=RSItot/RSInum;
   }     

   return(0);
}  

