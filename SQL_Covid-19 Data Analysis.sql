/*
Covid-19 Data Exploration 

Skills used: Joins, Windows Functions, Aggregate Functions, 
Converting Data Types

*/

SELECT 
    *
FROM
    portfolio.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 3 , 4;


-- Select Data that we are going to be starting with

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    portfolio.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying covid in your country

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    portfolio.coviddeaths
WHERE
    location LIKE '%states%'
        AND continent IS NOT NULL
ORDER BY DeathPercentage DESC;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT 
    Location,
    date,
    Population,
    total_cases,
    (total_cases / population) * 100 AS PercentPopulationInfected
FROM
    portfolio.coviddeaths
WHERE
    location = 'United States'
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Infection Rate compared to Population

SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    portfolio.coviddeaths
GROUP BY location , population
ORDER BY PercentPopulationInfected DESC;


-- Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM portfolio.coviddeaths
-- Where location like '%states%' 
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCount DESC;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(CAST(Total_deaths AS float)) AS TotalDeathCount
FROM portfolio.coviddeaths
-- Where location like '%states%'
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, 
		SUM(CAST(new_deaths AS float)) AS total_deaths, 
        SUM(CAST(new_deaths AS float))/SUM(New_Cases)*100 AS DeathPercentage
FROM portfolio.coviddeaths
-- Where location like '%states%'
WHERE continent IS NOT NULL 
-- Group By date
ORDER BY 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, 
	vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
    FROM portfolio.coviddeaths dea
JOIN portfolio.covidvaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3 ;


