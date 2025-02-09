---- Exploratory Data Analysis
---- Lets check the data
select percentage_laid_off 
from layoffs_staging2;

---- Select maximum number of laid off in a single event
select max(total_laid_off)
from layoffs_staging2; 
--- this selection ended up with wrong reasult as total_laid_off numbers are not number rtahger in text format.alter


--- Lets change the data type in total_laid_off and in percentage_laid_off

alter table layoffs_staging2
modify column total_laid_off int;

alter table layoffs_staging2
modify column percentage_laid_off decimal(4,2);

--- Lets see again total maximum numkber of laid_off and % of laid_off in a single record 

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;


--- Lets chech what are the records contains highest number of laid_off in a single evcent is true

select * 
from layoffs_staging2
where total_laid_off=15000;

--- Lets chech what are the records contains 100% laid off 

select * 
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised desc;

select * from layoffs_staging2 where company='Katerra';

--- Lets check if it is really 257 
select count(*) 
from layoffs_staging2
where percentage_laid_off=1;

--- bingo really it is


--- Alter the data type in funds_raised_millions

UPDATE layoffs_staging2
SET funds_raised = NULL
WHERE funds_raised = '';

alter table layoffs_staging2
modify column funds_raised int;

select * 
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(date), max(date)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select date, sum(total_laid_off)
from layoffs_staging2
group by date
order by 1 desc;


select year(date), sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 desc;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

--- Progression of layoffs
select substring(date,1,7) as Month, sum(total_laid_off)
from layoffs_staging2
group by Month
order by Month;


with Rolling_Total as 
(select substring(date,1,7) as Month, sum(total_laid_off) as total_off
from layoffs_staging2
group by Month
order by 1 asc
)
select month, total_off, sum(total_off) over (order by month) as rolling_total
from Rolling_Total;



select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
order by 3 desc;



with company_year ( company, years, total_laid_off)  as
(
select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
), Company_Year_Rank as 
(select*, dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select * 
from Company_Year_Rank
where Ranking<=5; 
