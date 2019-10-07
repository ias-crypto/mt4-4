#property show_inputs
#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <z.mqh>

extern double buyPrice = 0.0;
extern double stoploss = 0.0;
extern double risk = RISK;
extern double uselots = 0.0;
extern int RRR = 5;
extern bool split = true;
  
int start(){

  int orderType = OP_BUYLIMIT;  

  stoploss=setStoploss(stoploss);
  
  if (stoploss == 0.0)
  {
     MessageBox("Stoploss not set. Check!");
     return(0);
  }

  if (buyPrice == 0.0)
  {
     buyPrice = Ask;
     orderType = OP_BUY;
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
    lots=calcLots(buyPrice,stoploss,risk,convRate);
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
     double tp1=(((buyPrice-stoploss)/_point)+(commissionPerLot*convRate*2/tick))*_point; // TP1: RRR=1 + cover commission for both orders
   
     int ticket = OrderSend(Symbol(),orderType,lots,buyPrice,1,stoploss,buyPrice + tp1,"BuyWithScript",1,0,Green);
     if(ticket<0)
     {
        Print("OrderSend failed with error #",GetLastError());
        return(0);
     }
  }
  
  double tp2 = ((buyPrice-stoploss)/_point)*RRR*_point; // setting RRR for TP2
  int ticket2 = OrderSend(Symbol(),orderType,lots,buyPrice,1,stoploss,buyPrice + tp2,"BuyWithScript",1,0,Green);
  if(ticket2<0)
  {
     Print("OrderSend failed with error #",GetLastError());
     return(0);
  }
  return(0);
  
}
