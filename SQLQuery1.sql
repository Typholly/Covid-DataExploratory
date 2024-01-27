Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be starting with
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  
(CONVERT(float, population) / NULLIF(CONVERT(float, total_cases), 0)) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population

SELECT
    Location,
    Population,
    MAX(NULLIF(CONVERT(float, total_cases), 0)) as HighestInfectionCount,
    MAX((NULLIF(CONVERT(float, total_cases), 0) / NULLIF(CONVERT(float, population), 0)) * 100) as PercentPopulationInfected
FROM
    PortfolioProject..CovidDeaths
--WHERE Location LIKE '%states%'
GROUP BY
    Location, Population
ORDER BY
    PercentPopulationInfected DESC

	-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS
SELECT SUM(cast(new_cases as int)) as total_cases,
    SUM(cast(new_deaths as int)) as total_deaths,
    CASE
        WHEN SUM(cast(new_cases as int)) > 0 THEN
            SUM(cast(new_deaths as int)) * 100.0 / SUM(cast(new_cases as int))
        ELSE
            0
    END as DeathPercentage
FROM
    PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;

--Total Population vs vaccinations 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as (
    Select 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
    From 
        PortfolioProject..CovidDeaths dea
    Join 
        PortfolioProject..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
    where 
        dea.continent is not null 
)

Select *, 
    (RollingPeopleVaccinated / NULLIF(CONVERT(float, Population), 0)) * 100 as VaccinationPercentage
From 
    PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    CASE 
        WHEN ISNUMERIC(dea.population) = 1 THEN CONVERT(NUMERIC, dea.population)
        ELSE NULL 
    END AS Population, 
    CASE 
        WHEN ISNUMERIC(vac.new_vaccinations) = 1 THEN CONVERT(NUMERIC, vac.new_vaccinations)
        ELSE NULL 
    END AS New_vaccinations,
    SUM(CASE 
        WHEN ISNUMERIC(vac.new_vaccinations) = 1 THEN CONVERT(NUMERIC, vac.new_vaccinations) 
        ELSE 0 
    END) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT *, 
    (RollingPeopleVaccinated / NULLIF(Population, 0)) * 100 AS PercentVaccinated
FROM 
    #PercentPopulationVaccinated;

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



