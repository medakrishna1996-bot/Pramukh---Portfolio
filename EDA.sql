-- Exploratory Data Analysis
-- EDA

-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!

SELECT *
FROM layoffs_staging2;

-- EASIER QUERIES

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- which companies had 1  which is basically 100 percent of the company laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch



SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM  layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
-- Consumer and Retail industries had maximum layoff

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
-- United States and India had by far the most layoffs

SELECT  YEAR (`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR (`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS layof
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,layof,
 SUM(layof) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY RANKING ASC
)
SELECT * 
FROM Company_Year_Rank 
WHERE ranking <=5;
