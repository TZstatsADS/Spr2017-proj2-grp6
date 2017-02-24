# Project 2: Open Data App - an RShiny app development project

### [Project Description](doc/project2_desc.md)

![](doc/US regional hospital ranking.png)

## [US Hospital Measure Charge and Ranking](https://pelican.shinyapps.io/hospital_charge_data/)

Term: Spring 2017

+ Team: #Group 6
+ Team members:
	+ Simmons Galen
	+ Xu Xuanzi
	+ Yuan Chengcheng
	+ Yao Siyuan
	+ Bondarenko Nikita

+ **Project Background**: 
We all know that the US hospital is expensive and the measure information is not very clear and listed to us. Thus our group aims to bulid an app can provide regional hospital information of average covered charges, average total payments, measure ranking etc. With the help of this, we may can find a hospital with a higher ranking score but a relatively lower charge.

+ **Project Summary**: 
This project explores and visualizes the charge and ranking in the United States from 2012 to 2015, include each hospital information like address, phone number, zip code, measure ID, average charge in single measure. We created a Shiny App to help in 3 main tabs: statistics, map and data. 
    + Statistics:
    + Map:This tab presents 4 maps. First one plots the USA map with the color represents the average score of every zip code or state for 14 measurements and also the one for the first measurement. The second one tells the average cost in each states. Next one plots two location map which are Location of the highest score hospitals for the 14 measurements and Location of the top ten score hospitals for the all measurement. The Last one indicates the top ranked hospital in each states.
    + Data: One is for hospital with highest score for each measurement name, the other is data table for one state and one measurement with the score from highest to lowest.
    
+ **Contribution statement**: 
All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement.

Hope this app could help us to find their suitable hospital!

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
_______app/
_______data/
_______doc/
_______lib/
_______output/
```
