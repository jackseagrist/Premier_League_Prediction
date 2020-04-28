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

## Prediction Model
Running the file prompts the user to enter in two teams. The user is given a list of teams in the premier league to choose from.

![image](https://github.com/jackseagrist/Premier_League_Prediction/blob/master/images/pl_pred_2.PNG)

Once the teams are entered, the file then calculates the probability of a win, loss, and draw for the match. This is done by calculating home and away expected goals based on the attacking and defensive strengths of each team. The probability for a specific match outcome (i.e. 2-1) is then calculated by using the Poisson distribution to obtain how likely that number of goals will be scored for the home and away team based on the home and away goal expectancy. This is repeated for all potential match outcomes up to 10 goals for both the home and away sides to give a summary of win, loss, and draw percentages.

![image](https://github.com/jackseagrist/Premier_League_Prediction/blob/master/images/pl_pred_3.PNG)
