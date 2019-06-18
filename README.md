# BlueLabs Capstone
Research on Voter Support and Access to Care

This repo contains my final project as a Data Analyst Fellow, where I examine how delaying 
healthcare because of costs impacted voter support in the 2012 and 2016 general elections. 

## Research Design 

With health care being the [number one issue](https://www.cnbc.com/2018/11/07/healthcare-topped-the-economy-as-the-biggest-issue-for-voters-now-heres-why.html) for the Democrats in 2018, I wanted to develop a better understanding of how the issue has affected vote choice in the past. Using the paper "Access to health care and voting behavior in the United States." (Ziegenfuss et. al. 2008) as a reference, data from the [American National Election Studies](https://electionstudies.org/) was a reliable source for national trends in access to care. Moreover, the ANES surveys have comprehensive demographic, financial, and political data from respondents. My initial hypothesis is that voters who lacked access to care were more likely to vote Republican in protest of the status quo.

## Data Wrangling 

ANES survey results from 2012 and 2016 were filtered to only include those who voted in that year's general election. Each survey contained dozens of variables, which were filtered down to ten (age, race, vote choice, income, party identification, education, gender, Affordable Care Act support, having delayed health care, and not paying for healthcare). 

The data was then uploaded into Vertica using a SQL script, and converted into demographic crosstabs with Python and SQL. For these crosstabs, appropriate weights were applied to each variable; missing data and null responses were removed from the final outcomes. The summary output of those crosstabs is available [here](https://docs.google.com/spreadsheets/d/1Dj4MGMqVhuwUHXseK-JETvqgfU1WE8QKrGq8DwfAPEQ/edit?usp=sharing). 

## Visualizations and Analysis

After creating tables in Vertica with demographic crosstab for 2012 and 2016, I queried the tables from R Studio and built out relevant visualizations using ggplot2 and tidyverse. For the analysis, I focused on Obama-Trump voters and Independents as key segments of the survey who both showed high rates of delay in care.

Republican voters were only marginally more likely to have delayed care than Democrats in 2016. This could be because Republican districts were less likely to have passed Medicaid expansion than Democratic regions, and therefore delayed care. Testing whether or not geography played a role in responses is challenging. While the ANES does provide the state of each respondent, there are usually less than 200 per state, without filtering for respondents who voted. Overall, Democrats and Republicans both delayed care at higher rates in 2016 than 2012. 
