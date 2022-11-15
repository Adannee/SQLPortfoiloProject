
Select *
From PortfoiloProject ..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfoiloProject ..['covid-vac$']
--order by 3,4

-- Select Data
Select location, date, total_cases,new_cases, total_deaths, population
From PortfoiloProject ..CovidDeaths
Where continent is not null
order by 1,2

-- Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfoiloProject ..CovidDeaths
Where location = 'Nigeria'
and continent is not null
order by 1,2

-- Total Cases vs Population
Select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
From PortfoiloProject ..CovidDeaths
Where location = 'Nigeria'
and continent is not null
order by 1,2

-- Countries with Higest Infection Rate compared to Population
Select location, population, MAX(total_cases) as HighestNoOfCases, MAX((total_cases/population))*100 as CasesPercentage
From PortfoiloProject ..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by location, population
order by CasesPercentage desc;

-- Countries with the Highest Death Count per Population
Select location,  MAX(cast(total_deaths as int)) as HighestNoOfDeaths
From PortfoiloProject ..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by location
order by HighestNoOfDeaths desc

-- GROUPING BY CONTINENT WITH HIGHEST DEATH
Select continent,  MAX(cast(total_deaths as int)) as HighestNoOfDeaths
From PortfoiloProject ..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by continent
order by HighestNoOfDeaths desc



-- GLOBAL NUMBERS


Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfoiloProject ..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
--Group By date
order by 1,2


-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/dea.population)* 100
From PortfoiloProject ..CovidDeaths dea
Join PortfoiloProject ..['covid-vac'] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)* 100
From PortfoiloProject ..CovidDeaths dea
Join PortfoiloProject ..['covid-vac'] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)
From PopvsVac

-- TEMP TABLE

DROP table if exists #PercentPopulatingVaccisoned
Create Table #PercentPopulatingVaccisoned
(continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulatingVaccisoned
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)* 100
From PortfoiloProject ..CovidDeaths dea
Join PortfoiloProject ..['covid-vac'] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulatingVaccisoned

-- Creating View to store data

Create View PercentPopulatingVaccisoned as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)* 100
From PortfoiloProject ..CovidDeaths dea
Join PortfoiloProject ..['covid-vac'] vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3