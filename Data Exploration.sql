

--USE PortfolioProject

Select * From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Selecting Data required 

Select location , date, total_cases, new_cases, total_Deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Total Cases VS Total deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) *100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total cases VS Population
--Shows what percentage of population got covid
Select location,date,total_cases,population,(total_cases/population) *100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
order by 1,2

--Countries with highest infection rate VS Population

Select location,Population,MAX(total_cases) as HighestInfectioncount ,Max((total_cases/population)) * 100 AS PercentpopulationInfected
From PortfolioProject..CovidDeaths
GROUp BY location,Population
order by PercentpopulationInfected desc

--Countries with highest deaths per population
Select location,MAX(cast(total_deaths as int)) as TotalDeathcount 
from PortfolioProject..coviddeaths
where continent is not null
group by location
order by TotalDeathcount desc

--by continent(total death count)
Select continent,MAX(cast(total_deaths as int)) as TotalDeathcount 
from PortfolioProject..coviddeaths
where continent is not null
group by continent
order by TotalDeathcount desc

--Global Numbers
Select SUM(new_cases) as Total_cases,SUM(CAST(new_deaths as int)) as Total_deths ,SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Total population vs vaccination

--USE CTE

With PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
Select dea.Continent,dea.Location,dea.date,dea.Population,vac.New_Vaccinations,SUM
(CONVERT(int,vac.New_Vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..Covidvaccinations as vac
  ON dea.location = vac.location and
     dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
select * from PopvsVac

--USE TEMP TABLES 
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinated numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.Continent,dea.Location,dea.date,dea.Population,vac.New_Vaccinations,SUM
(CONVERT(int,vac.New_Vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..Covidvaccinations as vac
  ON dea.location = vac.location and
     dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

--Views

Create View PercentPopulationVaccinated
as 
Select dea.Continent,dea.Location,dea.date,dea.Population,vac.New_Vaccinations,SUM
(CONVERT(int,vac.New_Vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..Covidvaccinations as vac
  ON dea.location = vac.location and
     dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3


Create view TotalSummary
as
Select SUM(new_cases) as Total_cases,SUM(CAST(new_deaths as int)) as Total_deths ,SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
FROM PortfolioProject..CovidDeaths
where continent is not null
--order by 1,2

select * from TotalSummary




