# Project 2: Open Data App - an RShiny app development project

### [Project Description](doc/project2_desc.md)

![](doc/US regional hospital ranking.png)

## [US Hospital Measure Cost and Ranking](https://pelican.shinyapps.io/hospital_charge_data/)

Term: Spring 2017

+ Team: #Group 6
+ Team members:
	+ Simmons Galen
	+ Xu Xuanzi
	+ Yuan Chengcheng
	+ Yao Siyuan
	+ Bondarenko Nikita

+ **Project Background**: 
We all know that the US hospital is expensive and measure information is not very clear and listed to us. Thus our group aims to build an app can provide regional hospital information of average covered charges, average total payments, measure ranking etc. With the help of this, we may can find a hospital with a higher ranking score but a relatively lower charge.

+ **Project Summary**: 
This project explores and visualizes the charge and ranking in the United States from 2012 to 2015, includes each hospital information like address, phone number, zip code, measure ID, average charge of a single measure. We created a Shiny App to help in 3 main tabs: Cost, Quality and Top Hospital Finder. 

 ??  1) Cost: This main tab contains 2 parts, one is procedure cost variation, which maps average, absolute cost of a medical procedure averaged across all hospitals in US. The second one is about hospital system revenues, describing the total charge, largest charge and top earning hospital&procedure.
    
 ??  2) Quality: This tab mainly presents hospital???s excess readmission ratio, coming with related data-table of complete information with readmission ratio.
   
    3) Top Hospital Finder: Based on the average score of different measures to rank top hospitals in the each state.
    
+ **Contribution statement**: 
Simmons Galen contributed to every step in this project. Xuanzi Xu created a shiny app including the choropleth maps, data table and the boxplots plotly. Chengcheng Yuan created the Top Hospital Finder part and made a shiny app, Chengcheng and Xuanzi worked together to make the map visualized nicely. Siyuan Yao made some data visualization such as the bar plots as well as the text editing and the presentation. Bondarenko Nikita contributed to the first step shiny app development.

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
