/* Functions (30+)
	1. Numeric 
		-	Date/time
		- 	Mathematical 
		- 	Statistical 

	2. Character 
*/

* Date/time functions;
* date and time literals
	'ddmonyyyy'd;

data dt1;
x  = 10;
name = "murali";
dt = '01jan1960'd;
tm = '00:01:56't;
dhm = '01jan1960:00:01:56'dt;
format dt date9. tm time8. dhm datetime20.;
run;

data dt2;
day = 20;
mon = 12;
yr = 2017;
hr = 1;
min = 1;
sec = 20;
dt = mdy(mon,day,yr);
tm = hms(hr,min,sec);
ts = dhms(dt,hr,min,sec);
format dt ddmmyy10. tm time8. ts datetime20.;
run;


data dt3;
set dt2 (keep=ts);
dp = datepart(ts);
tp = timepart(ts);
day = day(dp);
mon = month(dp);
year = year(dp);
hr = hour(tp);
min = minute(tp);
sec = second(tp);
td = today();

format dp td date9. tp time8.;
run;

proc print;
run;

















