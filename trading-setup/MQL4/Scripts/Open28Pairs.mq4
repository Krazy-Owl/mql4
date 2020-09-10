//+------------------------------------------------------------------+
//|                                                  Open28Pairs.mq4 |
//|                                                     BI-Magnet BV |
//|                                         https://www.bi-magnet.nl |
//+------------------------------------------------------------------+
#property copyright "BI-Magnet BV"
#property link      "https://www.bi-magnet.nl"
#property version   "1.00"
#property strict

//---
// Activate 28 Market Watch currency pairs.
// For multi-currency indicators or expert-advisors it is necessary 
// that all necessary currency pairs are activated in the Market 
// Watch. In this case this script is to be used for the 8 main 
// currencies and all combinations thereof. Many trading systems on 
// Forex Factory work with these 28 pairs.
//---

const string t_symnm[] = {
   /* 01 */ "AUDCAD",
   /* 02 */ "AUDJPY",
   /* 03 */ "AUDCHF",
   /* 04 */ "AUDNZD",
   /* 05 */ "AUDUSD",
   /* 06 */ "CADCHF",
   /* 07 */ "CADJPY",
   /* 08 */ "CHFJPY",
   /* 09 */ "EURAUD",
   /* 10 */ "EURCAD",
   /* 11 */ "EURCHF",
   /* 12 */ "EURGBP",
   /* 13 */ "EURJPY",
   /* 14 */ "EURNZD",
   /* 15 */ "EURUSD",
   /* 16 */ "GBPAUD",
   /* 17 */ "GBPCAD",
   /* 18 */ "GBPCHF",
   /* 19 */ "GBPJPY",
   /* 20 */ "GBPNZD",
   /* 21 */ "GBPUSD",
   /* 22 */ "NZDCAD",
   /* 23 */ "NZDCHF",
   /* 24 */ "NZDJPY",
   /* 25 */ "NZDUSD",
   /* 26 */ "USDCAD",
   /* 27 */ "USDCHF",
   /* 28 */ "USDJPY"
};

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart() {

   // Activate 28 Market Watch currency pairs
   int tsize = ArraySize(t_symnm);
   for (int i = 0; i < tsize; i++) {
      // Activate the symbol in Market Watch
      string symnm = t_symnm[i];
      SymbolSelect(symnm, true);
   }
   
   // Also Open all these charts   
   bool t_chrt_exist[];
   ArrayResize(t_chrt_exist, tsize);
   ArrayFill(t_chrt_exist, 0, tsize, false);
   
   for (int i = 0; i < tsize; i++) {
      // Make sure we can still handle an extra chart
      if (i >= CHARTS_MAX) break;
      
      //---
      // Possible extension: Check if a chart for  
      // symbol is already open.
      //---
      
      // Open the chart
      if (t_chrt_exist[i] == false) {
         string symnm = t_symnm[i];
         ChartOpen(symnm, PERIOD_H1);
         
         // Mark it as being opened
         t_chrt_exist[i] = true;
      }
   }
   
}
//+------------------------------------------------------------------+
