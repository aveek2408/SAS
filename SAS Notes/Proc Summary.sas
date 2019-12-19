* Proc Summary
	- Proc summary and Proc Means will prodcuce same results 
		under specific conditions 
	- Proc summary requires either of output statement or print statement
	- Proc Summary with either of print statement or output statement
		will produce only number of observations in outpur window / output dataset
	- Unlike proc means, proc summary cannot produce stats on numeric variables by default
		we should mention on what variables we should produce the stats
	- Proc summary with a "print/output" statement along with "analysis variables (var statement)"
		is equivalent to proc means 
		
; 

proc summary data=sashelp.cars; 
run;

* Above code throw you an error becasue output or print is missing; 

proc summary data=sashelp.cars print; 
run;

* Above code will execute successfully but prints only # of observations; 

proc summary data=sashelp.cars ;
output out=out_summary; 
run;

* Above code will execute successfully but dataset will get create only # of observations; 

proc summary data=sashelp.cars n mean max min std print; 
run;

* Above code throw you an error as no "analysis variables" are found 
  unlike proc means, proc summary cannot produce stats on numeric variables by default; 

proc summary data=sashelp.cars n mean max min std print; 
var invoice; 
run;

proc means data=sashelp.cars ; 
var invoice; 
run;




