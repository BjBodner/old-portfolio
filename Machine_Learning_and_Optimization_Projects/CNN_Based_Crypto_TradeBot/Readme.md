# Computer Vision Based Crypto Tradebot

This project was made during the heights of the bitcoin bubble, around Jan 2018.
Though I kept working on it untill march of that year.

The "BinanceTrader_Master.m" File is the Master function which runs the program

The goal of this project was to create a computer vision based trade bot, 
which can interface with cryptocurrency exchanges through the visual interface of the browser, 
just as a regular person would.

The algorithm was designed to look for medium frequency oppertunities, such as:
1. arbitrage oppertunites between several different cryptocurrencies
2. Medium scale trends - with typical time scales of a few minutes

The program was addapted to the Binance.com cryptocurrency exchange.
It could use computer vision to read the information from different areas of the webpage
As well as interact with it through the mouse and the keyboard.
The program could move between a few predefined pages, Rebalance the portfolio when needed,
and respond to different errors and difficulties in trading crypto currencies, with predefined sets of rules.

To find arbitrage oppertunities, a few currencies were monitored, and direct and indirect trade routes were calculated
between them. If buying and selling through different trade routes was predicted to be profitable, taking
the processing fees into account,  then the program would excecute that trade.

To find medium scale trands, a model based reenforcement learning model was trained to Identify 
good states for buying and selling. This was partially succescful, because at this point the market 
had taken a turn for the worst, so it was difficult to determine the effectiveness of the strategy.

The program was never sold, or distributed. Though it was a very interesting lesson in how the financial market works
and in different approches to algorithmic trading.

I hope the files which allow for reading visual information from websites and interacting with them, will 
be helpful for others. This is the only piece of this project which I believe can be used in other applications

