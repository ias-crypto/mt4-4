#property show_inputs
#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double sellPrice = 0.0;
extern double stoploss = 0.0;
extern double risk = 90.0;
extern int RRR = 3;
extern double maxLot = 3.0;
  
int start()
{

  if (stoploss == 0.0)
  {
    Print("Stoploss not set. Check!");
    return(0);
  }
  
  if (sellPrice == 0.0)
  {
    Print("sellPrice not set. Check!");
    return(0);
  }

  double _point = Point;
  double tick = MarketInfo(Symbol(), MODE_TICKVALUE);
  if (Digits == 3 || Digits == 5)
  {
    _point = Point * 10;
    tick = tick * 10;
  }
  
  double maxLot2=MarketInfo(Symbol(),MODE_MAXLOT);
  if (maxLot2<maxLot) 
  {
     maxLot=maxLot2;
  }
  
  double tp = ((stoploss-sellPrice)/_point)*RRR; // setting RRR
  tp=tp*_point;
  
  double lots = NormalizeDouble(MathFloor(risk/((stoploss-sellPrice)/_point*tick)/0.01)*0.01,2);
  
  if (lots > maxLot)
  {
    lots=maxLot;
  }
   
  int ticket = OrderSend(Symbol(),OP_SELLLIMIT,lots,sellPrice,1,stoploss,sellPrice - tp,"SellLimit_risk",123,0,Red);
  if(ticket<0)
  {
    Print("OrderSend failed with error #",GetLastError());
    return(0);
  }
  return(0);
}
