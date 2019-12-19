/* 
Numeric 
	- Mathematical or arthematic 
	- Statistical 
	- Date and Time 
		- Literals ""d ""t ""dt
	- today's date ---> today()
	- datepart and timepart 
	- day, month, year, hour, minute, second
	- mdy, yyq

	- yearcutoff (option)
	- yrdif
	- intnx & intck
*/

data test;
	name = "Murali Krishna";
	age = 33; 

	today_date = "27sep2019"d;
	
	sas_time = "05:58"t;

	time_stamp = "27sep2019:06:03:36"dt;

	format today_date date9. sas_time time5. time_stamp datetime18.;
run;


data test;
	name = "Murali Krishna";
	age = 33; 

	today_date = today();
	format today_date date9. ;
run;

data test;
time_stamp = "27sep2019:06:03:36"dt;
sas_date = datepart(time_stamp);
sas_time = timepart(time_stamp);


format time_stamp datetime18. sas_date date9. sas_time time8.;
run;


*
Health Care System 
claim ---> validate ---> make a payment 

1Lakh
10 claims ---> specific doctor ---> yesterday 

two runs ---> ETL ---> Moring run & Evening run
09:00 (AM)	---> First run  ---> data from previous day 7PM to current day 9AM
07:00 (PM)  ---> second run ---> data from current day 9AM to 7PM

Identified?

10AM ---> xyz ---> Not Fraud
11AM

which_run
09:00:00 ---> run_1
run_2
;


data test;
time_stamp = "27sep2019:06:03:36"dt;
sas_date = datepart(time_stamp);
sas_time = timepart(time_stamp);

/*day = day(datepart(time_stamp));*/
day 	= day(sas_date);
month 	= month(sas_date); 
year 	= year(sas_date); 
hr 		= hour(sas_date) 	; 
min		= minute(sas_date)	; 
sec 	= second(sas_date); 
format time_stamp datetime18. sas_date date9. sas_time time8.;
run;


data new; 
day = 27;
mon = 9; 
yr = 2019; 

dt = mdy(mon, day, yr);

dt1 = yyq(2019, 1);
dt2 = yyq(2019, 2);
dt3 = yyq(2019, 3);
dt4 = yyq(2019, 4);

format dt dt1 dt2 dt3 dt4 date9.;
run;

* How to handle a 2 digit year 
	- 01/01/15 ---> 01/01/2015? or 01/01/1915?
	What is the prefix for a 2 digit year?
;

/*
SAS Option 
yearcutoff = 1920;
1920 - 2019 (100) 

1920 - 1999  (20-99)	---> prefix 19
2000 - 2019  (00-19)	---> prefix 20
*/

data year; 
input dob : date7.;
format dob : date9.;
datalines; 
08Jan00
09Jan10
01Jan15
02Jan16
03Jan19
05Jan20
05Jan21
05Jan22
05Jan30
05Jan40
05Jan60
05Jan70
06Jan50
07Jan90
07Jan99
;
run;


options yearcutoff=1930;

/*
1930 - 2029
30 - 99 19 
00 - 29 20
*/
data year; 
input dob : date7.;
format dob : date9.;
datalines; 
08Jan00
09Jan10
01Jan15
02Jan16
03Jan19
05Jan20
05Jan21
05Jan22
05Jan30
05Jan40
05Jan60
05Jan70
06Jan50
07Jan90
07Jan99
;
run;

proc print;
run;

options yearcutoff=1920;


* age & ROI
Difference between SAS Dates
	- Actaul difference (yrdif )
				Day/date difference ? ---> Function?
		--> number of days in each month as-is and 
			number of days in each year as-is
				Jan - 31
				Feb - 28 (29)
				Mar - 31
				Apr - 30
				Dec - 31 
			year ---> 365 (366)

		--> 30/360
				Jan - Dec --> 30 
				year      --> 360

		--> 30/act 
				Jan - Dec --> 30 
				year      --> 365 (366)

		--> act/360 
				Jan - 31
				Feb - 28 (29)
				Mar - 31
				Apr - 30
				Dec - 31  
				year      --> 360


	- Interval differnece (intck)
		- day 
		- Month 
		- Year
		- Quarter 
		- Week 
;

data age; 
	dob = '11sep1986'd;
	today = '01Oct2019'd;
/*	age = today - dob;*/
	age = yrdif(dob, today);
	age1 = yrdif(dob, today,'act');
	age2 = yrdif(dob, today,'act/act');
	age3 = yrdif(dob, today,'30/act');
	age4 = yrdif(dob, today,'act/360');
	age5 = yrdif(dob, today,'30/360');
	format dob today date9.;
run;



data interval; 
	dob = '11sep1986'd;
	today = '01Oct2019'd;
	day_diff   = intck('day', dob, today);
	month_diff = intck('month', dob, today);
	year_diff  = intck('year', dob, today);
	format dob today date9.;
run;

data interval; 
	dob = '01jan2019'd;
	today = '31dec2019'd;
	day_diff   = intck('day', dob, today);
	month_diff = intck('month', dob, today);
	year_diff  = intck('year', dob, today);
	week_diff  = intck('week', dob, today);
	quarter_diff  = intck('quarter', dob, today);
	year_diff_1 = yrdif(dob, today,'act/act');
	format dob today date9.;
run;

* intnx
	- intnx('interval', date, n, 'argument')
;

data int_nx; 
today = '01Oct2019'd;
tomorrow = intnx('day', today, 1);
yesterday = intnx('day', today, -1);
next_month = intnx('month', today, 1);
format today tomorrow yesterday next_month date9.;
run;

data int_nx; 
old_run_date = '15sep2019'd;
next_run_date = intnx('month', old_run_date, 1);
next_run_date_1 = intnx('year', old_run_date, 1);
format old_run_date next_run_date next_run_date_1 date9.;
run;

data int_nx; 
old_run_date = '15sep2019'd;
next_run_date = intnx('month', old_run_date, 1, 's');
next_run_date_1 = intnx('year', old_run_date, 1, 's');
format old_run_date next_run_date next_run_date_1 date9.;
run;

data int_nx; 
old_run_date = '15mar2019'd;
next_month_end = intnx('month', old_run_date, 1, 'e');
prev_month_end = intnx('month', old_run_date, -1, 'e');
format old_run_date next_month_end prev_month_end date9.;
run;

proc print; 
run;

























































