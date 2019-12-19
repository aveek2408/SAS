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


























































