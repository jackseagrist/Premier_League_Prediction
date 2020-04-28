clc;
clear all;
%Following the outline provided by
%https://www.sbo.net/strategy/football-prediction-model-poisson-distribution/
%for how to calculate prediction of outcomes
%Using the website
%https://www.soccerstats.com/homeaway.asp?league=england_2019 for reference
%to check calculations
%Data gathered from https://datahub.io/sports-data/english-premier-league

%----------------------------------------------------------
%-- Import Data --%
%Importing the datasets that we will use in the calculations. The first is
%the raw data from datahub.io for the 2018/19 English Premier League season
warning('off')
DataSetPL20182019 = readtable('PL20182019.csv');
DataSetPL20182019REF = readtable('PL20182019.csv');

%The season has 38 total games, where 3 points are awarded for a win, 1 point for a draw, and
%0 points for a loss. A teams rank is determined by the sum of points they
%have at the end of the season.

%We then create a table listing out the name of each team in the premier
%league in the order that finished in the premier league. 
PremierLeagueRanking20182019 = {'Man City';...
                        'Liverpool';...
                        'Chelsea';...
                        'Tottenham';...
                        'Arsenal';...
                        'Man United';...
                        'Wolves';...
                        'Everton';...
                        'Leicester';...
                        'West Ham';...
                        'Watford';...
                        'Crystal Palace';...
                        'Newcastle';...
                        'Bournemouth';...
                        'Burnley';...
                        'Southampton';...
                        'Brighton';...
                        'Cardiff City';...
                        'Fulham';...
                        'Huddersfield'};
%We can manipulate the raw dataset that was imported to contain just the
%columns that we want. In this case, the first 7 columns are the ones we
%are interested, so we can drop the rest of the columns.
DataSetPL20182019(:,8:end)=[];

%Once we have the right table, we can rename the column headings to their
%full names so that the table is more user friendly.
DataSetPL20182019.Properties.VariableNames = {'Div' 'Date' 'HomeTeam' 'AwayTeam'...
    'FullTimeHomeGoals' 'FullTimeAwayGoals' 'FullTimeResult'};

%---------------------------------------------------------
%-- Create Additional Columns --%
%Now we want to create four base columns that can be appended to the dataset
%which will be populated by the Average Home Goals Scored, Average Home
%Goals Allowed, Average Away Goals Scored, Average Away Goals Allowed.
%For each column, we create an array of the right size, transpose it so it
%is the correct dimensions, then convert it to a table so it can be
%combined with the data set.
HomeTeamGoalsScored = [1:20];
HomeTeamGoalsScored = HomeTeamGoalsScored';
HomeTeamGoalsScored = array2table(HomeTeamGoalsScored);
AVGHomeTeamGoalsScored = [1:20];
AVGHomeTeamGoalsScored = AVGHomeTeamGoalsScored';
AVGHomeTeamGoalsScored = array2table(AVGHomeTeamGoalsScored);

HomeTeamGoalsAllowed = [1:20];
HomeTeamGoalsAllowed = HomeTeamGoalsAllowed';
HomeTeamGoalsAllowed = array2table(HomeTeamGoalsAllowed);
AVGHomeTeamGoalsAllowed = [1:20];
AVGHomeTeamGoalsAllowed = AVGHomeTeamGoalsAllowed';
AVGHomeTeamGoalsAllowed = array2table(AVGHomeTeamGoalsAllowed);

AwayTeamGoalsScored = [1:20];
AwayTeamGoalsScored = AwayTeamGoalsScored';
AwayTeamGoalsScored = array2table(AwayTeamGoalsScored);
AVGAwayTeamGoalsScored = [1:20];
AVGAwayTeamGoalsScored = AVGAwayTeamGoalsScored';
AVGAwayTeamGoalsScored = array2table(AVGAwayTeamGoalsScored);

AwayTeamGoalsAllowed = [1:20];
AwayTeamGoalsAllowed = AwayTeamGoalsAllowed';
AwayTeamGoalsAllowed = array2table(AwayTeamGoalsAllowed);
AVGAwayTeamGoalsAllowed = [1:20];
AVGAwayTeamGoalsAllowed = AVGAwayTeamGoalsAllowed';
AVGAwayTeamGoalsAllowed = array2table(AVGAwayTeamGoalsAllowed);

%Then we append it to the actual data set
PremierLeagueRanking20182019 = [PremierLeagueRanking20182019 HomeTeamGoalsScored...
    AVGHomeTeamGoalsScored HomeTeamGoalsAllowed AVGHomeTeamGoalsAllowed...
    AwayTeamGoalsScored AVGAwayTeamGoalsScored AwayTeamGoalsAllowed...
    AVGAwayTeamGoalsAllowed];

%-------------------------------------------------------
%-- Populate New Columns - Home Values --%
%Now we can fill those columns with the appropriate values. First we will
%fill in the Home team values with the values for the corresponding team 
%from the tablePL20182019 table. We do this by using the combination of
%loops below

%--------------------------------------------------------
%HomeTeam Goals Scored and Goals Allowed Loops
for j = 1:height(PremierLeagueRanking20182019)
    %For each row in the ranking table, we want to assign them as the home
    %team and sum up all of the goals they scored and allowed in as the
    %home team. First we assign a variable to know which team is the home
    %team for that row. We reset the goals scored and allowed to 0.
    HomeTeam = PremierLeagueRanking20182019.Var1{j};
    HomeGoalsScored = 0;
    HomeGoalsAllowed = 0;
    
for i = 1:height(DataSetPL20182019)
    %If the home team from the entire data set of every game matches the
    %home team we are looking for, we add that data to our variables and
    %place it in our table
    if strcmp(HomeTeam,DataSetPL20182019.HomeTeam(i))==1
        HomeGoalsScored = HomeGoalsScored + DataSetPL20182019.FullTimeHomeGoals(i);
        PremierLeagueRanking20182019.HomeTeamGoalsScored(j) = HomeGoalsScored;
        HomeGoalsAllowed = HomeGoalsAllowed +DataSetPL20182019.FullTimeAwayGoals(i);
        PremierLeagueRanking20182019.HomeTeamGoalsAllowed(j) = HomeGoalsAllowed;
    %otherwise we add 1 and continue the loop through the rows of data
    else i = i+1;
    end
end

end

%HomeTeam AVG Goals Scored and AVG Goals Allowed calculation loops. We take
%the totals from the previous loop and divide by 19 (number of home games)
for j = 1:height(PremierLeagueRanking20182019)
PremierLeagueRanking20182019.AVGHomeTeamGoalsScored(j) = PremierLeagueRanking20182019.HomeTeamGoalsScored(j)/19;
PremierLeagueRanking20182019.AVGHomeTeamGoalsAllowed(j) = PremierLeagueRanking20182019.HomeTeamGoalsAllowed(j)/19;
end

%Capturing the sum and average of each of the Home team columns populated in the table
%setting initial conditions
SumHomeTeamGoalsScored = 0;
SumAVGHomeTeamGoalsScored = 0;
SumHomeTeamGoalsAllowed = 0;
SumAVGHomeTeamGoalsAllowed = 0;
for j = 1:height(PremierLeagueRanking20182019)
%Adding up the values for each team in the table
SumHomeTeamGoalsScored = SumHomeTeamGoalsScored + PremierLeagueRanking20182019.HomeTeamGoalsScored(j);
SumAVGHomeTeamGoalsScored = SumAVGHomeTeamGoalsScored + PremierLeagueRanking20182019.AVGHomeTeamGoalsScored(j);
SumHomeTeamGoalsAllowed = SumHomeTeamGoalsAllowed + PremierLeagueRanking20182019.HomeTeamGoalsAllowed(j);
SumAVGHomeTeamGoalsAllowed = SumAVGHomeTeamGoalsAllowed + PremierLeagueRanking20182019.AVGHomeTeamGoalsAllowed(j);
end
AVGSumHomeTeamGoalsScored=SumHomeTeamGoalsScored/20;
AVGSumAVGHomeTeamGoalsScored=SumAVGHomeTeamGoalsScored/20;
AVGSumHomeTeamGoalsAllowed=SumHomeTeamGoalsAllowed/20;
AVGSumAVGHomeTeamGoalsAllowed=SumAVGHomeTeamGoalsAllowed/20;

%--------------------------------------------------------
%-- Populate New Columns - Away Values --%
%AwayTeam Goals Scored and Goals Allowed Loops
for j = 1:height(PremierLeagueRanking20182019)
    AwayTeam = PremierLeagueRanking20182019.Var1{j};
    AwayGoalsScored = 0;
    AwayGoalsAllowed = 0;
    
for i = 1:height(DataSetPL20182019)
    if strcmp(AwayTeam,DataSetPL20182019.AwayTeam(i))==1
        AwayGoalsScored = AwayGoalsScored + DataSetPL20182019.FullTimeAwayGoals(i);
        PremierLeagueRanking20182019.AwayTeamGoalsScored(j) = AwayGoalsScored;
        AwayGoalsAllowed = AwayGoalsAllowed +DataSetPL20182019.FullTimeHomeGoals(i);
        PremierLeagueRanking20182019.AwayTeamGoalsAllowed(j) = AwayGoalsAllowed;
    else i = i+1;
    end
end

end

%AwayTeam AVG Goals Scored and AVG Goals Allowed calculation loops
for j = 1:height(PremierLeagueRanking20182019)
PremierLeagueRanking20182019.AVGAwayTeamGoalsScored(j) = PremierLeagueRanking20182019.AwayTeamGoalsScored(j)/19;
PremierLeagueRanking20182019.AVGAwayTeamGoalsAllowed(j) = PremierLeagueRanking20182019.AwayTeamGoalsAllowed(j)/19;
end

%Sum and Avg for Away Totals
SumAwayTeamGoalsScored = 0;
SumAVGAwayTeamGoalsScored = 0;
SumAwayTeamGoalsAllowed = 0;
SumAVGAwayTeamGoalsAllowed = 0;
for j = 1:height(PremierLeagueRanking20182019)
SumAwayTeamGoalsScored = SumAwayTeamGoalsScored + PremierLeagueRanking20182019.AwayTeamGoalsScored(j);
SumAVGAwayTeamGoalsScored = SumAVGAwayTeamGoalsScored + PremierLeagueRanking20182019.AVGAwayTeamGoalsScored(j);
SumAwayTeamGoalsAllowed = SumAwayTeamGoalsAllowed + PremierLeagueRanking20182019.AwayTeamGoalsAllowed(j);
SumAVGAwayTeamGoalsAllowed = SumAVGAwayTeamGoalsAllowed + PremierLeagueRanking20182019.AVGAwayTeamGoalsAllowed(j);
end
AVGSumAwayTeamGoalsScored=SumAwayTeamGoalsScored/20;
AVGSumAVGAwayTeamGoalsScored=SumAVGAwayTeamGoalsScored/20;
AVGSumAwayTeamGoalsAllowed=SumAwayTeamGoalsAllowed/20;
AVGSumAVGAwayTeamGoalsAllowed=SumAVGAwayTeamGoalsAllowed/20;

%-------------------------------------------
%Cleaning up variables after all of these calculations so we just have the
%ones we want to use
clear AVGAwayTeamGoalsAllowed AVGAwayTeamGoalsScored AVGHomeTeamGoalsAllowed...
    AVGHomeTeamGoalsScored AwayGoalsAllowed AwayGoalsScored AwayTeam...
    AwayTeamGoalsAllowed AwayTeamGoalsScored HomeGoalsAllowed HomeGoalsScored...
    HomeTeam HomeTeamGoalsAllowed HomeTeamGoalsScored i j

%-----------------------------------------------
%-- Calculate Attacking and Defensive Strength --%
%Now we want to calculate the attacking and defensive strength for the home
%and away teams, we will do this in a new table. 
AttackDefenseStrength = PremierLeagueRanking20182019;
AttackDefenseStrength(:,2:end)=[];

%creating the matrices to be added to the table which we will fill in with
%the attack and defense strength after
HomeAtk = [1:20];
HomeAtk = HomeAtk';
HomeAtk = array2table(HomeAtk);
HomeDef = [1:20];
HomeDef = HomeDef';
HomeDef = array2table(HomeDef);
AwayAtk = [1:20];
AwayAtk = AwayAtk';
AwayAtk = array2table(AwayAtk);
AwayDef = [1:20];
AwayDef = AwayDef';
AwayDef = array2table(AwayDef);

%Adding these columns to the table
AttackDefenseStrength = [AttackDefenseStrength HomeAtk HomeDef AwayAtk...
    AwayDef];
clear HomeAtk HomeDef AwayAtk AwayDef

%-------------------------------------------
%Calculating the strength is done by taking the teams average goals scored
%and allowed for home and away and dividing it by the total average across
%all teams in the league. I.e. for Man City the home attacking strenght
%would be 3/1.5605 = 1.9224

for j = 1:height(PremierLeagueRanking20182019)
    AttackDefenseStrength.HomeAtk(j) = PremierLeagueRanking20182019.AVGHomeTeamGoalsScored(j)/AVGSumAVGHomeTeamGoalsScored;
    AttackDefenseStrength.HomeDef(j) = PremierLeagueRanking20182019.AVGHomeTeamGoalsAllowed(j)/AVGSumAVGHomeTeamGoalsAllowed;
    AttackDefenseStrength.AwayAtk(j) = PremierLeagueRanking20182019.AVGAwayTeamGoalsScored(j)/AVGSumAVGAwayTeamGoalsScored;
    AttackDefenseStrength.AwayDef(j) = PremierLeagueRanking20182019.AVGAwayTeamGoalsAllowed(j)/AVGSumAVGAwayTeamGoalsAllowed;
end
clear j
%-----------------------------------------------
%-- Prediction Model --%
%Now we want to predict the outcome of a match between two teams based on
%the data we have laid out above. The first step is to collect an input for
%the home team and the away team
disp('Please provide the home team and away team to see the predicted outcome for the match')
fprintf('Give the name in single quotes and select from the following: Man City, Liverpool, Chelsea,\n Tottenham, Arsenal, Man United, Wolves, Everton, Leicester, West Ham, Watford, Crystal Palace, Newcastle,\n Bournemouth, Burnley, Southampton, Brighton, Cardiff City, Fulham, Huddersfield')
fprintf('\n')
HomeTeam = input('Home Team: ');
AwayTeam = input('Away Team: ');

%Modifying this section of code to contain the summation of all the
%possible results between 1 and 10, broken down by win, loss, and draw, and
%then displaying overall win-lose percentages

n=10;
Percentage = zeros(n+1,n+1);

%Winning home team
%Setting up values for initial conditions
initial = 0;
MatchOutcomeProbabilitySum = 0;
for win = 1:n
   %This loops through all of the values of winning, for whatever we set n
   %to which in this case is 10
for x = 0:initial
   %Calculation for the match outcome probability for the home team to win,
   %which means they can score up to win-1 goals and the home team still
   %wins. Same calculation as before but now we are summing up each of the
   %win percentages and at the end should have a complete win percentage
   %total
   jhome = find(strcmp(AttackDefenseStrength.Var1, HomeTeam)==1);
   jaway = find(strcmp(AttackDefenseStrength.Var1, AwayTeam)==1);
   
   %Setting up the goal numbers for calculation. The home team will score
   %win number of goals for the first loop, meaning the away team scores up
   %to win-1, or the x number
   HomeTeamGoalsWin = win;
   AwayTeamGoalsWin = x;

   HomeGoalExpectancy = AVGSumAVGHomeTeamGoalsScored * AttackDefenseStrength.HomeAtk(jhome)...
    * AttackDefenseStrength.AwayDef(jaway);
   AwayGoalExpectancy = AVGSumAVGAwayTeamGoalsScored * AttackDefenseStrength.AwayAtk(jaway)...
    * AttackDefenseStrength.HomeDef(jhome);

   MatchOutcomeProbability = (poisspdf(HomeTeamGoalsWin,HomeGoalExpectancy)*...
    poisspdf(AwayTeamGoalsWin,AwayGoalExpectancy))*100;

   MatchOutcomeProbabilitySum = MatchOutcomeProbability + MatchOutcomeProbabilitySum;
   %populating percentage table with the calculated percentage for this
   %outcome
   Percentage(HomeTeamGoalsWin+1,AwayTeamGoalsWin+1) = MatchOutcomeProbability;
end
initial=initial+1;
end

%Winning Away team aka Losing Home Team
%Setting up values for initial conditions
initial = 0;
MatchOutcomeProbabilitySumLose = 0;
for win = 1:n
   %This loops through all of the values of winning, for whatever we set n
   %to which in this case is 10
for x = 0:initial
   %Calculation for the match outcome probability for the home team to win,
   %which means they can score up to win-1 goals and the home team still
   %wins. Same calculation as before but now we are summing up each of the
   %win percentages and at the end should have a complete win percentage
   %total
   jhome = find(strcmp(AttackDefenseStrength.Var1, HomeTeam)==1);
   jaway = find(strcmp(AttackDefenseStrength.Var1, AwayTeam)==1);
   
   %Setting up the goal numbers for calculation. The home team will score
   %win number of goals for the first loop, meaning the away team scores up
   %to win-1, or the x number
   HomeTeamGoalsLose = x;
   AwayTeamGoalsLose = win;

   HomeGoalExpectancy = AVGSumAVGHomeTeamGoalsScored * AttackDefenseStrength.HomeAtk(jhome)...
    * AttackDefenseStrength.AwayDef(jaway);
   AwayGoalExpectancy = AVGSumAVGAwayTeamGoalsScored * AttackDefenseStrength.AwayAtk(jaway)...
    * AttackDefenseStrength.HomeDef(jhome);

   MatchOutcomeProbability = (poisspdf(HomeTeamGoalsLose,HomeGoalExpectancy)*...
    poisspdf(AwayTeamGoalsLose,AwayGoalExpectancy))*100;

   MatchOutcomeProbabilitySumLose = MatchOutcomeProbability + MatchOutcomeProbabilitySumLose;
   
   %populating percentage table with the calculated percentage for this
   %outcome
   Percentage(HomeTeamGoalsLose+1,AwayTeamGoalsLose+1) = MatchOutcomeProbability;
end
initial=initial+1;
end

%Draw
%Setting up values for initial conditions
initial = 0;
MatchOutcomeProbabilitySumDraw = 0;
for win = 0:n

   %Calculation for the match outcome probability for the home team to win,
   %which means they can score up to win-1 goals and the home team still
   %wins. Same calculation as before but now we are summing up each of the
   %win percentages and at the end should have a complete win percentage
   %total
   jhome = find(strcmp(AttackDefenseStrength.Var1, HomeTeam)==1);
   jaway = find(strcmp(AttackDefenseStrength.Var1, AwayTeam)==1);
   
   %Setting up the goal numbers for calculation. The home team will score
   %win number of goals for the first loop, meaning the away team scores up
   %to win-1, or the x number
   HomeTeamGoalsDraw = win;
   AwayTeamGoalsDraw = win;

   HomeGoalExpectancy = AVGSumAVGHomeTeamGoalsScored * AttackDefenseStrength.HomeAtk(jhome)...
    * AttackDefenseStrength.AwayDef(jaway);
   AwayGoalExpectancy = AVGSumAVGAwayTeamGoalsScored * AttackDefenseStrength.AwayAtk(jaway)...
    * AttackDefenseStrength.HomeDef(jhome);

   MatchOutcomeProbability = (poisspdf(HomeTeamGoalsDraw,HomeGoalExpectancy)*...
    poisspdf(AwayTeamGoalsDraw,AwayGoalExpectancy))*100;

   MatchOutcomeProbabilitySumDraw = MatchOutcomeProbability + MatchOutcomeProbabilitySumDraw;
   
   %populating percentage table with the calculated percentage for this
   %outcome
   Percentage(HomeTeamGoalsDraw+1,AwayTeamGoalsDraw+1) = MatchOutcomeProbability;
end

['This home team has a ',num2str(MatchOutcomeProbabilitySumDraw),'% chance of winning']

%Displaying the results in a table
Check = MatchOutcomeProbabilitySum+MatchOutcomeProbabilitySumDraw+MatchOutcomeProbabilitySumLose

['This home team has a ',num2str(MatchOutcomeProbabilitySum),'% chance of winning']
['This home team has a ',num2str(MatchOutcomeProbabilitySumDraw),'% chance of drawing']
['This home team has a ',num2str(MatchOutcomeProbabilitySumLose),'% chance of losing']

HomeResultsText = {'Win %';'Draw %';'Lose %'};
HomeResults = [MatchOutcomeProbabilitySum;MatchOutcomeProbabilitySumDraw;MatchOutcomeProbabilitySumLose];
Output = table(HomeResultsText,HomeResults)

ResultTitle=['Home Team:',HomeTeam,' vs ','Away Team: ',AwayTeam];
HomeResultsText2 = categorical(HomeResultsText');

bar(HomeResultsText2,HomeResults)
title(ResultTitle)
ylabel('Percent Chance')
xlabel('Outcomes')

%Converting array to a table and updating
Percentage = array2table(Percentage);
Percentage.Properties.VariableNames = {'Away:0' 'Away:1' 'Away:2' 'Away:3'...
    'Away:4' 'Away:5' 'Away:6'...
    'Away:7' 'Away:8' 'Away:9' 'Away:10'};
PercentageRowLabel = {'Home:0';'Home:1';'Home:2';'Home:3';'Home:4';'Home:5';...
    'Home:6';'Home:7';'Home:8';'Home:9';'Home:10'};
PercentageRowLabel = array2table(PercentageRowLabel);
Percentage = [PercentageRowLabel Percentage];
