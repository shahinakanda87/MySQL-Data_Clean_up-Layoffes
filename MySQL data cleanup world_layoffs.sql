select * from layoffs
where company='Casper';

SELECT COUNT(*) AS total_records
FROM layoffs;

-- # 1. Remove Duplicates
-- # 2. Standarized data
---# 3. Null and Blanck Values
---# 4. Remove any Columns

drop table layoffs_stagging;

create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;

select * ,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
from layoffs_staging;


with duplicate_cte as 
(select * ,
row_number() over(
partition by company, location,industry, total_laid_off, percentage_laid_off, 'date', stage,country,funds_raised) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num>1;

select * from layoffs_staging
where company='Spotify';

----- Delet duplicates 

with duplicate_cte as 
(select * ,
row_number() over(
partition by company, location,industry, total_laid_off, percentage_laid_off, 'date', stage,country,funds_raised) as row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



select * from layoffs_staging2;


insert into layoffs_staging2
select * ,
row_number() over(
partition by company, location,industry, total_laid_off, percentage_laid_off, 'date', stage,country,funds_raised) as row_num
from layoffs_staging;


select * from layoffs_staging2
where row_num>1;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2 WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;

delete
from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;



---- Standarizing data

select company, (trim(company))
from layoffs_staging2;


update layoffs_staging2
set company=trim(company);

select distinct industry 
from layoffs_staging2
order by 1;


select distinct industry 
from layoffs_staging2
order by 1;




select *
from layoffs_staging2
where industry like 'Fin%';

select distinct industry
from layoffs_staging2 ;


select *
from layoffs_staging2
where row_num>1;


select distinct *
from layoffs_staging2
order by 1;


select distinct country
from layoffs_staging2
order by 1;

select distinct country, trim(Trailing '.'from country)
from layoffs_staging2
order by 1; 

update layoffs_staging2
set country=trim(Trailing '.'from country)
where country like 'United States%';


select date,
str_to_date(date, '%m/%d/%Y')
from layoffs_staging2;


alter table layoffs_staging2
modify column date date;


select * 
from layoffs_staging2;

--- work with null and blank 
select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;



select distinct* 
from layoffs_staging2
where industry is null
or industry='';

select * 
from layoffs_staging2
where industry is null
or industry='';


select * 
from layoffs_staging2
where company='Appsmith';

select count('layoff&pclayoff_0') 
from layoffs_staging2
where total_laid_off=''
and percentage_laid_off='';

delete
from layoffs_staging2
where total_laid_off=''
and percentage_laid_off='';

select * 
from layoffs_staging2
where total_laid_off=''
and percentage_laid_off='';

select * 
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

update layoffs_staging2
set total_laid_off=null
where total_laid_off='';

update layoffs_staging2
set percentage_laid_off=null
where percentage_laid_off='';
