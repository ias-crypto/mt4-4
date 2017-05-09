int start()
{
  for (int i = OrdersTotal(); i >=0; i--) {
    OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
    while(IsTradeContextBusy()) Sleep(100);
    RefreshRates();
    if (OrderType() == OP_BUY && Symbol() == OrderSymbol()) {
      OrderClose(OrderTicket(), OrderLots(), Bid, 1, White);
    }
    if (OrderType() == OP_SELL && Symbol() == OrderSymbol()) {
      OrderClose(OrderTicket(), OrderLots(), Ask, 1, White);
    }
  }
  return(0);
}

