* SAS Date & Time
	- Date as a Numeric Value - Data type 
	- Various formats of Date are
	 	11-09-2019 (ddmmyy)
		11/09/2019
		09/11/2019
		09/11/19
		11/9/19
		11Sep2019
		11Sep19

	- Calculate Number of days elapsed from SAS Reference date
		and store the value 
		SAS Reference date 	---> 01Jan1960 

	- For an example, 
		01Jan1960 	---> 0
		02Jan1960	---> 1
		31Dec1959	---> -1
		31Dec1960	---> 365
		11Sep2019	---> XXXXX

	- Time??
		05:55:35 (hh:mm:ss)
		23:30:55
	- Calculate Number of Seconds that are elapsed from Start of the day 
		Start of the day ---> 00:00:00

	- Amount, Salary or Currency
		1,05,000	---> 105000
		$10,000,000	---> 1000000

	- Non Standard data (Standard 0123456789 . + -)
	- Convert this Non Standard data into Standard data (Informat)
	- Informat can guide SAS "How to read your data"
	- Format can guide SAS "How to WRITE your data"
; 

* Without infromat;
data transactions;
input 	
	@1	transaction_id		$6.
	@9	transaction_date
	@20	transaction_amount	
;
datalines;
124325 	09/11/2019 1,250.03
7 		09/10/2019 12,500.02
114565 	08/30/2019 5.11
;
run;

* With infromat;
data transactions;
input 	
	@1	transaction_id		$6.
	@9	transaction_date
	@20	transaction_amount	
;
informat 
	transaction_date		mmddyy10.
	transaction_amount		comma9.2
;
format 
	transaction_date		mmddyy10.
	transaction_amount		comma9.2
;
datalines;
124325 	09/11/2019 1,250.03
7 		09/10/2019 12,500.02
114565 	08/30/2019 5.11
;
run;

data transactions;
input 	
	@1	transaction_id		$6.
	@9	transaction_date
	@20	transaction_amount	
;
informat 
	transaction_date		mmddyy10.
	transaction_amount		comma9.2
;
format 
	transaction_date		date9.
	transaction_amount		dollar25.2
;
datalines;
124325 	09/11/2019 1,250.03
7 		09/10/2019 12,500.02
114565 	08/30/2019 5.11
;
run;


* 	09/27/2019
	27/09/2018
	27/09/18
	09/27/18
	09272018
	27092018
	092718
	27918
;

* 
yearcutoff 
	2 digit year --> Prefix 
27/09/18	27/09/2018
27/09/19	27/09/2019
27/09/20	27/09/1920
;

data transactions;
input 	
	@1	transaction_id		$6.
	@9	transaction_time
	@15	transaction_amount	
;
informat 
	transaction_time		time5.
	transaction_amount		comma9.2
;
format 
	transaction_time		time5.
	transaction_amount		dollar25.2
;
datalines;
124325 	05:35 1,250.03
7 		07:20 12,500.02
114565 	23:25 5.11
;
run;



data transactions;
input 	
	@1	transaction_id		$6.
	@9	transaction_time
	@15	transaction_amount	
;
informat 
	transaction_time		time5.
	transaction_amount		comma9.2
;
format 
	transaction_time		time8.
	transaction_amount		dollar25.2
;
datalines;
124325 	05:35 1,250.03
7 		07:20 12,500.02
114565 	23:25 5.11
;
run;

*
time5 	---> hh:mm
time8	---> hh:mm:ss 
;
proc print;
run;

* time stamp
	- Logs 
	- Data is changing dynamically

	;

data transactions (drop=hr min sec);
input 	
	@1	transaction_id		$6.
	@9	transaction_date
	@20	transaction_time
	@29	transaction_amount	
;
informat 
	transaction_date		mmddyy10.
	transaction_time		time8.
	transaction_amount		comma9.2
;
format 
	transaction_date		date9.
	transaction_time		time8.
	transaction_amount		dollar25.2
	ts						datetime18.
;

hr = hour(transaction_time);
min = minute(transaction_time);
sec = second(transaction_time);

ts = dhms(transaction_date,hr,min,sec);

datalines;
124325 	09/10/2019 05:35:24 1,250.03
7 		09/10/2019 07:20:59 12,500.02
114565 	09/10/2019 23:25:34 5.11
124326 	09/11/2019 05:35:24 1,250.03
9667	09/11/2019 07:20:59 12,500.02
114589 	09/11/2019 23:25:34 5.11
;
run;


data new;
set transactions;
where datepart(ts) = '10Sep2019'd;
run;

* teradata; 

proc sql;
connect to oracle (
	oracle compatible code 
)
quit;
















