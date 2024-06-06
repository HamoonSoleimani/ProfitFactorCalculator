//+------------------------------------------------------------------+
//| ProfitFactor.mq4                                                 |
//| Copyright 2024, MetaQuotes Software Corp.                        |
//| http://www.hamoon.net/                                           |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Software Corp."
#property link      "http://www.hamoon.net/"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Custom function to calculate the profit factors of long and short positions |
//+------------------------------------------------------------------+
void CalculateProfitFactors(double &longProfitFactor, double &shortProfitFactor)
{
   double longGrossProfit = 0.0;
   double longGrossLoss = 0.0;
   double shortGrossProfit = 0.0;
   double shortGrossLoss = 0.0;

   // Loop through all open positions
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS))
      {
         // Calculate profit/loss for the position
         double positionProfit = OrderProfit();

         // Check if the position is a buy (long) or sell (short)
         if(OrderType() == OP_BUY)
         {
            // Accumulate gross profits and losses for long positions
            if(positionProfit > 0)
            {
               longGrossProfit += positionProfit;
            }
            else
            {
               longGrossLoss += MathAbs(positionProfit);
            }
         }
         else if(OrderType() == OP_SELL)
         {
            // Accumulate gross profits and losses for short positions
            if(positionProfit > 0)
            {
               shortGrossProfit += positionProfit;
            }
            else
            {
               shortGrossLoss += MathAbs(positionProfit);
            }
         }
      }
   }

   // Calculate profit factor for long positions
   if(longGrossLoss == 0)
   {
      if(longGrossProfit == 0) 
         longProfitFactor = 0; // No open long positions or all long positions are break-even
      else 
         longProfitFactor = DBL_MAX; // Infinite profit factor (no losses)
   }
   else
   {
      longProfitFactor = longGrossProfit / longGrossLoss;
   }

   // Calculate profit factor for short positions
   if(shortGrossLoss == 0)
   {
      if(shortGrossProfit == 0) 
         shortProfitFactor = 0; // No open short positions or all short positions are break-even
      else 
         shortProfitFactor = DBL_MAX; // Infinite profit factor (no losses)
   }
   else
   {
      shortProfitFactor = shortGrossProfit / shortGrossLoss;
   }
}

//+------------------------------------------------------------------+
//| Custom function to display profit factors                        |
//+------------------------------------------------------------------+
void DisplayProfitFactors()
{
   double longProfitFactor;
   double shortProfitFactor;

   // Calculate profit factors
   CalculateProfitFactors(longProfitFactor, shortProfitFactor);

   // Display the profit factors
   Alert("Long Profit Factor: ", longProfitFactor, " | Short Profit Factor: ", shortProfitFactor);
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Display the profit factors of open positions
   DisplayProfitFactors();

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Placeholder for cleanup actions when the script is removed
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Display the profit factors of open positions on every tick
   DisplayProfitFactors();
}
