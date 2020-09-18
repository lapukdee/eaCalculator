//+------------------------------------------------------------------+
//|                                                 eaCalculator.mq4 |
//|                                        Copyright 2020, ThongEak. |
//|                                https://www.facebook.com/lapukdee |
//+------------------------------------------------------------------+
#property   strict
#include    "Function.mqh"
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
   printf(" ---------------------------------------------------------------------------------------------------------- ");
   string CMM = "";
//
   double Coin = 100;
   double Distance_SL = 300;
//
   string Symbol_ = Symbol();
//Distance_SL = Distance_SL * MarketInfo(Symbol_, MODE_TICKSIZE);

   double TICKVALUE = MarketInfo(Symbol_, MODE_TICKVALUE);
   double MARGINREQ = MarketInfo(Symbol_, MODE_MARGINREQUIRED);
   printf("MODE_TICKVALUE :: " + DoubleToStr(TICKVALUE, 2));
   printf("MODE_MARGINREQUIRED :: " + DoubleToStr(MARGINREQ, 2));

   printf("Distance_SL :: " + string(Distance_SL));
   printf("");

//printf("MODE_POINT :: " + MarketInfo(Symbol_, MODE_POINT));
//printf("MODE_TICKSIZE :: " + MarketInfo(Symbol_, MODE_TICKSIZE));
   double PipValueDistance = (TICKVALUE * Distance_SL);
//printf("PipValueDistance :: " + string(PipValueDistance));

   double Lot = NormalizeDoubles(Coin / PipValueDistance, 2);

   printf("Coin-0 :: " +   string(Coin));
   printf("Lot :: " +      string(Lot) + " = " + string(Coin) + " " + AccountCurrency());

   double Magin = NormalizeDoubles( MARGINREQ * Lot, 2);

   printf("Magin :: " + string(Magin));

   if(true) {
      printf("");
      double Rate_Same = NormalizeDouble(Magin / Coin, 2);
      printf("Rate_Same :: " +   string(Rate_Same));

      double Magin_Same = Coin * Rate_Same;
      double Lot_Same = NormalizeDoubles(Lot / Rate_Same, 2);

      printf("Magin_Same :: " +   string(Magin_Same));
      printf("Lot_Same :: " +   string(Lot_Same));
   }

//
   if(false) {
      string i_Symbol = Symbol() + "";
      string i_SymbolA = "", i_SymbolB = "",  i_SymbolC = "";
      double i_PipValue = 0;

      E_ModeCurrency r = SymbolNameReduce2(i_Symbol,
                                           i_SymbolA, i_SymbolB, i_SymbolC,
                                           i_PipValue);

//printf("Reslut :: " + i_Symbol + " | " + i_SymbolA + " : " + i_SymbolB + " : " + i_SymbolC);
//printf("r :: " + EnumToString(r));
//printf("PipValue :: " + DoubleToStr(i_PipValue, 2));
//
   }
   Comment(CMM);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NormalizeDoubles(double v, int digits)
{
   string result;
   string Element[];
   if(StringSplit(string(v), StringGetCharacter(".", 0), Element) == 2) {
      result = Element[0] + "." + StringSubstr(Element[1], 0, digits);
   } else {
      result = Element[0] + ".";
      for(int i = 0; i < digits; i++)
         result += "0";
   }
   //printf(__FUNCTION__ + "# result : " + result);
   return double(result);
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
   printf("Symbol_ :: " + Symbol_ + " | " + Symbol_BASE + " : " + Symbol_PROFIT + " : " + Symbol_Currency);
//---
   E_ModeCurrency res = -1;
   double Coin = -1;
   Coin = MarketInfo(OrderSymbol(), MODE_POINT) * MarketInfo(Symbol_, MODE_LOTSIZE) * 1;
//---

   if(Symbol_BASE != Symbol_PROFIT) {

      //Coin = (1 / MathPow(10, MarketInfo(Symbol_, MODE_DIGITS))) * MarketInfo(Symbol_, MODE_LOTSIZE) * 1;


      if(Symbol_BASE == Symbol_Currency || Symbol_PROFIT == Symbol_Currency) {
         if(Symbol_BASE == Symbol_Currency) {
            res = E_ModeCurrency_USDX;
            //
            PipValue = ConvertCurrency(Coin, Symbol_PROFIT, Symbol_Currency);

         } else {
            res = E_ModeCurrency_XUSD;
            PipValue = Coin;
         }
      } else {
         res = E_ModeCurrency_XO;
         PipValue = ConvertCurrency(Coin, Symbol_PROFIT, Symbol_Currency);
      }

   } else {

      if(Symbol_BASE == Symbol_PROFIT && Symbol_PROFIT == Symbol_Currency) {
         res = E_ModeCurrency_CFD;
         //Coin = (1 / MathPow(10, MarketInfo(Symbol_, MODE_DIGITS))) * MarketInfo(Symbol_, MODE_LOTSIZE) * 1;
         PipValue = Coin;
      }

   }

//---
   double test_magin = ((1 * MarketInfo(Symbol_, MODE_LOTSIZE)) / AccountLeverage());
   test_magin = ConvertCurrency(test_magin, Symbol_BASE, Symbol_Currency);
//---

   printf("Coin :: " + Coin);
   printf("ContactSize :: " + MarketInfo(Symbol_, MODE_LOTSIZE));
   printf("Type :: " + EnumToString(res));
   printf("PipValue :: " + DoubleToStr(PipValue, 2));
   printf("-");

   printf("MODE_TICKVALUE :: " + DoubleToStr(MarketInfo(Symbol_, MODE_TICKVALUE), 2));

   printf("MODE_BID :: " + MarketInfo(Symbol_, MODE_BID));
   printf("MODE_ASK :: " + MarketInfo(Symbol_, MODE_ASK));
   printf("MODE_SPREAD :: " + MarketInfo(Symbol_, MODE_SPREAD));
   printf("AccountLeverage() :: " +  AccountLeverage());
   printf("-");

   printf("MODE_MARGINREQUIRED :: " + DoubleToStr(MarketInfo(Symbol_, MODE_MARGINREQUIRED), 2));
   printf("test_magin :: " + test_magin);
   printf("test diff:: " + DoubleToStr((test_magin - MarketInfo(Symbol_, MODE_MARGINREQUIRED)), 2));
   return res;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ConvertCurrency(double Coin, string Symbol_Exchange, string Symbol_Currency)
{
   double PipValue = -1;
   string Symbol_Symple = Symbol_Exchange + Symbol_Currency;
   if(Symbol_Exchange != Symbol_Currency) {
      if(SymbolInfoInteger(Symbol_Symple, SYMBOL_SELECT)) {
         //printf("Symbol_Symple 1 : *" + Symbol_Symple);
         PipValue = Coin * MarketInfo(Symbol_Symple, MODE_ASK);
      } else {
         Symbol_Symple = Symbol_Currency + Symbol_Exchange;
         printf("Symbol_Symple 2 : /" + Symbol_Symple);
         //PipValue = MarketInfo(Symbol_Symple, MODE_TRADEALLOWED);
         PipValue = Coin / MarketInfo(Symbol_Symple, MODE_ASK);
      }
   } else {
      return PipValue = Coin;
   }
   return PipValue;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Main_DrawElement(int PostX, int PostY)
{

}
//+------------------------------------------------------------------+
