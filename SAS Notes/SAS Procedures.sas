* Procedures 
	- Internal datasteps to SAS designed to perform repreated activities 
	- Proc print 
	- proc sort 
	- proc contents 
	- proc format 
	- proc import 
	- proc export 
	- Proc transpose 
	- Proc Means 
	- Proc Summary
	- Proc Freq
	- Proc Corr
	- Proc Report 
	- Proc Tabulate 
	- Proc printto 
	- proc datasets 
	- proc copy 
	- proc delete
; 

* 	1. Proc Print & Proc format 
	2. Proc import & export ;

* Proc print;
data class(drop=sex rename=(gender=sex)); 
retain name gender age height weight;
set sashelp.class; 
if sex ="F" then gender="Female";
else gender = "Male";
run;

proc print;
run;

* user defined formats; 
proc format;
	value $ gender_desc
		"M" = "Male"
		"F" = "Female"
	;
run;

proc print data=sashelp.class; 
format sex $gender_desc.;
run;


proc freq data=sashelp.cars;
tables Cylinders;
run;

proc format ;
	value cylinder
		3 = "Three Cylinders"
		4 = "Four Cylinders"
		5 = "Five Cylinders"
		6 = "Six Cylinders"
		8 = "Eight Cylinders"
		10 = "Ten Cylinders"
		12 = "Twelve Cylinders"
	;
run;

proc print data=sashelp.cars ;
	format Cylinders cylinder.;
run;

data cars;
set sashelp.cars; 
format Cylinders cylinder.;
run;

proc format ;
	value age_group
	low - 12   = "Under Age"
	13  - 15   = "Teens"
	16  - high = "Adults"
	;
run;

proc print data=sashelp.class; 
format age age_group.;
run;

* Proc Export ;
proc export 
	data = sashelp.class  /* input file */
	outfile = "C:\Users\user\Desktop\SAS Output\class.csv" /* output file */
	dbms = csv  /* which extension or which database to create */
	replace  /* Replace the output file in a specified location */
;
run;

proc export 
	data = sashelp.class  /* input file */
	outfile = "C:\Users\user\Desktop\SAS Output\class.xls" /* output file */
	dbms = xls  /* which extension or which database to create */
	replace  /* Replace the output file in a specified location */
;
run;

proc export 
	data = sashelp.class  /* input file */
	outfile = "C:\Users\user\Desktop\SAS Output\class.txt" /* output file */
	dbms = dlm  /* which extension or which database to create */
	replace  /* Replace the output file in a specified location */
;
run;


proc import 
	datafile = "C:\Users\user\Desktop\SAS Output\class.xls" /* Input file */
	out = class_new  /* output dataset */
	dbms = xls  /* which extension or which database to create */
	replace  /* Replace the output file in a specified location */
;
run;

proc import 
	datafile = "C:\Users\user\Desktop\SAS Output\class.csv" /* Input file */
	out = class_new  /* output dataset */
	dbms = csv  /* which extension or which database to create */
	replace  /* Replace the output file in a specified location */
;
run;

proc import 
	datafile = "C:\Users\user\Desktop\SAS Output\class.txt" /* Input file */
	out = class_m  /* output dataset */
	dbms = dlm  /* which extension or which database to create */
	  /* Replace the output file in a specified location */
;
run;

/* Proc Sort: 
	proc sort data=inp_ds out=out_ds <options>;
	by <by_variables>;
	run;

	<oprtions>: 
		- nodup
		- noduprec
		- nodupkey
*/ 
data super_market1;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
01Oct2019 20000
03Oct2019 12000
05Oct2019 50000
;
run;

data super_market2;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
02Oct2019 30000
04Oct2019 18000
;
run;

data super_market3;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
29Sep2019 32000
30Sep2019 48000
05Oct2019 40000
;
run;

data super_market4;
input run_date : date9. sales_amount super_market_name $;
format run_date : date9. sales_amount comma20.2;
datalines; 
01Oct2019 20000 B
03Oct2019 12000 B
05Oct2019 50000 B
;
run;

data super_market5;
input run_date : date9. sales_amount super_market_name $;
format run_date : date9. sales_amount comma20.2;
datalines; 
03Oct2019 30000 A
04Oct2019 18000 A
;
run;

data super_market_name;
set super_market4 super_market5;
run;

data super_market_total;
set super_market1 super_market2 super_market3;
run;

proc sort data=super_market_total out=super_market_run_dt_sorted;
by run_date;
run;

proc sort data=super_market_total out=super_market_sale_amt_sorted;
by sales_amount;
run;

proc sort data=super_market_total out=sorted_all_variables;
by run_date sales_amount;
run;

proc sort data=super_market_total out=sorted_all_variables;
by _all_;
run;

proc sort data=super_market_name out=sorted_all_variables;
by _all_;
run;

proc sort data=super_market_name out=sorted_all_variables;
by _character_;
run;

proc sort data=super_market_name out=sorted_all_variables;
by _numeric_;
run;

proc sort data=super_market_total out=sorted_all_variables_desc;
by run_date descending sales_amount;
run;

proc sort data=super_market_total ;
by descending _all_;
run;


* nodup, noduprec & nodupkey;
data test;
input ID NAME $; 
datalines; 
101 A
102 B
101 A
101 C
101 D
104 A
104 B
103 C
103 D
105 A
104 B
;
run;

* nodup & noduprec ---> Remove duplicates at row level; 

proc sort data=test out=test_sort ;
by _all_;
run;

proc print;
run;

proc sort data=test out=test_sort_nodup nodup ;
by _all_;
run;


proc sort data=test out=test_sort_noduprec noduprec ;
by _all_;
run;

* nodupkey ---> remove duplicates at a key (variable) level
				nodupkey with by varaible as _all_ is equivalent to nodup;


proc sort data=test out=test_sort_nodupkey nodupkey ;
by _all_;
run;

proc sort data=test out=test_sort_nodupkey nodupkey ;
by id name;
run;

proc sort data=test out=test_sort_nodupkey nodupkey ;
by name id;
run;


proc sort data=test out=test_sort_nodupkey  ;
by id;
run;
proc print; run;

proc sort data=test out=test_sort_nodupkey nodupkey ;
by id;
run;



proc sort data=test out=test_sort_nodupkey  ;
by name;
run;
proc print; run;

proc sort data=test out=test_sort_nodupkey nodupkey ;
by name;
run;

proc sort data=sashelp.class out=class nodupkey; 
by sex age;
run;

proc sort data=sashelp.class out=class nodup; 
by sex age;
run;

/* Proc Transpose 
proc transpose data=inp_ds out=out_ds <options>;
<statements>;
run;

*/

data narrow_file1;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Blk    bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;

proc print; run;

proc transpose data=narrow_file1 out=default;
run;
proc print; run;


proc transpose data=narrow_file1 out=default_id;
id pet_owner;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id suffix = _new prefix=fraud_;
id pet_owner
;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
id pet_owner 
;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner;
run;
proc print; run;


proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner pet;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner pet;
id population;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed
prefix=population_;
var pet_owner pet;
id population;
run;
proc print; run;


data narrow_file1;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Black bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;

proc transpose data=narrow_file1 out=default_1 ; 
id pet_owner; 
run;


proc transpose data=narrow_file1 out=default_1 let; 
id pet_owner; 
run;

proc print; run;

* Proc mean;
