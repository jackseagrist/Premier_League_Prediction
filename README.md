# Premier_League_Prediction

## Reference
Following the outline provided by:
https://www.sbo.net/strategy/football-prediction-model-poisson-distribution/

Reference check for calculations:
https://www.soccerstats.com/homeaway.asp?league=england_2019

Data:
https://datahub.io/sports-data/english-premier-league

## Introduction
Our prediction model makes use of a Poisson Distribution i.e. when we know the average number of times an event will happen. We can use Poisson to calculate how likely other numbers deviate from this average.

Using data from the 2018/2019 season, we will predict the percentage outcome for a win, loss, or draw between two teams provided by the user.

## Parameters : Attacking and Defensive Strengths

### Attacking Strength
The average goals ‘for’ and ‘against’ for every club is calculated at home and away. (eg: Arsenal’s Average Goals at home is simply 
36 (total goals scored) / 19 (no of home matches) = 1.89 

The attacking and defensive strength talks about how good or mediocre a club is when compared to the average values of the entire competition. 

eg: For example, to work out Arsenal’s home attacking strength: 
1.89 / 1.57 (average home goals scored) = 1.20 

This means that Arsenal score 20% more goals at home than the average team in the competition

### Defensive Strength
Similarly, defensive strength is an indicator of how adept or mediocre a club is with respect to the tournament average. 

eg : Burnley’s away defensive strength:
1.68 (average away goals conceded) / 1.57 (tournament average)= 1.07
 
This shows that Burnley have a worse defence than an average team as they concede 7% more goals.


