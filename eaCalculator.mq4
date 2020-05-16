//+------------------------------------------------------------------+
//|                                                 eaCalculator.mq4 |
//|                                        Copyright 2020, ThongEak. |
//|                                https://www.facebook.com/lapukdee |
//+------------------------------------------------------------------+
#property strict
enum E_ModeCurrency {
   E_ModeCurrency_XUSD, //XUSD
   E_ModeCurrency_USDX, //USDX
   E_ModeCurrency_XO,   //XO
   E_ModeCurrency_CFD,  //CFD
};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//--- create timer
   EventSetTimer(60);
   //---
   string CMM = "";
   //
   string i_Symbol = Symbol() + "";
   string i_SymbolA = "", i_SymbolB = "",  i_SymbolC = "";
   double i_PipValue = 0;

   E_ModeCurrency r = SymbolNameReduce2(i_Symbol,
                                        i_SymbolA, i_SymbolB, i_SymbolC,
                                        i_PipValue);

   printf("Reslut :: " + i_Symbol + " | " + i_SymbolA + " : " + i_SymbolB + " : " + i_SymbolC);
   printf("r :: " + EnumToString(r));
   printf("PipValue :: " + DoubleToStr(i_PipValue, 3));
   //
   Comment(CMM);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---

}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---

}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
E_ModeCurrency SymbolNameReduce(string Symbol_,
                                string &SymbolA, string &SymbolB, string &SymbolC,
                                double &PipValue)
{
   string Symbol_1 = (Symbol_ == "") ? Symbol() : Symbol_;

   string ArrSymbol[] = {"USD", "EUR", "GBP", "AUD", "JPY", "CHF", "CAD", "NZD",
                         "XAU", "BTC"
                        };
//---
   for(int i = 0; i < ArraySize(ArrSymbol); i++) {
      if(StringFind(Symbol_1, ArrSymbol[i], 0) == 0) {
         SymbolA = ArrSymbol[i];
         break;
      }
   }
   for(int i = 0; i < ArraySize(ArrSymbol); i++) {
      if(StringFind(Symbol_1, ArrSymbol[i], 3) == 3) {
         SymbolB = ArrSymbol[i];
         break;
      }
   }
   SymbolC = AccountCurrency();
//---
   E_ModeCurrency res = -1;
   if(SymbolA == SymbolC || SymbolB == SymbolC) {
      if(SymbolA == SymbolC) {
         res = E_ModeCurrency_USDX;
         //
         PipValue = 10 / Bid;
      } else {
         res = E_ModeCurrency_XUSD;
         PipValue = 10;
      }
   } else {
      res = E_ModeCurrency_XO;
      PipValue = 10;


      //SymbolB
   }
//---
   return res;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
E_ModeCurrency SymbolNameReduce2(string Symbol_,
                                 string &Symbol_BASE, string &Symbol_PROFIT, string &Symbol_Currency,
                                 double &PipValue)
{
   Symbol_BASE       = SymbolInfoString(Symbol_, SYMBOL_CURRENCY_BASE);
   Symbol_PROFIT     = SymbolInfoString(Symbol_, SYMBOL_CURRENCY_PROFIT);
   Symbol_Currency   = AccountCurrency();

   E_ModeCurrency res = -1;

   if(Symbol_BASE != Symbol_PROFIT) {

      if(Symbol_BASE == Symbol_Currency || Symbol_PROFIT == Symbol_Currency) {
         if(Symbol_BASE == Symbol_Currency) {
            res = E_ModeCurrency_USDX;
            //
            PipValue = 10 / Bid;
         } else {
            res = E_ModeCurrency_XUSD;
            PipValue = 10;
         }
      } else {
         res = E_ModeCurrency_XO;
         PipValue = 10;



      }
   } else {
      res = E_ModeCurrency_CFD;
   }

   return res;
}
//+------------------------------------------------------------------+
