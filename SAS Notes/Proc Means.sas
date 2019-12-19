/*	- Proc Means 
	- Proc Summary
	- Proc Freq
	- Proc Corr
	- Proc Report 
	- Proc Tabulate 
*/

/* 
The MEANS procedure starts with the keywords PROC MEANS, followed by
options:

PROC MEANS options;

1. The MEANS procedure provides simple statistics for numeric variables.
If you do not specify any summary statistics, SAS will print 
	- the number of non-missing values
	- the mean
	- the standard deviation
	- the minimum and
	- maximum values for each variable. 
2. If you use the PROC MEANS statement with no other statements, then you will get statistics 
	for all numeric variables in your data set.

3. BY variable-list:
	The BY statement performs separate analyses for each level of the variables in the list. 
	The data must first be sorted by these variables. (You can use PROC SORT to do this.)

4. CLASS variable-list:
	The CLASS statement also performs separate analyses for each level of the variables in the 
	list, but its output is more compact than with the BY statement, and the data do not have 
	to be sorted first.

5. VAR variable-list:
	The VAR statement specifies which numeric variables to use in the analysis. 
	If it is absent, then SAS uses all numeric variables.

Input data:
756-01 05/04/2013 120 80  110
834-01 05/12/2013 90  160 60
901-02 05/18/2013 50  100 75
834-01 06/01/2013 80  60  100
756-01 06/11/2013 100 160 75
901-02 06/19/2013 60  60  60
756-01 06/25/2013 85  110 100

*/

proc means data=sashelp.cars;
run;

proc means data=sashelp.cars maxdec=0;
run;

proc means data=sashelp.cars maxdec=0;
var msrp;
run;

proc means data=sashelp.cars maxdec=0;
var msrp invoice;
run;

proc means data=sashelp.cars maxdec=0;
var msrp invoice;
class make;
run;

proc means data=sashelp.cars maxdec=0;
var msrp invoice;
class make type;
run;

proc means data=sashelp.cars ;
class make / order=freq;
var msrp invoice;
run;

proc means data=sashelp.cars ;
class make / descending;
var msrp invoice;
run;

proc means data=sashelp.cars ;
class make;
var msrp invoice;
where make in ("BMW","Audi");
run;

proc means data=sashelp.cars ;
var invoice;
output out=outstat;
run;

proc means data=sashelp.cars noprint;
var invoice;
output out=outstat;
run;

proc means data=sashelp.cars noprint;
var invoice;
output out = outstat mean = mean1;
run;

proc means data=sashelp.cars noprint;
var invoice;
output out = outstat mean= std= / autoname;
run;

proc means data=sashelp.cars noprint;
var msrp;
class origin;
output out=outstat mean= std= /autoname;
run;

proc means data=sashelp.cars noprint;
var msrp;
class origin drivetrain;
output out=outstat mean= std= /autoname;
run;

proc means data=sashelp.cars noprint nway;
var msrp;
class origin drivetrain;
output out=outstat mean= std= /autoname;
run;
