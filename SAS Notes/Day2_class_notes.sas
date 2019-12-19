* Library 
	- Types of libraries  
	- Create , assign & deassign 
	
  Dataset (.sas7bdat) 
  	- Naming conventions to follow for ds name 
  		- 32 char length 
  		- no special character except "_"
  		- numbers are allowed but no ds name should start with a number 
  		- ds name should start with either of an alphabet or "_"
  		
  	- varaibles and types 
  		- numeric 
  			- accept only numbers 0123456789, decimal point & minus symbol (-)
  			- missing value  : failed/missed to enter data or non standard data 
  			- numeric missing vaule is represented as . (period)
  			- 8 bytes (default & maximum) : 3 - 8
  			
  		- character 
  			- everything (alphabates, special characters & numbers)
			- missing value : Failed to enter 
			- character missing value is representes as "blank space"
			- 8 bytes (default) : 1 - 32767
			
	Library
	Physical location in your server or in PC - which is accessible from SAS
		- name of the library is called as libref
			- 8 char length
		- temp (default - system defined - WORK)
			- physical path will be created by SAS and when we close SAS it will 
				delete the physical location
		- perm (system defined & user defined)
  	
  	Dataset naming: 
  		- one level (ds_name)
  		- two level (libref.ds_name)
;

proc contents data=sashelp.class; 
run;


data new_class;
set sashelp.class;
run;

data WORK.new_class;
set sashelp.class;
run;

/*
 NOTE: There were 19 observations read from the data set SASHELP.CLASS.
 NOTE: The data set WORK.NEW_CLASS has 19 observations and 5 variables.
*/

data class_1;
set class_2;
run;

data class_1;
set new_class;
run;

* Create a library
	- libname libref path;
libname test "/folders/myfolders/EdueMasters/datasets";

data test.class_1;
set sashelp.class;
run;

data class_1;
set sashelp.class;
run;


* How to bring or invoke user defined libraries during sas start up?;














