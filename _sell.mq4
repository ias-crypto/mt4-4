#property show_inputs
#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double sellPrice = 0.0;
extern double stoploss = 0.0;
extern double risk = 5.0;
extern int RRR = 5;
extern bool split = true;
extern double commissionPerLot = 4.0;
extern double maxLot = 3.0;

int orderType = OP_SELLLIMIT;  
  
int start()
{

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
  
  double maxLot2=MarketInfo(Symbol(),MODE_MAXLOT);
  if (maxLot2<maxLot) 
  {
     maxLot=maxLot2;
  }
   
  
  double lots = NormalizeDouble(MathFloor(risk/((stoploss-sellPrice)/_point*tick)/0.01)*0.01,2);
  if (lots > maxLot)
  {
     lots=maxLot;
  }
  double convRate = calcConversionPrice();
  double commission = commissionPerLot*convRate*lots;
  risk = risk - commission;
  
    
  double tp1 = ((stoploss-sellPrice)/_point); // setting RRR = 1 for TP1
  tp1=(tp1+(convRate/tick))*_point;
  double tp2 = ((stoploss-sellPrice)/_point)*RRR; // setting RRR for TP2
  tp2=tp2*_point;
  
  
  if ( split )
  {
     lots = NormalizeDouble(MathFloor((risk/((stoploss-sellPrice)/_point*tick)/0.01)/2)*0.01,2); 
  }
  else
  {
     lots = NormalizeDouble(MathFloor(risk/((stoploss-sellPrice)/_point*tick)/0.01)*0.01,2); 
  }
  
  if ( split )
  { 
     int ticket = OrderSend(Symbol(),orderType,lots,sellPrice,1,stoploss,sellPrice - tp1,"SellWithScript",123,0,Red);
     if(ticket<0)
     {
        Print("OrderSend failed with error #",GetLastError());
        return(0);
     }
  }
  
  int ticket2 = OrderSend(Symbol(),orderType,lots,sellPrice,1,stoploss,sellPrice - tp2,"SellWithScript",123,0,Red);
  if(ticket2<0)
  {
     Print("OrderSend failed with error #",GetLastError());
     return(0);
  }
  return(0);

}

double calcConversionPrice()
{
   double rate;
   string base = StringSubstr(Symbol(),0,3);
   string quote = StringSubstr(Symbol(),3,3);
   if ( base == "USD" )
   {
      rate = 1.0;
   }
   else if ( quote == "USD" )
   {
      rate = Bid;
   }
   else if ( base == "CAD" || base == "CHF" )
   {
      rate = 1/MarketInfo(StringConcatenate("USD",base),MODE_BID);
   }
   else
   {
      rate = MarketInfo(StringConcatenate(base,"USD"),MODE_BID);
   }
   return rate;
}
