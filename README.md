Covid-19 Data Exploration and Analysis Using SQL

Objective 

The primary objective of this project is to delve into the Covid-19 pandemic dataset to extract meaningful insights and create charts focusing on several key aspects. These include the overall percentage of fatalities due to Covid-19, the variations in death rates from one country to another, the percentage of the population that was infected, comprehensive global statistics, and the total proportion of the population that contracted the virus.
This analysis aims to provide a clearer understanding of the pandemic's impact globally, highlighting differences in infection and mortality rates across various regions, and offering a detailed perspective on the extent of the spread and severity of the Covid-19 pandemic.

Data Source 

The dataset utilized in this project is openly accessible and sourced from Ourworldindata. It is subject to frequent updates. However, at the point when this project was undertaken, the latest update to the dataset was recorded on January 31st, 2024. As such, the analysis and insights drawn from this study are based on the Covid-19 data ranging from January 1, 2020, to December 12, 2022. 
This time frame allows for a comprehensive review of the data during the specified period, offering a detailed understanding of the pandemic's progression and impact over these years.

Data Processing 

After obtaining the dataset from Our World in Data, it was divided into two parts: 'covid_deaths' and 'covid_vaccinations'. This division enabled us to analyze the percentage of vaccinations administered in various countries. The data was then converted from its original .xlsx format to .csv for ease of handling.
The uploading process involved several steps in SQL Server Management Studio (SSMS). Firstly, I selected the database, then navigated to 'Tasks' > 'Import Data'. After clicking 'Next', I chose 'Flat file source' as the data source and selected the CSV file (notably, the file extension had to be changed during the selection process). I set the locale to 'English (United States)'. Following this, I chose the destination as 'Microsoft OLE DB Provider for SQL Server' and proceeded through the next steps until the process was finalized with 'Finish'.
Once the data was uploaded, I employed SQL for preprocessing tasks. This included removing missing and irrelevant values. It's important to note that there were no duplicates in the dataset, but I did eliminate null values. After these steps, the two tables, 'covid_deaths' and 'covid_vaccinations', were merged. This merger was crucial for obtaining clear and comprehensive results, providing a holistic view of the Covid-19 pandemic's impact in terms of both fatalities and vaccination efforts

Data Visualization 

The script for the analysis can be found Here 

Tableau Dashboard Here
