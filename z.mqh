#define RISK 20.0;
#define HALFRISK 10.0;
#define MAXEXPOSURE 0.3;
#define COMMISSIONPERLOT 4.0;


double setStoploss(double sl)
{
  if (sl == 0.0)
  {
     Print("Stoploss not set. Checking for horizontal line with description 'SL'");
     for (int i = ObjectsTotal() - 1; i >= 0; i--) 
     {
        string objName = ObjectName(i);
        if ( ObjectDescription(objName) == "SL" && ObjectType(objName) == OBJ_HLINE )
        {
           if ( sl == 0.0 )
           {
              sl = ObjectGet(objName, OBJPROP_PRICE1);
              Print("Horizontal line found. Setting stoploss to ",sl);
           }
           else
           {
              Print("More than one horizontal line with description 'SL' found. Exiting");
              return(0.0);
           }
        }
     }
  }
  else 
  {
     Print("Stoploss manually set to ",sl,". Nothing to do.");
  }
  return(sl);
}


// https://fxopen.support/knowledgebase/article/View/213/466/how-to-calculate-ecn-commission
// https://www.mql5.com/en/forum/61050#comment_1735420
double calcConversionPrice()
{
   double rate;
   string base = StringSubstr(Symbol(),0,3);
   string quote = StringSubstr(Symbol(),3,3);
   if ( base == "USD" )
   {
      rate = 1.0;
      Print("Ratemode: 1");
   }
   else if ( quote == "USD" )
   {
      rate = Bid;
      Print("Ratemode: 2");
   }
   else if ( base == "CAD" || base == "CHF" )
   {
      rate = 1/MarketInfo(StringConcatenate("USD",base),MODE_BID);
      Print("Ratemode: 3");
   }
   else
   {
      rate = MarketInfo(StringConcatenate(base,"USD"),MODE_BID);
      Print("Ratemode: 4");
   }
   
   // for gold/silver
   rate=rate/(100000/MarketInfo(Symbol(),MODE_LOTSIZE));
   
   Print("Rate: ",rate);
   return rate;
}

double calcAvailableExposure()
{
  double availExposure=MAXEXPOSURE;
  Print("Max exposure: ",availExposure);
 
  int total=OrdersTotal();
  for (int i = 0; i < total; i++) {
    if ( !OrderSelect(i, SELECT_BY_POS, MODE_TRADES) ) return(0.0);
    if ( OrderType() == OP_BUY && OrderOpenPrice() < OrderStopLoss() ) continue;  // don't count 'free' trade
    if ( OrderType() == OP_SELL && OrderOpenPrice() > OrderStopLoss() ) continue;  // don't count 'free' trade
    availExposure=availExposure-OrderLots();
  }
  availExposure=MathMin(availExposure,MarketInfo(Symbol(),MODE_MAXLOT));
  availExposure=MathMax(availExposure,0.0);
  Print("Available exposure: ",availExposure);
  return(availExposure);
}

double calcLots(double entryPrice, double sl, double _risk, double convRate )
{
  double lots = 0.0;
  double comissionPerLot = COMMISSIONPERLOT;
  double commission = 0.0;
  double availExposure = calcAvailableExposure();
  double dist;
  
  if ( entryPrice == 0.0 || sl == 0.0 || _risk == 0.0 || convRate == 0.0 )
  {
    Print("Invalid arguments provided. entry: ", entryPrice,"  sl: ", sl,"  risk: ",_risk, "  convRate: ",convRate);
    return(0.0);
  }
  
  double _point = Point;
  double tick = MarketInfo(Symbol(), MODE_TICKVALUE);
  if (Digits == 3 || Digits == 5)
  {
     _point = Point * 10;
     tick = tick * 10;
  } 
  
  if ( entryPrice > sl ){
    // BUY
    dist=entryPrice-sl;  
  }
  if ( entryPrice < sl ){
    // SELL
    dist=sl-entryPrice;
  }
  lots = NormalizeDouble(MathFloor(_risk/(dist/_point*tick)/0.01)*0.01,2);
  lots = MathMin(lots,availExposure);
  commission = comissionPerLot*convRate*lots;
  _risk = _risk - commission;
  lots = NormalizeDouble(MathFloor(_risk/(dist/_point*tick)/0.01)*0.01,2);
  lots = MathMin(lots,availExposure);
  Print("calcLots result: ",lots);
  
  return(lots);
}
