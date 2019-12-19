

/* Overview: IMPORT Procedure
PROC IMPORT reads data from an external data source and writes it to a SAS data set. 
Base SAS can import delimited files. 
In delimited files, a delimiter--such as a blank, comma, or tab--separates columns of data values. 	

Syntax:
PROC IMPORT 
DATAFILE="filename" | TABLE="tablename" 
OUT=<libref.>SAS data-set <(SAS data-set-options)> 
<DBMS=identifier><REPLACE> ;
<data-source-statement(s);>

DATAFILE="filename"
specifies the complete path and filename or fileref for the input PC file, spreadsheet, or delimited external file. 

OUT=<libref.>SAS-data-set
identifies the output SAS data set with either a one or two-level SAS name (library and member name).

DBMS=identifier
specifies the type of data to import. Valid identifiers for delimited files are CSV, DLM, JMP, and CSV. 

REPLACE
overwrites an existing SAS data set. If you do not specify the REPLACE option, 
the IMPORT procedure does not overwrite an existing data set.

GETNAMES
specifies whether the IMPORT procedure generate SAS variable names from the data values in the first record in the input file.

*/

* Importing a Delimited External File;

proc import datafile="C:\Users\Kamala\Desktop\export2.txt" 
			out=mydata   	
			dbms=dlm    
			replace;
delimiter='&';
 getnames=yes;
run;

* Importing a Specific Delimited File Using a Fileref;

Filename stdata "C:\Users\Kamala\Desktop\export2.txt" lrecl=100;

proc import datafile=stdata
     out=stateinfo
     dbms=dlm
     replace;
     getnames=yes;
run;

* Importing a Tab-Delimited File;

proc import datafile='C:\Users\Kamala\Desktop\class.txt'
     out=class
     dbms=dlm
     replace;
     delimiter='09'x;
	 datarow=5;
   run;

* Importing a Comma-Delimited File with a CSV Extension;

   proc import datafile="C:\Users\Kamala\Desktop\class.csv"
     out=shoes
     dbms=csv
     replace;
     getnames=no;
run;

/* 	 Overview: Export Procedure

PROC EXPORT 
DATA=<libref.>SAS data-set <(SAS data-set-options)> 
OUTFILE="filename" | OUTTABLE="tablename" 
<DBMS=identifier> <LABEL><REPLACE>;
*/

* Exporting a delimited file;
data class;
set sashelp.class;
run;

proc export data=class
   outfile='C:\Users\Kamala\Desktop\export2.txt'
   dbms=dlm; 
    delimiter='&';
  run;

  proc export data=class
   outfile='C:\Users\Kamala\Desktop\exporttab.txt'
   dbms=dlm
  replace; 
    delimiter='09x';
  run;

  proc export data=class
   outfile='C:\Users\Kamala\Desktop\class.csv'
   dbms=csv
   replace;
run;

********PROC TRANSPOSE**********;

****************************************************;
* Create file1 input file;
****************************************************;
data work.narrow_file1;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Black bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;
****************************************************;
* Create file2 input file;
****************************************************;
data work.narrow_file2;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Black cat 1
Mrs. Brown dog 1
Mrs. Brown cat 0
Mrs. Green fish 5
Mr. White fish 7
Mr. White dog 1
Mr. White cat 3
;
run;
****************************************************;
* Create file3 input file;
****************************************************;
data work.wide_file3;
infile cards missover;
length pet_owner $10 cat 4 dog 4 fish 4 bird 4;
input pet_owner $1-10 cat dog fish bird;
cards;
Mr. Black 1 2 . 0
Mrs. Brown 0 1 0 1
Mrs. Green . 0 5
Mr. White 3 1 7 2
;
run;

* Simple Transpose;
proc transpose data=narrow_file1
out=narrow_file1_transp_default;
run;

* Prefix option;
proc transpose data=work.narrow_file1
out=work.narrow_file1_transp_prefix
prefix=pet_count;
run;
*NAME option ;
proc transpose data=work.narrow_file1
out=work.narrow_file1_transp_prefix_name
name=column_that_was_transposed
prefix=pet_count;
run;

* ID statement
ID statement names the column in the input file whose row values provide the column names in the output file.
There should only be one variable in an ID statement. Also, the column used for the ID statement cannot have
any duplicate values.;
proc transpose data=work.narrow_file1
out=work.narrow_file1_transp_id
name=column_that_was_transposed;
id pet;
run;

proc transpose data=work.narrow_file1
out=work.narrow_file1_transp_var;
var pet population;
run;

proc transpose data=work.narrow_file1
out=work.narrow_file1_transp_id_var
name=column_that_was_transposed;
var pet population;
id pet;
run;

************************** MEANS PROCEDURE	****************************************;

* Syntax for Means Procedure;
proc means data = libref.inputdataset maxdec=2  Nonobs Missing NWAY
							Std Median Sum N Min Max Var Std Stderr;
	where condition;
	var anavar1 anavar2 anavar3;
	class var1 var2 var3;
	by Grpvar1 ;
	output out = libref.outputdatset
		N = anavar1_N
		Mean = anavar1_Mean
		Std = anavar1_Std
		Max = anavar1_Max
		Min = anavar1_Min ;
	format varname fmtname.;
	
* Default Means Procedure - generates on all the obs and on all the numeric
  variables grouped and summarized ;
proc means data = airline.crew;
run;

* VAR Statement restricts and specifies the analysis variables(numeric vars)
  on which to generate descriptive statistics ;
* CLASS statement groups the data on the variable/s specified and summarizes
  on the numeric variable/s;
	*** CLASS Statement accepts both numeric and character data type variables;	
** NOBS - When class statement is specified it prints NOBS on output report.
   NOBS - prints total number of obs with both missing and non missing values on 
         anavars
   N - prints total num of obs with non missing values on anavars;
* NONOBS - does not print nobs on output report ; 
* MAXDEC= value , print the number of digits specified onto output report;   

proc means data = airline.crew nonobs maxdec=1;
	var salary;
	class location jobcode;
run;

* Override default stats by specifying the user requirement stats on 
  proc means ;
proc means data = airline.crew Sum Stderr Var Median;
	var salary;
	class jobcode;
run;

* BY statement divides the report into multiple sections for each unique value
  and pre-req is to sort the data;
proc sort data = airline.crew out = crewsort;
	by location;
run;

proc means data = crewsort ;
	var salary;
	class jobcode;
	by location;
run;

* Storing the means results onto output dataset;
proc means data = airline.crew ;
	var salary;
	class location jobcode;
	output out = work.crewmeans;
run;

* Convert variable values(stats) into variables in output dataset;
proc means data = airline.crew  noprint;
	var salary;
	class location jobcode;
	output out = work.crewmeans
		N = Sal_N
		Mean = Sal_Mean
		Std = Sal_Std
		Min = Sal_Min
		Max = Sal_max ;
run;
*********************************************************************
_TYPE_ represent the number of combinations in which the data is 
  summarized and stored into output datset based on CLASS STATEMENT  
  VARIABLES 

_FREQ_ displays the total number of obs with missing and non missing
considered for calculating descriptive stats
*********************************************************************
_Type_      Combination
---------------------------------------------------------------------
0           Across all the obs
1           Jobcode
2           Location
3           Location Jobcode         (NWAY as per class statement vars)
*********************************************************************;


* NOPRINT option does not print the report onto output window;
* by default stores into output dataset each and every combination,
  to store only the default combination specified in class statement then
  use NWAY option on proc means ;

proc means data = airline.crew  noprint nway;
	var salary;
	class location jobcode;
	output out = work.crewmeans
		N = Sal_N
		Mean = Sal_Mean
		Std = Sal_Std
		Min = Sal_Min
		Max = Sal_max ;
run;

*************************************************************************
				Difference between N and NOBS example
					Missing option in proc means
*************************************************************************;
data  work.dfwlax;
	set airline.dfwlax;
	if destination = 'dfw' then destination = ' ';
	else if destination = 'LaX' then destination = ' ';
run;

* Firstclass geneates on 9 non missing values;
proc means data = work.dfwlax;
	var firstclass;
run;

* does not generates for missing values in class staement variable i.e. 
  destination;
proc means data = work.dfwlax;
	var firstclass;
	class destination;
run;

* MISSING option on PROC MEANS prints the descriptive stats for the 
  classification variable consists of missing values ;
proc means data = work.dfwlax missing ;
	var firstclass;
	class destination;
run;


/*-----------------------------------------------------------------------
							PROC SUMMARY
- proc means generates by default results onto output window
	(porc means with noprint option is same as proc summary)
- proc summary only creates output dtaset that store the results
-----------------------------------------------------------------------
**********************************************************************/
proc summary data = airline.crew nway;
	var salary;
	class location jobcode;
	output out = work.crewsumm
		N = Sal_N
		Mean = Sal_Mean
		Std = Sal_Std
		Min = Sal_Min
		Max = Sal_max ;
run;
