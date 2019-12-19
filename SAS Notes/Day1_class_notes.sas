* 
1. Code    ---> Write your sas code 
2. Log     ---> Systematic log 
3. Results ---> Print (All procedures output navigates here)
4. Output  ---> table (sas understandable)

Two outputs: 
	1. Table as output 	
	2. printing them on default output system
	
* PC SAS ---> Tasks tab is not avaiable
;

data class; 
set sashelp.class;
run;

proc print data=sashelp.class;
run;

* SAS Program 
set of statements
	---> end with a semi colon (;)
	---> present in a single line or spread across multiple lines
	---> multiple statments can present in same line 

sas program is not a case sensitive	

.sas7bdat 	---> SAS Data set
.sas 		---> SAS Program

Catalog:
	Datasets 
	views
	formats 
	macros 

Steps:
	1. starts "data" and ends with "run" ----> data step
	2. starts "proc" and ends with "run" ----> proc step
	
	
If we write data or proc step in my program 
	--> It must have atleast one "run" statement 
	

;












































