-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Lets work on percentage_laid_off column
-- percentage_laid_off =  1 means 100% laid offs

SELECT
	MAX(total_laid_off),
    MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT
	company,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT
	MIN(`date`),
    MAX(`date`)
FROM layoffs_staging2;

SELECT
	industry,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT
	country,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT
	YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT
	stage,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT
	company,
    SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 1 DESC;

SELECT *
FROM layoffs_staging2;

-- Rolling Total Layoffs by Months

SELECT 
	SUBSTRING(`date`, 1, 7) AS `Month`,
    SUM(total_laid_off) AS Monthly_laidoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
;

-- Sum of rolling total lay offs (Month by Month Laidoffs progression)

WITH Rolling_Total AS
(	SELECT
		SUBSTRING(`date`, 1, 7) AS `Month`,
        SUM(total_laid_off) AS Monthly_laidoffs
	FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `Month`
    ORDER BY 1 ASC
)
SELECT
	Month,
	Monthly_laidoffs,
    SUM(Monthly_laidoffs) OVER (ORDER BY Month) AS Rolling_Total_Laidoffs
FROM Rolling_Total;
    
-- Lets Check By Company

SELECT
	company,
    YEAR(`date`) AS Year,
    SUM(total_laid_off) AS Yearly_Laidoffs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;

-- Lets Rank all the company on Yearly basis (Top 5 company Ranking)

WITH Company_Year (Company, Years, Total_Laid_Offs) AS
(
	SELECT
		company,
		YEAR(`date`),
		SUM(total_laid_off)
	FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(SELECT *,
	DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Laid_Offs DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
;
























