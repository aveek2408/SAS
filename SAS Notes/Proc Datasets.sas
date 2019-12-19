/*	- proc datasets 
	- proc copy 
	- proc delete
	- Proc Corr
	- Proc Report 
	- Proc Tabulate 
	- Proc printto 	
*/

* 1. View Contents of a SAS Library;
data class; 
set sashelp.class; 
run;

* View only datasets;
proc datasets lib=work memtype=data;
 run;
quit;

* view complete list of contents for each of the dataset;
proc datasets lib=work memtype=data;
 contents data=class;
run;
quit;

**************************************************;

* 2. MODIFYING ATTRIBUTES OF SAS VARIABLES;
data class;
set sashelp.class;
format weight comma4.2;

label age = "Age of the Person"
 height = "Height of the Person"
 ;
rename sex = gender;
run;

data class;
set sashelp.class;
run;

proc datasets library=work;
modify class;
format weight comma4.2;

label age = "Age of the Person"
 height = "Height of the Person"
 ;
rename sex = gender;
run;
quit;

***********************************************;
* 3. Concatenating SAS Data Sets with the APPEND Statement;

data boys; 
set sashelp.class; 
where sex = "M";
run;
data girls; 
set sashelp.class; 
where sex = "F";
run;

proc datasets library=work;
append base=boys
data=girls;
quit;

***************************************************;
* 4. Renaming SAS Files with the CHANGE Statement;
proc datasets library=work nolist;
change girls = grils_class boys = hello_boys;
run;
quit;

*****************************************************;
* 5. Copy datastes from one location to other location;

libname lib "D:\SASUniversityEdition\myfolders\EdueMasters\datasets";

proc datasets library=work nolist;
copy out=lib;
select cars_freq;
run;
quit;

****************************************************;
* 6. Permanently Removing Files with the DELETE Statement;
proc datasets library=work nolist;
delete class ;
run;
quit;

********************************************************;
* 7. Swapping File Names with the EXCHANGE Statement;
proc datasets library=work nolist;
exchange grils_class = hello_boys
 ;
run;
quit;



