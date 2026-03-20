-- data cleaning 
select *
from layoffs;

-- 1) removing duplicates
-- 2) standrize data like issues in spelling
-- 3) dealing with null values or blank values
-- 4) remove any columns

create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

select * from layoffs_staging;

-- 1) removing duplicates


SELECT * ,
ROW_NUMBER() OVER(
partition by
company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging;

WITH duplicate_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER(
partition by
company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging
)

SELECT *
FROM duplicate_cte
Where row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2
where row_num > 1;

insert into layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
partition by
company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging;

delete 
from layoffs_staging2
where row_num > 1;

select * 
from layoffs_staging2;


-- 2) standardizing data

select distinct(trim(company)),company
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

UPDATE layoffs_staging2
SET industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging2
order by 1;

select distinct country , trim(trailing '.' from country)
from layoffs_staging2
order by 1;

Update layoffs_staging2
set country =  trim(trailing '.' from country)
where country like 'United States%';

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

UPDATE layoffs_staging2
set  = str_to_date(`date`,'%m/%d/%Y');

-- to change date data type from text into date after changing its typing by str_to_date 

alter table layoffs_staging2
modify column `date` DATE;


select *
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

select * 
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company 
and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company 
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

DELETE
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

select * from layoffs_staging2;