#property show_inputs
#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <z.mqh>

extern double sellPrice = 0.0;
extern double stoploss = 0.0;
extern double risk = RISK;
extern double uselots = 0.0;
extern int RRR = 5;
extern bool split = true;


int start()
{

  int orderType = OP_SELLLIMIT;
  
  stoploss=setStoploss(stoploss);
  
  if (stoploss == 0.0)
  {
     MessageBox("Stoploss not set. Check!");
     return(0);
  }
  
  if (sellPrice == 0.0)
  {
     sellPrice = Bid;
     orderType = OP_SELL;
  }

  double _point = Point;
  double tick = MarketInfo(Symbol(), MODE_TICKVALUE);
  if (Digits == 3 || Digits == 5)
  {
     _point = Point * 10;
     tick = tick * 10;
  }
  
  double commissionPerLot = COMMISSIONPERLOT;
  double convRate = calcConversionPrice();
  
  double lots;
  if ( uselots == 0.0 )
  {  
    lots=calcLots(sellPrice,stoploss,risk,convRate);
  }
  else
  {
    lots=uselots;
  }
  if ( lots <= 0.0 ) 
  {
    MessageBox("Wrong lot number: ", lots);
    return(0); 
  }
  
  if ( split )
  {
     lots = NormalizeDouble(MathFloor((lots/0.01)/2)*0.01,2); 
     double tp1=((stoploss-sellPrice)/_point+(commissionPerLot*convRate*2/tick))*_point; // TP1: RRR=1 + cover commission for both orders
  
     int ticket = OrderSend(Symbol(),orderType,lots,sellPrice,1,stoploss,sellPrice - tp1,"SellWithScript",123,0,Red);
     if(ticket<0)
     {
        Print("OrderSend failed with error #",GetLastError());
        return(0);
     }
  }
  
  double tp2 = ((stoploss-sellPrice)/_point)*RRR*_point; // setting RRR for TP2
  int ticket2 = OrderSend(Symbol(),orderType,lots,sellPrice,1,stoploss,sellPrice - tp2,"SellWithScript",123,0,Red);
  if(ticket2<0)
  {
     Print("OrderSend failed with error #",GetLastError());
     return(0);
  }
  return(0);

}
