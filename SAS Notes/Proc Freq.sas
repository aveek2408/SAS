* Proc Freq
	- By default it will create 4 characteristics on all the variables present in dataset
		1. Frequency (count for each distinct value in that varaible)
		2. percent (percentage of distinct frequency related to that variable value)
			percent = frequency / total number of observations
		3. cumulative frequency 
			sum of current observation frequency and previous observation frequncies
			cumulative frequency of last observation must be equal to number of observations ina dataset
		4. cumulative percent
			sum of current observation precentage and previous observation percentages
			cumulative percentage of last observation must be equal to 100%
;

proc freq data = sashelp.cars;
run;

proc freq data = sashelp.cars;
tables origin;
run;

proc freq data = sashelp.cars ;
tables origin type;
run;

proc freq data = sashelp.cars order=freq;
tables  origin type;
run;

proc freq data=sashelp.heart;
tables deathcause;
run;

proc freq data=sashelp.heart;
 tables deathcause /missing;
run; 

proc freq data = sashelp.cars order=freq;
 tables type /out=cars_freq outcum;
run;

proc freq data = sashelp.cars order=freq;
 tables type /out=cars_freq  nocum ;
run;

Proc freq data=sashelp.cars;
 Tables origin*drivetrain;
Run;

Proc freq data=sashelp.cars;
 Tables origin*drivetrain /nocol norow;
Run;

Proc freq data=sashelp.cars;
 Tables origin*drivetrain /list;
Run;

proc freq data = sashelp.cars ;
tables origin*make;
run;

proc freq data = sashelp.cars ;
tables origin*make /list;
run;
