--DATA EXPLORATORY PROJECT ON COVID DATA DATED 2020 - APRIL 2021--
select location, date, total_cases, total_deaths, population
from Portfolioprojects..CovidDeaths
order by 1,2


--comparing total cases vs total deaths in the United Kingdom
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolioprojects..CovidDeaths
Where location like '%Kingdom%'
order by 1,2

--comparing total cases vs Population in the United Kingdom, showing what % of the UK population had Covid between 2020 - April 2021
select location, date, total_cases, population, (total_cases/population)*100 as Percentpopulationinfected
from Portfolioprojects..CovidDeaths
Where location like '%Kingdom%'
order by 1,2

--To determine the Location with the highest rate of infection per population
select location,population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as Percentpopulationinfected
from Portfolioprojects..CovidDeaths
where continent is not null
group by location, population
order by Percentpopulationinfected desc

--Showing Locations with Highest Death Counts
select location, max(cast(total_deaths as int)) as totaldeathcount
from Portfolioprojects..CovidDeaths
where continent is not null
group by location
order by totaldeathcount desc

--Showing Locations with Highest Death Counts
select continent, max(cast(total_deaths as int)) as totaldeathcount
from Portfolioprojects..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc

--Global Percentage of daily deaths per cases
select date, sum (new_cases) as totaldailycases, sum(cast(new_deaths as int)) as totaldailydeaths, 
sum(cast(new_deaths as int))/sum (new_cases)*100 as dailypercentageofdeaths
from Portfolioprojects..CovidDeaths
where continent is not null
group by date
order by 1,2

--Total Global Percentage of daily deaths per cases
select sum (new_cases) as totaldailycases, sum(cast(new_deaths as int)) as totaldailydeaths, 
sum(cast(new_deaths as int))/sum (new_cases)*100 as dailypercentageofdeaths
from Portfolioprojects..CovidDeaths
where continent is not null
order by 1,2

--Joining Tables
select *
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac 
on dea.location = vac.location
and dea.date = vac.date


--Determining Total Population Vs number of persons Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Rolling sum of new vacc
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT (INT, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingsumofpeoplevaccinated
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE
WITH POPSVAC (continent,location,date,population,new_vaccinations,Rollingsumofpeoplevaccinated)as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT (INT, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingsumofpeoplevaccinated
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
SELECT *, (Rollingsumofpeoplevaccinated/population)*100 as percentagerollingsum
from POPSVAC


--View
Create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT (INT, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingsumofpeoplevaccinated
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
