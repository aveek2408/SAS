
* SAS Rules;

/*
Comments block:
1. anything between * and ; can be considered as a comment 
2. How to create a SAS dataset


Programming rules:
1. Each statement in SAS must end with semicolon (;)
2. Each program should have atleast one "run" statement 
3. Not a case sensitive
4. data step/ proc step/ macro ---> Combination
	data --- run
	proc --- run
	
Dataset Naming rules: 
1. Not beyong 32 char length 
2. Name should not contain any special characters except "_"
3. one-level naming ---> dsname			---> work.dsname
   two-level naming	---> libref.dsname
   
   
libref rules:
	1. should not start with a number 
	2. should not exceed 8 char length 
	3. should not contain any special characters except "_"
*/


* How to create a SAS dataset
1. From SAS Dataset (sas7bdat)				---> simple
2. From a file (csv, txt, dat, ....)		---> Moderate 
3. From a database (oracle, teradata, db2)	---> Complex (proc sql)
4. Manually create by referring something 	---> Simple
;

* How to create a dataset manually ; 
data student;
	infile datalines;
	input 
		Student_id	$
		age	
		gender		$	
		height	
		weight
	;
datalines;
101 12 M 123 45
102 13 F 125 40
103 11 F 130 46
;
run;

proc print data=student;
run;

proc contents data=student;
run;

* How to create a dataset from a dataset; 
data master.class;
set sashelp.class;
where sex="F";
run;
