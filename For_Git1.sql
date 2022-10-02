



/* Dataset SAMPLE downloaded from Kaggle 
COLUMNS		||	Their data
____________||_______________________________________________
title 		||  EMS: BUILDING FIRE
descr 		||  PRESIDENTIAL BLVD & E CITY AVE;  LOWER MERION; Station 313; 2015-12-14 @ 16:12:09;
time_stamp  || 	12/14/2015 16:12:09
twp			|| 	LOWER MERION
addr		||	KEIM ST & BICKEL RD
zip 		||	19004

*/


With deta as (select ds.title 
, ds.descr as Description
, ds.time_stamp
, ds.twp as Town
, ds.addr as Short_Address
, zc.Town as Maps_Town
, zc.US_State 
, ds.zip as Zip_Code

, EXTRACT (hour from cast(ds.time_Stamp as TIMESTAMP) ) as Hours /*Will use hours in future study  */
, to_char (ds.time_stamp , 'DY', 'NLS_DATE_LANGUAGE=ENGLISH' ) as Day_of_the_Week  /* Will use DOW for future study */
, to_char (ds.time_stamp , 'MM' ) as Months  /* Will use Months for future study */
, to_char (ds.time_stamp , 'YYYY' ) as Years
, substr  (ds.descr , instr(ds.descr, 'station ')+8,3) as Station_responded  /* Getting from Description column which Station responded */
, case  when extract (hour from cast (ds.time_Stamp as TIMESTAMP)) between 6  and 12 then 'Morning'   ELSE
		when extract (hour from cast (ds.time_Stamp as TIMESTAMP)) between 13 and 20 then 'Afternoon' ELSE
		when extract (hour from cast (ds.time_Stamp as TIMESTAMP)) between 21 and 24 then 'Night'     ELSE
		when extract (hour from cast (ds.time_Stamp as TIMESTAMP)) between 1  and 5  then 'Night'     ELSE 'Missing Time'
		end as Part_of_the_Day  /* will use for future analysis */
, 1 as for_counts

from dataset ds 
, zipcodes zc /* got from google to find if the given town in dataset match the Town in Zipcode data */

where ds.zip = zc.zipcode
--and to_char (ds.time_stamp, 'YYYY') in 2015  /* year of study 2015 from all dataset */
and upper (ds.title) like '%BUILDING FIRE%' /* Case study building fire */ 
)

Select * from deta


/* Question that we can answer*/
/*Month with the most building fires*/

select ds.months 
, ds.years
, sum (ds.counts) as sum_occurences
from deta ds
group_by ds.months , ds.years
order by sum_occurences desc



/* Day of the week with most building fires by years */

select ds.Day_of_the_Week 
, ds.years
, sum (ds.counts) as sum_occurences
from deta ds
group_by ds.Day_of_the_Week  ,ds.years
order by sum_occurences desc


/* zip code with most building fires */

select ds.Zip_Code
, ds.years
, sum (ds.counts) as sum_occurences
from deta ds
group_by ds.Zip_Code , ds.years
order by sum_occurences desc

/* Part of the day and Month with mos occurences */

select da.hours
, ds.Day_of_the_Week
, ds.Part_of_the_Day
, ds.years
, da.hours ||'-'|| ds.Day_of_the_Week ||'-'|| ds.Part_of_the_Day as H_D_Month
, sum (ds.counts) as sum_occurences
from deta ds
group by  da.hours
, ds.Day_of_the_Week
, ds.Part_of_the_Day
, ds.years
, da.hours ||'-'|| ds.Day_of_the_Week ||'-'|| ds.Part_of_the_Day
order by sum_occurences desc


