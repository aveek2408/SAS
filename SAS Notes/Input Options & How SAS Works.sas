* Input options 
	- @@ (Double trailing)
		Multiple records present in the same line 
	- @  (Single trailing)
		To read data conditionally from the input file
;

data student;				 * ---> create a dataset ;
infile datalines dlm=",";	 * ---> what is inout file is and exits or not? ;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;							 * ---> what are the variables to present in output dataset;
datalines;
101,ABC,F,23,167,76,102,DEF,M,25,176,87
;							 * ---> End of File; 
run;

* record by record 
input picks one record
101,ABC,F,23,167,76,102,DEF,M,25,176,87
entire program 
create an output record
till eof 
;

data student;				 * ---> create a dataset ;
infile datalines dlm="," ;	 * ---> what is inout file is and exits or not? ;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
@@
;							 * ---> what are the variables to present in output dataset;
datalines;
101,ABC,F,23,167,76,102,DEF,M,25,176,87
103,GHI,M,25,176,87
;							 * ---> End of File; 
run;

proc print data=student; 
run;
* Single trailing ;

* How SAS Works
1. Submit sas program ---> check for syntax errors
		- Yes : stop the exectuion and throw an error
		- No  : proceed to the execution 
2. Input Buffer (RAM)
	- Logical space (or) Logical memory 
	- Tokenization
	- selecting the processors 
3. Program Data Vector (PDV)
	- Logical space (or) Logical memory 
	- where sas buids your dataset 
	- where execution occurs 
;


data student;
length std_id $3. gender $1.;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;




































