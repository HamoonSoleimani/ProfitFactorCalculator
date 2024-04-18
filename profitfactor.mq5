//+------------------------------------------------------------------+

//|                                             ProfitFactor.mq5     |

//|                        Copyright 2024, MetaQuotes Ltd.           |

//|                                     http://www.hamoon.net/   |

//+------------------------------------------------------------------+

#property copyright "Copyright 2024, MetaQuotes Ltd."

#property link      "http://www.hamoon.net/"

#property version   "1.00"

#property strict



//+------------------------------------------------------------------+

//| Custom function to calculate the profit factor of open positions|

//+------------------------------------------------------------------+

double CalculateProfitFactor() {

  double grossProfit = 0.0;

  double grossLoss = 0.0;

  

  // Loop through all open positions

  for(int i = PositionsTotal() - 1; i >= 0; i--) {

    ulong ticket = PositionGetTicket(i);

    if(ticket > 0 && PositionSelectByTicket(ticket)) {

      // Calculate profit/loss for the position

      double positionProfit = PositionGetDouble(POSITION_PROFIT);

      

      // Accumulate gross profits and losses

      if(positionProfit > 0) {

        grossProfit += positionProfit;

      } else {

        grossLoss += MathAbs(positionProfit);

      }

    }

  }

  

  // Calculate profit factor

  if(grossLoss == 0) {

    if(grossProfit == 0) return 0; // No open positions or all positions are break-even

    return DBL_MAX; // Infinite profit factor (no losses)

  } else {

    return grossProfit / grossLoss;

  }

}



//+------------------------------------------------------------------+

//| Expert initialization function                                   |

//+------------------------------------------------------------------+

int OnInit() {

   // Display the profit factor of open positions

   Alert("Profit Factor of Open Positions: ", CalculateProfitFactor());

   return(INIT_SUCCEEDED);

}



//+------------------------------------------------------------------+

//| Expert deinitialization function                                 |

//+------------------------------------------------------------------+

void OnDeinit(const int reason) {

  // Placeholder for cleanup actions when the script is removed

}



//+------------------------------------------------------------------+

