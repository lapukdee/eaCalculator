//+------------------------------------------------------------------+
//|                                                 eaCalculator.mq4 |
//|                                        Copyright 2020, ThongEak. |
//|                                https://www.facebook.com/lapukdee |
//+------------------------------------------------------------------+
#property strict
enum E_ModeCurrency {
   E_ModeCurrency_XUSD,
   E_ModeCurrency_USDX,
   E_ModeCurrency_XO,
   E_ModeCurrency_CFD,
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
   string i_Symbol = Symbol() + "#";
   string i_SymbolA = "", i_SymbolB = "", i_SymbolC = AccountCurrency();

   E_ModeCurrency r = SymbolNameReduce(i_Symbol,
                                       i_SymbolA, i_SymbolB);

   printf("Reslut :: " + i_Symbol + " | " + i_SymbolA + " : " + i_SymbolB + " : " + i_SymbolC);


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
                                string &SymbolA, string &SymbolB)
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
//---

   return Symbol_1;
}
//+------------------------------------------------------------------+
