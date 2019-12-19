* 
Module - 1
Reading data from external files
Input methods
Infile options
	dlm
	dsd
	flowover
	missover
	stopover
	truncover
Input options
	@@
	@
Modifiers
	Colon
	Ampersend
	Tilled 
Formats and Informats 
	Dollar
	Comma
	Date and Time 
	date9.
	mmddyy10.
Dataset Options
	drop
	keep
	rename
	where
	fistobs
	obs
	;

data temp;
retain state yop noofstudents;
infile datalines;
input 
@1	state			$	2.
@15	noofstudents		5.
@
;
*if cond then statement;
if state = "AP" then input @4 yop : ddmmyy10.;
else input @4 yop : date9.;
format yop date9.;

datalines;
AP 01/06/2015 50000
TN 01Jun2015  70000
AP 01/06/2016 40000
TN 01Jun2016  50000
run;


data temp_1;
infile datalines;
input 
@1	state			$	2.
@4 	yop				$   10. 
@15	noofstudents		5.
;

if index(yop,"/") then yop_1 = input(strip(yop),ddmmyy10.);
else yop_1 = input(strip(yop),date9.);

drop yop;

rename yop_1 = yop;

format yop_1 date9.;

datalines;
AP 01/06/2015 50000
TN 01Jun2015  70000
AP 01/06/2016 40000
TN 01Jun2016  50000
run;

* Dataset Options
	drop
	keep
	rename
	where
	fistobs
	obs
	;

data temp (drop=state rename=(noofstudents = nos));
infile datalines firstobs=2 obs=4;
input 
@1	state			$	2.
@15	noofstudents		5.
@
;
*if cond then statement;
if state = "AP" then input @4 yop : ddmmyy10.;
else input @4 yop : date9.;
format yop date9.;

datalines;
state yop nos
AP 01/06/2015 50000
TN 01Jun2015  70000
AP 01/06/2016 40000
TN 01Jun2016  50000
run;


data class ;
set sashelp.class (firstobs=5 obs=10);
run;





















