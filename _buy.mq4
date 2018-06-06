#property show_inputs
#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double buyPrice = 0.0;
extern double stoploss = 0.0;
extern double risk = 20.0;
extern int RRR = 3;
extern bool split = true;
extern double commissionPerLot = 4.0;
extern double maxLot = 3.0;

int orderType = OP_BUYLIMIT;  
  
int start(){

  if (stoploss == 0.0)
  {
     Print("Stoploss not set. Checking for horizontal line with description 'SL'");
     for (int i = ObjectsTotal() - 1; i >= 0; i--) 
     {
        string objName = ObjectName(i);
        if ( ObjectDescription(objName) == "SL" && ObjectType(objName) == OBJ_HLINE )
        {
           stoploss = ObjectGet(objName, OBJPROP_PRICE1);
           Print("Setting stoploss to ",stoploss);
        }
     }
  }
  
  if (stoploss == 0.0)
  {
     Print("Stoploss not set. Check!");
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
  
  double maxLot2=MarketInfo(Symbol(),MODE_MAXLOT);
  if (maxLot2<maxLot) 
  {
     maxLot=maxLot2;
  }
  
  
  
  double tp1 = ((buyPrice-stoploss)/_point); // setting RRR = 1 for TP1
  tp1=tp1*_point;
  double tp2 = ((buyPrice-stoploss)/_point)*RRR; // setting RRR for TP2
  tp2=tp2*_point;
  
  
  
  double lots = NormalizeDouble(MathFloor(risk/((buyPrice-stoploss)/_point*tick)/0.01)*0.01,2);
  if (lots > maxLot)
  {
     lots = maxLot;
  }
  double commission = commissionPerLot*lots;
  risk = risk - commission;
  
  if ( split )
  {
     lots = NormalizeDouble(MathFloor((risk/((buyPrice-stoploss)/_point*tick)/0.01)/2)*0.01,2);
  }
  else
  {
     lots = NormalizeDouble(MathFloor(risk/((buyPrice-stoploss)/_point*tick)/0.01)*0.01,2);
  }
   
      
  if ( split )
  {    
     int ticket = OrderSend(Symbol(),orderType,lots,buyPrice,1,stoploss,buyPrice + tp1,"BuyWithScript",1,0,Green);
     if(ticket<0)
     {
        Print("OrderSend failed with error #",GetLastError());
        return(0);
     }
  }
  
  int ticket2 = OrderSend(Symbol(),orderType,lots,buyPrice,1,stoploss,buyPrice + tp2,"BuyWithScript",1,0,Green);
  if(ticket2<0)
  {
     Print("OrderSend failed with error #",GetLastError());
     return(0);
  }
  return(0);
  
}
