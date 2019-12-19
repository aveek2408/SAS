*********************************************************************
					STEPS FOR WRITING THE SAS PROGRAM
								SAS TASKS
---------------------------------------------------------------------
- Data Access - create a library(folder) to accees input data from
  physical location (c:\prog1) (LIBNAME statement)

- Data Transformation - Transform input data table into output data
  table as per user rquirement (DATA Step statement)

- Data Analysis and Presentation - Generate report onto output window
  using PROC Step Statement in various outputs (output window / excel/
  pdf / html)
********************************************************************/

* Data Access ;
* Syntax for Creating a library(folder);
Libname librefname 'Physical Location of Sas Datasets';  

Libname airline 'C:\Prog1';
libname clinical 'C:\ClinicalData';

* Data Transformation;
* Syntax for Creating Data step statement ;
* Notes/Comments ;
Data libref.outputdataset ; 
	set libref.inputdataset ; 
	**** Transformation **** ;
run ;

* From input airline.empdata create a new variable bonus which is 10%
  of salary on output dataset work.empbonus;
Data work.empbonus;	
	set airline.empdata; 
	Bonus = .10*salary; 
run;

* Create a new variable bodymassindex on output dataset from input
  dataset clinical.demographics;
data work.demobmi;
	set clinical.demographics;
	BodyMassIndex = Weight/((Height/100)**2);
run;


/********************************** How SAS works, input buffer, PDV *********************************************
When you submit a DATA step for execution, SAS checks the syntax of the SAS statements and compiles them, that is, 
automatically translates the statements into machine code. SAS further processes the code, and creates the following three items: 

Input buffer is a logical area in memory into which SAS reads each record of data from a raw data file when the program executes. 
(When SAS reads from a SAS data set, however, the data is written directly to the program data vector.)
 
Program data vector is a logical area of memory where SAS builds a data set, one observation at a time. 
When a program executes, SAS reads data values from the input buffer or creates them by executing SAS language statements. 
SAS assigns the values to the appropriate variables in the program data vector. From here, SAS writes the values to a SAS data set 
as a single observation.

The program data vector also contains two automatic variables, _N_ and _ERROR_. 
The _N_ variable counts the number of times the DATA step begins to iterate. 
The _ERROR_ variable signals the occurrence of an error caused by the data during execution. These automatic variables are not written to the output data set.*/
 
data work.accts;
	length actid $4 custname $25 acttype $25;
	infile datalines;
	input actid $ custname $ acttype $ branch amount;
datalines;
1001 Ram Hyderabad 5026 25000
1002 Rajnikanth Secunerabad 5255 40000
;
run;


/***************************************************************
			Reading Data From Raw Data Files and
					Creating Sas Dataset
---------------------------------------------------------------
INFILE statement defines the physical locaiton of raw data file
INPUT Statement defines the variable and its data type to be
   created on output datsaet
LENGTH statement defines the lengths for the variable
---------------------------------------------------------------
TYPES OF LIST INPUT STYLES:

LIST INPUT 
The input style simply lists variables separated with a blank. This style is also called the free format. 
A character variable should be followed by $. A missing value should be marked with a period (.); a blank does not mean a missing value in this input style. 
Do not use more than one "." for a missing value. The maximum length of a string variable is 8 characters (standard); that is, fixed 8bytes of memory are assigned to each variable. 
Therefore, a string longer than 8 characters will be trimmed. 
If you want to read a string longer than 8 characters, use LENGTH, INFORMAT  statements. */

***************************************************************;
* Reading data from sas dataset;
data  libref.outputdataset;
	set libref.inputdataset;
	* Transformations;
run;

* Syntax for Reading data from raw data file(Txt File,.dat,csv);
data libref.outputdataset;
	length Var1 $4 Var2 $25 Var3 $25;
	infile 'Physical Location of Raw Data File' <Options>;
	input Var1 $ Var2 $ Var3 $ Var4 Var5   <Options>;
run; 
	
data work.accts;
	length actid $4 custname $25 acttype $25; 
	infile 'F:\1.Base Sas Batches\58.7.30am24Jun2013\bank.txt';
	input actid $ custname $ acttype $ Amount  ;
run;

****************** ***********************************************
						DATALINES STATEMENT
-----------------------------------------------------------------
- Reads data values from sas program itself
- INFILE statement specify datalines in place of physical location
- CARDS/CARDS4 statement
*****************************************************************;
data work.accts;
	length actid $4 custname $25 acttype $25; 
	infile datalines;
	input actid $ custname $ acttype $ Amount  ;
datalines;
1001 Ram Savings 1000
1002 Laxman Savings 2500
;
run;

*****************************************************************
				DLM Option on INFILE Statement
-----------------------------------------------------------------
- BLANK SPACE is the default delimiter by which the data values are
  separated and read into new variable
- if the values are separated by any other spl character then 
  use DLM option in infile statement which overrides the default
  delimiter
*****************************************************************;
* Single Delimiter;
data work.accts;
	length actid $4 custname $25 acttype $25;
	infile datalines dlm=',';
	input actid $ custname $ acttype $ branch amount;
datalines;
1001, Ram, Hyderabad, 5026, 25000
1002, Rajnikanth, Secunerabad, 5255, 40000
;
run;

* Multiple Delimiters;
data work.accts;
	length actid $4 custname $25 acttype $25;
	infile datalines delimiter=',@' ;
	input actid $ custname $ acttype $ branch amount ;
datalines;
1001, Ram, Hyderabad@ 5026, 25000
1002, Rajnikanth, Secunerabad@ 5255, 40000
;
run;

*****************************************************************************
					DSD Option on INFILE Statement
			When MISSING values in BETWEEN the RECORD	
DSD - delimited specified data 
-----------------------------------------------------------------------------
when missing values in between the record separated by consecutive 
delimiters, by default sas reads subsequent value into current variable
and stops execution

speciyf DSD option on INFILE statement, if consecutive delimiters then
replaces with missing value withour reading subsequent value into 
current variable

The default delimiter is COMMA for DSD option, if separated by any other
delimiter then specify DLM option
*****************************************************************************;

/*###################################################################
Examine the raw data file steps:
	- How many obs and variables
	- Create strucuture for the variables(varname/datatype/length/
      format/informat)
	- Delimiter by which the data values are separated
	- Missing values in between or at the end of the record 
###################################################################*/
data work.demographics;
	length subjid $4 subname $25;
	infile datalines dlm=',' dsd;
	input subjid $ subname $ bmi weight height;
datalines;
1001, Ramesh, 23.33, 78, 166
1002, Ranjeeth, 28.52,,164
1003,,24.52,80,160
;
run;

*****************************************************************************
					Reading Multiple Observations Per Record
					  DOUBLE TRAILING @@ on INPUT statement
-----------------------------------------------------------------------------
when multiple observations per record by default the pointer moves to the
next record without reading addl observations from the same record,
use double trailing (@@) to reads subsequent obs from same records without
moving the pointer to the next record
*****************************************************************************;
data work.accts;
	length actid $4 custname $25 acttype $25; 
	infile 	datalines ;
	input  actid $ custname $ acttype $ amount @@;
datalines;
1001 Ram Savings 1000 1002 Laxman Savings 2500
1003 Rajeshwar Savings 1500 1004 Madhu Savings 5000
;
run;

/*************************************missover, flowover, truncover, stopover********************
FLOWOVER -The default. Causes the INPUT statement to jump to the next record if it doesn’t find values for all variables.
MISSOVER - Sets all empty vars to missing when reading a short line. 
STOPOVER - Stops the DATA step when it reads a short line. 
TRUNCOVER - Forces the INPUT statement to stop reading when it gets to the end of a short line. This option will not skip information. */

data num;
length numb 5.;
infile "C:\Users\muralikrishnaee\Desktop\numbers.txt";
input numb 5.;
run;
*****************************************************************************
				When Missing Values at the end of the record
-----------------------------------------------------------------------------
FLOWOVER Option by default reads subsequent value into current variable 
and stops the execution(default behaviour)

MISSOVER Option reaplces with missing value without reading subsequent
value into current variable and executes

STOPOVER option is an audit check to find if they are any missing values 
at the end of the record, if exists then generates an error onto log window
and stops the execution
*****************************************************************************;
data  work.studdata;
	length studid $4 doe $9;
	infile datalines dlm=',' missover;
	input studid $ doe $ maths science social;
Datalines;
1001, 01Jan1979, 100, 95
1002, 06Jun1978, 45, 55, 75
1003, 05May1981, 36, 65
;
run;

*****************************************************************************
					Reading Multiple Records Per Observation
*****************************************************************************;
* Method1 - multiple input statements;
data work.custdata;
	length fname $10 lname $10 city $10 state $2;
	infile datalines dlm= ',';
	input Fname $ Lname $;
	input City $ State $;
	input telno;
datalines;
Ram, Pabba
Hyderabad, AP
9246331678
Santosh, Tiwari
Worli, MP
9849209934
;
run;

* Method2 - Absolute line pointer control 
  (#n - where n represents the record number, changes the order of reading
   variables into output dataset;
data work.custdata;
	infile datalines dlm=',' ;
	input #2 City $ State $
          #3 Telno
          #1 FName $ Lname $;
datalines;
Ram, Pabba
Hyderabad, AP
9246331678
Santosh, Tiwari
Worli, MP
9849209934
;
run;

*****************************************************************************\
INFORMAT - converting non standard into standard value
FORMAT - presentation/display/appearance of the value

* Syntax:
Informat varname infmtname. 

while reading the data from raw data file into sas dataset convert non 
standard values to standard by using informats
****************************************************************************;
* When reading data from raw data file use INFORMAT Statement,
  but if the variable on the input dataest already exists with non standard
  value then use input or put function;
data work.studdata;
	length studid $4;
	infile datalines dlm=',';
	input studid $ doe maths science social ;
	informat doe date9. ;
	* format doe mmddyy10.;
datalines;
1001, 01Jan1960, 100, 95, 85
1002, 31Dec1959, 45, 55, 75
1003, 31Dec1960, 36, 65, 75
1004, 17Jun2013, 36, 65, 75
;
run;

*****************************************************************************
								COLON MODIFIER (usage 1)
----------------------------------------------------------------------------
- when length statement is specified for few variables only then the order of
  the variables will change in output dataset

- COLON modifier is used to created the length on INPUT statement variable,
  which does not change the order of the variables in output dataset
*****************************************************************************;
data  work.accts;
	* length transtype $15;
	infile datalines dlm = ',';
	input actid $ custname $ transtype: $15. amount;
datalines;
1234, Karan, AtmDeposit, 2500
2556, Manikanta, BankWthdrawl, 5000
4587, Rajesh, AtdWthdrawl, 4500
;
run;

*****************************************************************************
								COLON MODIFIER (usage 2)
----------------------------------------------------------------------------
- convert non standard data into standard data using COLON MODIFIER on input
  statement variable by specifying the INFORMAT
*****************************************************************************;
data work.studdata;
	length studid $4;
	infile datalines dlm=',';
	input studid $ doe: date9. maths science social ;
	format doe worddate12. ;
datalines;
1001, 01Jan1960, 100, 95, 85
1002, 31Dec1959, 45, 55, 75
1003, 31Dec1960, 36, 65, 75
1004, 30Jul2013, 36, 65, 75
;
run;

*****************************************************************************
					SINGLE TRAILING (@) ON INPUT STATEMENT
- When reading data conditionally use SINGLE TRAILING on input statement 
  to hold the value in memory until it reads all the variable values
*****************************************************************************;
data salesdata;
	infile  datalines;
	input saleid: $4. state: $2. @;
	if state = 'AP' then 
		input saledate: mmddyy10. saleamt ; 
	else if state = 'MP' then
		input saledate: date9. saleamt:commax7.2;
	format saledate date9. saleamt dollar14.2;
datalines;
100 AP 1-24-2000 2345.60
2342 MP 12JAN1995 1345,30
234 AP 2-21-1999 6567.75
7656 MP 23MAR1997 2387,80
;
run;

/*MODIFIED LIST INPUT 
The modified list style is a mixture of the list input and the formatted input. 
This style can deal with ill-structured data. There are three format modifiers to be used especially when reading complex data. 

•colon (:) reads data longer than standard 8 characters or numbers until encountering specified delimiter or reaching the variable 
width specified.
•ampersand (&) format modifier reads character values that contain embedded blanks with list input and reads until 
encountering more than one consecutive delimiter. You may include " (double quotes) in the value of a character variable.
•tilde (~) reads and retains single quotation marks, double quotation marks, and delimiters within quoted character values. 
That is, double quotation marks enclosing a string are treated as values of a character variable.*/

DATA modified;
INFILE DATALINES DELIMITER=',' DSD;
INPUT name : $8. title & $50.;

DATALINES;
Lindblom80,"Still Muddling, Not Yet Through"
Park, "Reading ""Small Is Beautiful"""
Simon, """It was a disaster,"" he continue..."
RUN;

/* Output 
Lindblom Still Muddling, Not Yet Through
Park     Reading "Small Is Beautiful"
Simon    "It was a disaster," he continue...
*/ 

DATA modified;
INFILE DATALINES DELIMITER=',' DSD;
INPUT name : $20. year : 4.0 title ~ $50.;

DATALINES;
Meyer and Rowan,1977,"Institutionalized Organization"
Lindblom,1979,"Still Muddling, Not Yet Through"
RUN;

/* Output
Meyer and Rowan 1977 "Institutionalized Organization"
Lindblom        1979 "Still Muddling, Not Yet Through"
*/

/* Output without DSD
Meyer and Rowan 1977 "Institutionalized Organization"
Lindblom 1979 "Still Muddling
*/ 

/*COLUMN INPUT 
The column input style reads the value of a variable from its specified column location. 
A variable name is followed by its starting and ending columns. 

NAMED INPUT 
The named input reads a data value that follows its variable name. 
A variable name and its data value are separated by an equal sign. String data are NOT enclosed by double quotation marks in this style. Like the list style, the named style supports standard length of variables only. 
The format provides some sorts of flexibility, but it will not be appropriate for a large data set.  */

DATA named;
INPUT name=$ id= grade=;

DATALINES;
name=Park id=8740031 grade=89
name=Hwang id=9301020 grade=100
...
RUN;

/*****************************************************************************
- FORMATTED INPUT STYLE - converting non standard into standard value
           by positioning the pointer
	- can be used with both list input and column input style
	* Relative column Pointer Control (+n - where n represents the number  
              of positions to move)
	* Absoulte Column Pointer Control (@n - counts the position numbers
               from the beginning) 

*****************************************************************************/
* relative column pointer control;
data work.relptrctrl;
	infile datalines;
	input prodname $10. +7  servamt comma6. ;
datalines;
trucks           1,256
vans             2,248
cars             4,250
;
run;

* absolute column pointer control;
data work.abscolptr;
	infile datalines;
	input prodname $10. @21 servamt comma6. ;

datalines;
trucks          125  1,256
vans            456  2,248
cars            256  4,250
;
run;

*Format and Informat:

	Various Informats - Char Informat
						Numeric Informat
						Date Informat

	Various Formats
	Input and Put Staements
	Input and Put Functions;

*****************************************************************************\
INFORMAT - converting non standard into standard value
FORMAT - presentation/display/appearance of the value

* Syntax:
Informat varname infmtname. 

while reading the data from raw data file into sas dataset convert non 
standard values to standard by using informats
****************************************************************************;
* When reading data from raw data file use INFORMAT Statement,
  but if the variable on the input dataest already exists with non standard
  value then use input or put function;
data work.studdata;
	length studid $4;
	infile datalines dlm=',';
	input studid $ doe maths science social ;
	informat doe date9. ;
	* format doe mmddyy10.;
datalines;
1001, 01Jan1960, 100, 95, 85
1002, 31Dec1959, 45, 55, 75
1003, 31Dec1960, 36, 65, 75
1004, 17Jun2013, 36, 65, 75
;
run;

/* ID 		Transaction Date 		Transaction Amount 
124325 	08/10/2003 				1250.03 
 7 		08/11/2003 				12500.02 
114565 	08/11/2003 				5.11 						*/

data new;
infile "C:\Users\india143\Desktop\informat1.txt";
input @1 ID $6.
	  @9 TD mmddyy10.
	  @21 TA comma8.2;
run;

proc print data =new;
format TD mmddyy10. TA dollar10.2;
run;

data new;
infile "C:\Users\india143\Desktop\informat2.txt";
input @1 ID char6.
	  @9 TD mmddyy10.
	  @21 TA comma8.2;
run;


*Types of Data Type Conversion Functions:
-----------------------------------------------------------------------
* INPUT Function - converts character to numeric data type
	Nvar = Input(Cvar,Informat);

* PUT Function - converts numeric to character data type
	Cvar = Put(Nvar,informat);

* Examples on Input Function ;
data InputFunc;
	Cvar1 = '52000';
	Nvar1 = Input(Cvar1,5.);

	Cvar2 = '52,000';
	Nvar2 = Input(Cvar2,comma10.);

	Cvar3 = '01Jan1960';
	Nvar3 = Input(Cvar3,date9.);

	Cvar4 = '$125.25';
	Nvar4 = Input(Cvar4,dollar7.2);
run;

data  work.salary1;
	set airline.salary1;
	Bonus = .10*input(grosspay,5.);
run;

data  work.salary2;
	set airline.salary2;
	Bonus = .10*input(grosspay,comma6.);
run;

* Examples on PUT Function;
data PutFunc;
	Nvar1 = 52000;
	Cvar1 = Put(Nvar1,5.);
	Cvar4 = Put(Nvar1,comma6.);	

	Nvar2 = 0 ;
	Cvar2 = Put(Nvar2,date9.);
	Cvar3 = Put(Nvar2,mmddyy10.);
run;

* from airline.born
  create a new variable born1 with sas date value,
                        bornyear with numeric year vlaue
                        age in years ;
data born;
	set airline.born;
	born1 = input(date, date7.);
	bornyear = year(born1);
	age = intck('years',born1,today());
run;

* Examples on date time / currency formats / functions ;
data  work.daysales;
	set airline.daysales;
	saledate1 = Put(saledate,date9.);
	saledate2 = input(saledate1,date9.);
	format saledate date9. saleamt dollar14.4;
run;

data _null_;
set new;
file "C:\Users\india143\Desktop\informat3.txt";
ID =input(ID, 6.);
put @1 ID 6.
    @9 TD ddmmyy10.
	@21 TA dollar8.2;
run;


/******************************Proc Stdize*********************************/
data miss;
infile cards missover;
input a b c $ d $ e $ f;
cards;
1 . a b c 4 
. 3 c r f 2
2 4 e r d .
3 . w x t 7
;
run;


proc stdize data=miss reponly missing=0 out=new;
var _numeric_;
run;	

/*								FORMAT
Format is PRESENTATION / DISPLAY / APPEARANCE OF A VALUE IN THE VARIABLE
in sas dataset

The actual data storage type will be same but the display of the value 
will be CHARACTER data type
------------------------------------------------------------------------
Types of Formats:
- User Defined Formats: is created by sas programmer by using a procedure
  PROC FORMAT

- System Defined Fomats: that are in-built with the sas system itself
----------------------------------------------------------------------- */

data  studdata;
	infile datalines dlm=',';
	input Group: $1. Ctrnumber Subject: $10. Marks;
datalines;
A, 1, 101, 34
A, 1, 102, 75
B, 2, 101, 80
B, 2, 102, 55
C, 3, 101, 75
C, 3, 102, 98
;
run;

/*********************************************************************
	Applying the FORMATS on the VARIABLE/S using FORMAT STATEMENT
----------------------------------------------------------------------
- The formats can be applied on both data and proc steps

Format Charvarname $charfmtname. Numvarname numfmtname. ;
**********************************************************************/
* when format is specified in proc step it only displays the formatted
  values in output report only ;
proc print data = work.studdata;
	var group ctrnumber subject marks;
	format group $grps. ctrnumber ctrnums. subject $subs. marks mrks.;
run; 

* when format statement is specified in data step it stores the formats
  permanently on the output dataset;
data  work.studdata1;
	set work.studdata;
	format group $grps. ctrnumber ctrnums. subject $subs. marks mrks.;
run;

* Printing permanent formats of work.studdata1;
proc print data = work.studdata1;
run;

***********************************************************************
					DATA TYPE CONVERSION FUNCTION
- Converts the EXISTING VARIABLE value from char to numeric or numeric
  to character by specifying informats
- Implcit Conversion - The sas system automatically converts the data
  type of the variable based on the transformtion and generates a NOTE
  to the log window
- Explicit Conversion - the sas programmer converts by defining an
  INPUT or PUT Function on the sas program before the sas system converts

Types of Data Type Conversion Functions:
-----------------------------------------------------------------------
* INPUT Function - converts character to numeric data type
	Nvar = Input(Cvar,Informat);

* PUT Function - converts numeric to character data type
	Cvar = Put(Nvar,informat);

*/
* Examples on Input Function ;
data InputFunc;
	Cvar1 = '52000';
	Nvar1 = Input(Cvar1,5.);

	Cvar2 = '52,000';
	Nvar2 = Input(Cvar2,comma10.);

	Cvar3 = '01Jan1960';
	Nvar3 = Input(Cvar3,date9.);

	Cvar4 = '$125.25';
	Nvar4 = Input(Cvar4,dollar7.2);
run;

data  work.salary1;
	set airline.salary1;
	Bonus = .10*input(grosspay,5.);
run;

data  work.salary2;
	set airline.salary2;
	Bonus = .10*input(grosspay,comma6.);
run;

* Examples on PUT Function;
data PutFunc;
	Nvar1 = 52000;
	Cvar1 = Put(Nvar1,5.);
	Cvar4 = Put(Nvar1,comma6.);	

	Nvar2 = 0 ;
	Cvar2 = Put(Nvar2,date9.);
	Cvar3 = Put(Nvar2,mmddyy10.);
run;

data work.phones;
	set airline.phones;
	Newtelno = '('||put(Code,3.)||') '||Telephone;
run;

* from airline.born
  create a new variable born1 with sas date value,
                        bornyear with numeric year vlaue
                        age in years ;
data born;
	set airline.born;
	born1 = input(date, date7.);
	bornyear = year(born1);
	age = intck('years',born1,today());
run;

* Examples on date time / currency formats / functions ;
data  work.daysales;
	set airline.daysales;
	saledate1 = Put(saledate,date9.);
	saledate2 = input(saledate1,date9.);
	format saledate date9. saleamt dollar14.4;
run;



/***********************************************************************
								FUNCTIONS
Fucntions returns a value to a new variable when applied on existing 
variable

Types of Functions:
-----------------------------------------------------------------------
- Character Functions

- Numeric Functions
	* Statistical Func	* Mathematical Func	* Date Time Func 

- Data Type Conversion Functions
	* INPUT Func - converts character to numeric data type
	* PUT Func - converts numeric to character data type
-----------------------------------------------------------------------	 */

/*There are three primary ways of measuring time in the SAS System. 
These are known as DATE, TIME, and DATETIME values. 
DATE values are stored as the number of daysthat have elapsed since the start of time (January 1, 1960). 
TIME values are the number of secondsthat have elapsed since midnight of the current day.

WHAT IS A SAS DATE AND TIME LITERAL?
One of the simplest of these tools is are literal strings. These are used when you would like to insert a constant
DATE, TIME, or DATETIME value into a DATA step value. 

The following DATA step creates three constant values. */

data _null_;
sampdate = '28jul2004'd;
samptime = '11:32't;
sampdtime= '28jul2004:11:32'dt;
put sampdate=;
put samptime=;
put sampdtime=;
run;

/*The LOG shows:
Notice that the literal values are inclosed in quotes and immediately followed by a letter that tells SAS how to
interpret the literal string. Dates must be in ddmonyyyy form, while time values are hh:mm:ss and datetime values
are a combination of the two. */

/* CREATING DATE AND TIME VALUES
Sometimes we have date and/or time information that may not be in SAS date/time form. The following data step demonstrates 
some of the functions that can be used to create date/time values. */


data dtvalues;
day=28;
mon=7;
yr=2004;
hr=11;
min=32;
sec=0;
sampdate = mdy(mon,day,yr);
samptime = hms(hr,min,sec);
sampdtime= dhms(sampdate,hr,min,sec);
current = today();
put sampdate=;
put samptime=;
put sampdtime=;
run;

* The TODAY and DATE functions return the current date as stored on the computer's clock.;


/* TAKING DATETIME VALUES APART
If you have a DATETIME value and want to create DATE and TIME values.
The DATEPART and TIMEPART functions can be used to convert the number of seconds since the beginning of time to days and seconds since
midnight. */
data samppart;
sampdtime= '28jul2004:11:32'dt;
sampdate = datepart(sampdtime);
samptime = timepart(sampdtime);
put sampdate=;
put samptime=;
put sampdtime=;
run;

*You can also break up both DATE and TIME values using additional functions.;
data allapart;
sampdate = '28jul2004'd;
day=day(sampdate);
mon=month(sampdate);
yr =year(sampdate);
samptime= '11:32't;
hr = hour(samptime);
min= minute(samptime);
sec= second(samptime);
put sampdate= ;
put day= mon= yr=;
put samptime=;
put hr= min= sec=;
run;

*WORKING WITH INTERVALS;

data _null_;
   sdate='16oct1998'd;
   edate='16feb2010'd;
   y30360=yrdif(sdate, edate, '30/360');
   yactact=yrdif(sdate, edate, 'ACT/ACT');
   yact360=yrdif(sdate, edate, 'ACT/360');
   yact365=yrdif(sdate, edate, 'ACT/365');
   put y30360= / yactact= / yact360= / yact365= ;
run;
*YRDIFF - Returns the difference in years between two dates according to specified day count conventions returns a person’s age.;

data age;
dob = '04jun1975'd;
age = yrdif(dob,'28jul2004'd,'30/360');
put dob=;
put age=;
run;

* The YEARCUTOFF= option is used by SAS software to assign a century 
prefix to two-digit years used in SAS programs and input data.;


/* The INTNX and INTCK functions are also used to calculate intervals.
Both use an argument to specify the type of date/time interval of interest. 

The INTCK function counts the number of intervals between two dates. */

data ageint;
dob = '04jun1975'd;
yrs = intck('year',dob,'28jul2004'd);
months = intck('month',dob,'28jul2004'd);
weeks = intck('week',dob,'28jul2004'd);
qtrs = intck('qtr',dob,'28jul2004'd);
put yrs=;
put months=;
put weeks=;
put qtrs=;
run;

/*We can also advance a date/time using the INTNX function. 
This has proved useful for the determination of start and end points of periods of time. 
Suppose you need to determine the first and last date for the month that contains the current sampling date.*/

data period;
sampdate = '28jul2004'd;
start = intnx('month',sampdate,0);
stop = intnx('month',sampdate,1) -1;
put sampdate=;
put start= ;
put stop= ;
run;
* The third argument of the INTNX function specifies how many intervals to advance the date value. 
For START we advance it 0 months and since INTNX always deals with the start of the month, this results in 01jul2004 (for any
date in July). 
When calculating the value for STOP, the INTNX function advances 1 month (01aug2004) and then we subtract one day to get the last day in July.;

data period;
sampdate = '28jul2004'd;
start = intnx('month',sampdate,0);
stop = intnx('month',sampdate,1) - 1;
put sampdate= ddmmyy10.;
put start= date9.;
put stop= mmddyy10.;
run;


/*• ANYDTDTE. extracts the date portion
• ANYDTDTM. extracts the datetime portion
• ANYDTTME. extracts the time portion */

options datestyle=mdy;
data new;
input date anydtdte10.;
put date;
format date date9.;
datalines;
01/13/2003
13/01/2003
13jan2003
13jan03
13/01/03
01/02/03
03/02/01
run;

*Intnx and Intck:

The INTCK function counts the number of intervals between two dates.
The first is the desired interval (see the following table of interval values). The next two arguments represent a starting date and an ending date.


Expression 						Value 
Returned INTCK('year','01Jan2005'd,'31Dec2005) 		0 
INTCK('year','31Dec2005'd,'01Jan2006) 			1 
INTCK('month','01Jan2005'd,'31Jan2005'd) 		0 
INTCK('month','31Jan2005'd,'01Feb2005'd) 		1 
INTCK('qtr','25Mar2005'd,'15Apr2005'd) 			1 
;

data ageint; 
dob = '04jun1975'd; 
yrs = intck('year',dob,'28jul2004'd); 
months = intck('month',dob,'28jul2004'd); 
weeks = intck('week',dob,'28jul2004'd); 
qtrs = intck('qtr',dob,'28jul2004'd);
put yrs=; put months=; put weeks=; put qtrs=; 
run;

/*
yrs=29 months=349 weeks=1521 qtrs=117

Notice that the calculation for the number of years is different from that generated by YRDIF.  
This is because the INTCK and INTNX functions base the interval from the start of the respective intervals.  
This means that YRS would have been 29 for any DOB in 1975 as well as for any second date in 2004.

You can also advance a date/time using the INTNX function.  
Suppose you need to determine the first and last date for the month that contains the current sampling date.
*/
data period; 
sampdate = '28jul2004'd; 
start = intnx('month',sampdate,0); 
stop = intnx('month',sampdate,1) - 1;
put sampdate=; put start= ; put stop= ;
run;

/*The third argument of the INTNX function specifies how many intervals to advance the date value.  
For START we advance it 0 months and since INTNX always deals with the start of the month, this results in 01jul2004 (for any date in July).  
When calculating the value for STOP, the INTNX function advances 1 month (01aug2004) and then we subtract one day to get the last day in July.


USING SHIFT OPERATORS:
Shift operators extend the number and types of available intervals.  The topic is quite complex so consult the documentation for more details.  
Basically a suffix is added to the interval name.  For the interval YEAR the new interval could be specified as YEARm.s; where 'm' is the multiplier and 's' is the shift. 
Normally when we specify YEAR we want an interval of one year and that year is to start on January 1st.  
By adding a multiplier of 2, YEAR2 would specify a two year interval.  
Adding a shift of 3 would specify an interval start of March rather than January.  
Taken together YEAR2.3 would specify a two year interval with 01March as an interval start.  */


data period; 
sampdate = '28jul2004'd; 
yrstart = intnx('year',sampdate,1); 
yrstart2 = intnx('year2',sampdate,1); 
yrstart23 = intnx('year2.3',sampdate,1);
put sampdate= worddate18.; 
put yrstart= date9.; put yrstart2= date9.; put yrstart23= date9.; 
run;

/*
sampdate=July 28, 2004 
yrstart=01JAN2005 
yrstart2=01JAN2006 
yrstart23=01MAR2006
*/



/*Character Functions:
It is important to remember two things: 1) The storage length of a character variable is set at compile time. and 
2) this length is determined by the first appearance of a character variable in a DATA step. 
*/
data chars1;    
file print;    
string = 'abc';    
length string $ 7; /* Does this do anything? */    
storage_length = lengthc(string);    
display = ":" || string || ":";    
put storage_length=;    
put display=; 
run; 




data chars2;    
file print;    
length string $ 7; /* Does this do anything? */    
string = 'abc';    
storage_length = lengthc(string);    
display = ":" || string || ":";    
put storage_length=;    
put display=; 
run;


*Converting Multiple Blanks to a Single Blank:;
data multiple;    
input 	#1 @1  name    $20.          
	#2 @1  address $30.          
	#3 @1  city    $15.             
	@20 state    $2.             
	@25 zip      $5.;    
	name = compbl(name);    
	address = compbl(address);    
	city = compbl(city); 
	datalines; 
Ron Cody 89 Lazy Brook Road Flemington         NJ   08822 
Bill     Brown 28   Cathy   Street North   City       NY   11518 
; 

proc print data=multiple noobs;    
id name;    
var address city state zip; 
run; 

/*							INDEX Function
INDEX, INDEXC AND INDEXW FUNCTIONS: 
INDEX and INDEXC functions return the position where the char or string of characters first occur in the string. 
INDEXW function searches for entire word. It searches for position of text separated by word separators like spaces, 
start of line or End of line.  
Syntax: INDEX(String, Search String);
INDEXC(String, Search String);              
INDEXW(String, Search Word); 
---------------------------------------------------------------------*/
data  indx;
input string $30.;
idx1 = index(string,'R');
idx2 = indexc(string,'R');
idx3 = indexc(string,'B');
idxword = indexw(string,'Presentation') ;
cards;
ABCDRADFE
BCDaHgij
yz XY uv aB
This is a Presentation
;
run;

/* FIND, FINDC AND FINDW FUNCTIONS: 
FIND and FINDC functions return the position where the char or string of characters first occur in the string.  
Syntax : FIND (String, find,<modifier>, startpos )               
FINDC (String, find,<modifier>, startpos )  
 Modifiers:      I = Ignore Case      
				 T = Ignore Trailing Blanks      
				 V = Search of any other string than required  
 Startpos:     Indicates the Position from where to start the search.  	*/

data  indx;
input string $30.;
idx1 = find(string,'R');
idx2 = findc(string,'R');
idx3 = findc(string,'b','v');
idxword = findw(string,'Presentation') ;
cards;
ABCDRADFE
BCDaHgij
yz XY uv aB
This is a Presentation
;
run;

DATA FIND_VOWEL;
   INPUT @1 STRING $20.;
   PEAR = FIND(STRING,"Pear");
   POS_VOWEL = FINDC(STRING,"aeiou",'I');
   UPPER_VOWEL = FINDC(STRING,"aeiou");
   NOT_VOWEL = FINDC(STRING,"AEIOU",'IV');
DATALINES;      
XYZABCabc
XYZ
Apple and Pear
;
PROC PRINT DATA=FIND_VOWEL NOOBS;
   TITLE "Listing of Data Set FIND_VOWEL";
RUN;

DATA O_MODIFIER;
   INPUT STRING      $15. 
         @16 LOOK_FOR $1.;
   POSITION = FINDC(STRING,LOOK_FOR,'IO');
DATALINES;
Capital A here A
Lower a here   X
Apple          B
;
PROC PRINT DATA=O_MODIFIER NOOBS HEADING=H;
   TITLE "Listing of Data Set O_MODIFIER";
RUN;


/*ANY FUNCTIONS: These functions return the first position of ANY DIGIT, ALPHA, ALNUM, PUNCT or SPACE in the string of characters. 

Arguments
string
is the character constant, variable, or expression to search. 
start
is an optional integer that specifies the position at which the search should start and the direction in which to search.; */
data  indx;
input string $30.;
digit = ANYDIGIT(string);
digit1 = ANYDIGIT(string,7); 
digit2 = ANYDIGIT(string,-99);
digit7 = ANYDIGIT(string,-7);
digit3 = ANYALPHA(string);
digit4 = ANYALNUM(string);
digit5 = ANYPUNCT(string);
cards;
Abc123, yog376
;
run;

DATA ANYWHERE;
   INPUT STRING $CHAR20.;
   ALPHA_NUM   = ANYALNUM(STRING);
   ALPHA       = ANYALPHA(STRING);
   ALPHA_5     = ANYALPHA(STRING,-5);
   ALPHA_5_1     = ANYALPHA(STRING,5);
   DIGIT       = ANYDIGIT(STRING);
   DIGIT_9     = ANYDIGIT(STRING,-999);
   DIGIT_9_1     = ANYDIGIT(STRING,999);
   PUNCT       = ANYPUNCT(STRING);
   SPACE       = ANYSPACE(STRING);
DATALINES;
Once upon a time 123 
HELP!
987654321
;
PROC PRINT DATA=ANYWHERE NOOBS HEADING=H;
   TITLE "Listing of Data Set ANYWHERE";
RUN;

DATA SEARCH_NUM;
   INPUT STRING $60.;
   START = ANYDIGIT(STRING);
   END = ANYSPACE(STRING,START);
   IF START NE 0 THEN
      NUM = INPUT((STRING,START,END-START),9.);
DATALINES;
This line has a 56 in it
two numbers 123 and 456 in this line
No digits here
;
PROC PRINT DATA=SEARCH_NUM NOOBS;
   TITLE "Listing of Data Set SEARCH_NUM";
RUN;

DATA NEGATIVE;
   INPUT STRING $5.;
   NOT_ALPHA_NUMERIC = NOTALNUM(STRING);
   NOT_ALPHA         = NOTALPHA(STRING);
   NOT_DIGIT         = NOTDIGIT(STRING);
   NOT_UPPER         = NOTUPPER(STRING);
DATALINES;
ABCDE
abcde
abcDE
12345
:#$%&
ABC
;
PROC PRINT DATA=NEGATIVE NOOBS;
   TITLE "Listing of Data Set NEGATIVE";
RUN;

/* COMPARE FUNCTION: This function compares one character string with another. 
if the strings match the function returns 0 else it returns the position of first non matching value in string.  
Syntax: COMPARE(String1, String2, <Modifier>)  


Modifiers:     
I = Ignore Case      
L = Remove Leading Blanks. 
Trailing blanks are ignored by default.     
: = Truncate the Longer string to the length of the Shorter String . */ 

data  new;
string1 ="v430.210";
string2 = "    V430.210";
com = compare(string1, string2);
run;

data  new1;
string1 ="v430.210";
string2 = "    V430.210";
com = compare(string1, string2, "IL");
run;

/*
CAT FUNCTION:  This function simply concatenates strings.  
Syntax: CAT(String1,…Stringn); 

CATS FUNCTION: This function concatenates strings by removing leading and trailing blanks.  
Syntax: CATS(String1, …Stringn); 

CATX FUNCTION: This function concatenates strings and puts a Separator in between after removing leading and trailing blanks.  
Syntax: CATS(Separator, String1, …Stringn);   */

data concat1;
	FName = '  New';
	LName = 'Techno  ';

	excat = cat(FName, LName);	
	excatc = catc(FName, LName);	
	excatx = catx("*",FName, LName);	
run;

* Examples on Concatenation Operator (||);
data concat1;
	FName = '  New';
	LName = 'Techno  ';

	FullName1 = FName||LName; put FullName1 = ;
	FullName2 = FName||' '||LName; put FullName2 = ;
	FullName3 = FName||', '||LName; put FullName3 = ;
	FullName4 = 'M/s.'||FName||' '||LName; put FullName4 = ;
	
run;

data concat2;
	FName = '  New';
	LName = 'Techno  ';

	FullName1 = FName||LName; put FullName1 = ;
	FullName2 = FName||' '||LName; put FullName2 = ;
	FullName3 = FName||', '||LName; put FullName3 = ;
	FullName4 = 'M/s.'||FName||' '||LName; put FullName4 = ;
	
run;
* Examples on Concatenation Function;
* Newvar = Catx('delimiter by which the data values are separated',
					Var1,Var2,Var3..Varn);
*when you use catx the default length changes to 200;

data concatx;
	FName = '  New';
	LName = 'Techno  ';
	FullName1 = Catx(' ',Fname,LName); put FullName1 = ;
	FullName2 = Catx(', ',FName,Lname); put FullName2 = ;
	FullName3 = Catx(' ','M/s.',FName,Lname); put FullName3 = ;
run;


/*Function: SCAN 
Purpose: Extracts a specified word from a character expression, where word is defined as the characters separated by a 
set of specified delimiters.  
The length of the returned variable is 200, unless previously defined.  

Syntax: SCAN(character-value, n-word <,'delimiter-list'>)  
character-value is any SAS character expression.  
n-word is the nth "word" in the string.  
If n is greater than the number of words, the SCAN function returns a value that contains no characters.  
If n is negative, the character value is scanned from right to left.  A value of zero is invalid. 

Default delimiters are:
blank . < ( + & ! $ * ) ; ^ - / , % |  

*/


data scn1;

STRING1 = "ABC DEF";
STRING2 = "ONE?TWO THREE+FOUR|FIVE";  

ex1 = SCAN(STRING1,2);
ex2 = SCAN(STRING1,-1);
ex3 = SCAN(STRING1,3);
ex4 = SCAN(STRING2,4);
ex5 = SCAN(STRING2,2," ");
ex6 = SCAN(STRING1,0);

run;

** Without Delimiter ** ;
data firstlast;
input String $60.;
First_Word = scan(string, 1);
Last_Word = scan(string, -1);
datalines;
Jack and Jill
& Bob & Carol & Ted & Alice &
Leonardo
;
run;


data all;
   length word $20;
   drop string;
   string = ' The quick brown fox jumps over the lazy dog.   ';
   do until(word=' ');
      count+1;
      word = scan(string, count);
      output;
   end;
run;
proc print data=all noobs;
run;

data comma;
   keep count word;
   length word $30;
   string = ',leading, trailing,and multiple,,delimiters,,';
   delim = ',';
   modif = 'mo';
   nwords = countw(string, delim, modif);
   put 	nwords =;
   do count = 1 to nwords;
      word = scan(string, count, delim, modif);
      output;
   end;
run;
proc print data=comma noobs;
run; 

/*****************************************************************************
								TRANWRD FUNCTION
------------------------------------------------------------------------------
Searches for a specified value in the given value and replaces the value
as many number of times it occurs

The number of characters replaced can be less or more than the searched
number of characters

Newvar = Tranwrd(Cvar,'Search for a value(casesensitive)',Replace with 
                 a new value of any length);
*****************************************************************************/

data _Null_; 
	Puff1 = 'Veg Puff';
	Puff2 = 'Veg Puff Veg';

	Var1 = Tranwrd(Puff1,'Veg','Chicken'); put Var1 = ;
	Var2 = Tranwrd(Puff2,'Veg','Chicken'); put Var2 = ;
run;

/*TRANSLATE()*/

data test;
abc = "Honest is best policy";
xyz = TRANSLATE(abc,"#"," "); /* Translate(string,TO,FROM) */
pqr = TRANSLATE(abc,"IS","is");
uvw = TRANWRD(abc,"is","IS"); /* TranWrd(string,FROM,TO) , syntax little diff*/
run;

data  indx;
input string $30.;
if index(string,' ') then string=tranwrd(left(trim(string)),' ',',');
cards; 
ABCDRADFE
BCDaHgij
yz XY uv aB
This is a Presentation
;
run;


/*			Left / Right / Trim / Trim with Left Funnction

- Aligning the data values inside the variable
- Char data type variables are left aligned by default
- Num data type variables are right aligned by default
- When right algined with right function moves trailing to 
  leading blanks
- when left aligned with left function moves leading to trailing blnks
- Trim function removes only trailing blanks
- Trim with left function removes both leading and trailing blnks
---------------------------------------------------------------------
---------------------------------------------------------------------*/
data  work.empdata;
	set airline.empdata;
	Rtalign = right(Firstname);
	Ltalign = left(rtalign);
	RemTrailBlnks = Trim(firstname);
	RemTrailLeadBlnks =  Trim(Left(firstname));
run;

data sample;
	Fname = 'new         ';
	Lname = '        Techno     ';

	Fullname = trim(FName)||' '||trim(left(Lname))||' '||'Pvt. Ltd';
	
run;


/*****************************
							Numeric Functions
Numeric Functions can be applied only on numeric data type variables
- Mathematical	- Statistical (Summary Func)	- Date Time Functions
-----------------------------------------------------------------------

***********************************************************************
						STATISTICAL Functions
---------------------------------------------------------------------*/
data sample;
	x1 = 7;
	x2 = 3;
	x3 = .;

	a = sum(x1,x2,x3); * sum func ignores missing values; 
	b = sum(of x1-x3); * selecting range of continuous vairables;
	c = min(of x1-x3); * MIn func returns the non missing value;
	d = max(of x1-x3); * Max func returns maximum value;
	e = mean(of x1-x3);	* Mean func returns the average only on
	                     non missing values ;
	f = std(of x1-x3); * Std returns standard deviation of a value;
run;

* Rounding the value to the nearest digit or decimal places;
* Rounding off value to the nearest decimal places;
* Newvar = round(Nvar,round off unit for decimal places);

data _null_;
	total1 = round(52.42,.10); put total1 = ;
			* .10 .20 .30 .40<=  .42 <= .50 .60 .70 .80 .90 ;

	total2 = round(52.47,.10); put total2 = ;
	total3 = round(52.45,.10); put total3 = ;
run;

*  Rounding off value to the nearest digit places;
data _Null_;
	total1 = round(12.41,1); put total1 = ;
			* 10 11 12<= 12.41 <=13;

	total2 = round(12.52,1); put total2 = ;
	total3 = round(74,50); put total3 = ;
run; 

data _null_;
	a = int(125.25); put a = ;
		* int func returns the integer portion of the value;

	b = abs(-125.25); put b = ;
		* abs func returns the positive value of the given negative value;

	c = ceil(3.01); * ceil func returns the next highest digit value;
		put c = ;

	d = ceil(3.99); put d = ;

	e = floor(3.01); put e = ;
		* floor func returns the integer portion of the value, similar
	      to int function ;
	f  = mod(4,2); * mod func generates remainder value ;
		put f = ;
run;

	/*Imp intv question*/

data sample;
a = 10.5;
b = . ;
c = 30.3;
d = 20;
sm1 = Sum(a,b,c,d); /* Ingores the missing values */
sm2 = a+b+c+d;
avg1 = Mean(a,b,c,d); /* Ingores the missing values */
avg2 = (a+b+c+d)/4;
mdn = Median(a,b,c,d);
std = STD(a,b,c,d);
run;
proc print;run;

data score;
Length Student $ 10;
input Student $ StudentID $ Section $ Test1 Test2 Test3;
Total = Sum(OF test1-test3); /* Row level computing */
Avg_Marks = Mean(OF test1-test3);
datalines;
Capalleti 0545 1  94 91 87
Dubose    1252 2  51 65 91
Engles    1167 1  95 97 97
Grant     1230 2  63 75 80
Krupski   2527 2  80 76 71
Lundsford 4860 1  92 40 86
Mcbane    0674 1  75 78 72
;
proc print;run;

data test;
a = abs(-45);
b = exp(3);
c = Fact(5);
d = Log(23.5);
e = Mod(10,2);
f = SQRT(16);
run;
proc print;run;


data test;
a = 10/2; /* quotient*/
b = mod(10,2); /* reminder */
run;
proc print;run;

data test;
set sashelp.class;
Num = _N_;
IF Mod(_N_,2) = 0;
*Where Mod(_N_,2) = 0; /* Where does not work here as _N_ is not available */
run;
proc print;run;

data sample;
a = ceil(23.7);
b = floor(23.7);
b1 = floor(-23.7);
c = int(23.9);
d = int(-23.9);
run;
proc print;run;

data test;
set sashelp.class;
W2 = Ceil(Weight);
W3 = Floor(Weight);
W4 = Int(Weight);
Run;

proc print;run;

data test;
a = floor(26.7,1);
b = round(26.7,10);
c = round(23.75,0.001);
run;
proc print;run;


/*Input() :: Converts char into numeric */
/*Syntax: Input(Chart,Informat);*/

data test1;
input Id $ dob $ fee $;
cards;
101 23JAN90 $2,500
102 21FEB80 $3,000
103 15AUG47 $2,800
;


data test2;
set test1;
DOB2 = Input(DOB,date7.);
ID2 = Input(ID,Best12.);
Fee2 = Input(Fee,Dollar7.);
run;
proc print;format dob2 weekdate21.;run;

data test3;
set test2;
d = day(dob2);
run;


/*Put() :: Converts Numeric into char */
/*Syntax: Put(Numeric,Format);*/

data test1;
input Id dob date7.;
cards;
101 23JAN90
102 21FEB80
103 15AUG47
;
data test2;
set test1;
DOB2 = Put(DOB,ddmmyy10.);
ID2 =  Put(ID,Best12.);
run;
proc print;format dob date9.;run;
 

***************************Performing Conditional Processing **************************;

*IF and IF-ELSE Statements:	;
 data conditional;      
length Gender $ 1          
Quiz   $ 2;      
input Age Gender Midterm Quiz FinalExam;      
  

datalines;   
21 M 80 B- 82   
.  F 90 A  93   
35 M 87 B+ 85 
48 F  . .  76   
59 F 95 A+ 97   
15 M 88 .  93   
67 F 97 A  91   
.  M 62 F  67   
35 F 77 C- 77   
49 M 59 C  81 
;
run;

data test1;
set conditional;
if Age lt 20 then AgeGroup = 1;     
if Age ge 20 and Age lt 40 then AgeGroup = 2;      
if Age ge 40 and Age lt 60 then AgeGroup = 3;      
if Age ge 60 then AgeGroup = 4; 
run;




data test2;
set conditional;
if Age lt 20 and not missing(age) then AgeGroup = 1;      
else if Age ge 20 and Age lt 40 then AgeGroup = 2;      
else if Age ge 40 and Age lt 60 then AgeGroup = 3;      
else if Age ge 60 then AgeGroup = 4; 
run;

*Where Condition/statement
WHERE conditions are applied before the data enters the input buffer while IF conditions are applied after the data enters 
the program data vector.  
WHERE conditions are non- executable while IF conditions are executable.  
This is the reason why the WHERE condition is faster  ;

data new;
input name $ class $  score $;

datalines;
Tim math 9
Tim history 8 
Tim science 7
Sally math 10
Sally science 7
Sally history 10
;
run;

data new1;
set new;
where score = 9;
run;

data new2;
set new;
if score = 9;
run;

*Must use IF statements/conditions
Accessing raw data file using INPUT statement    
Using automatic variables such as _N_, FIRST.BY, LAST.BY     
Using newly created variables in data set or existing variables AFTER their value has been changed in the data step 
In combination with data set options such as FIRSTOBS =, OBS =**
To conditionally execute statement ;

* Must use Where Conditions
Using special operators*** such as LIKE or CONTAINS  
Directly using any SAS Procedure  
More efficiently
Using index, if available 
When subsetting as a data set option
When subsetting using the SQL procedure;

* Must use IF ;
********************* While reading data conditionally from raw data file **********************;
data exam;   
input name $ class $ score ;   
if name = "Tim" or name = "Sally"; 

cards; 
Tim math 9 
Tim history 8   
Tim science 7 
Sally math 10 
Sally science 7 
Sally history 10 
John math 8 
John history 8 
John science 9 
; 
run; 

********************* While using automatic variables **********************;
data exam;   
input name $ class $ score ;   
cards; 
Tim math 9 
Tim history 8   
Tim science 7 
Sally math 10 
Sally science 7 
Sally history 10 
John math 8 
John history 8 
John science 9
kumar biology 10
; 
run; 

proc sort data=exam;
by name;
run;

data new2;
set exam;
by name;
where first.name;
run;

********************* Using newly created variables in data set **********************;
data student3;   
set exam;  

if class = "math" then classnum = 1;
else if class = "science" then classnum = 2;
else if class = "history" then classnum = 3;  

if classnum = 2; 
 
run;

******************* Do & End ******************************;


data grades;      
length Gender $ 1
Quiz   $ 2             
AgeGrp $ 13;      
infile 'E:\Documents\SAS\Class notes\grades.txt' missover;      
input Age Gender Midterm Quiz FinalExam;      
if missing(Age) then delete;      
if Age le 39 then Agegrp = 'Younger group';      
if Age le 39 then Grade  = .4*Midterm + .6*FinalExam;      
if Age gt 39 then Agegrp = 'Older group';      
if Age gt 39 then Grade  = (Midterm + FinalExam)/2;   
run;

data grades;      
length Gender $ 1
Quiz   $ 2             
AgeGrp $ 13;      
infile 'E:\Documents\SAS\Class notes\grades.txt' missover;      
input Age Gender Midterm Quiz FinalExam;      
if missing(Age) then delete;       	
if Age le 39 then do;         
	Agegrp = 'Younger group';         
	Grade = .4*Midterm + .6*FinalExam;      
end;      
else if Age gt 39 then do;         
	Agegrp = 'Older group';         
	Grade = (Midterm + FinalExam)/2;      
end;   
run;

************************** Sum and Retain Statement ***************************;
 data revenue;      
input Day : $3.            
Revenue : dollar6.;      
Total = Total + Revenue; /* Note: this does not work */      
format Revenue Total dollar8.;   
datalines;   
Mon $1,000   
Tue $1,500   
Wed  .        
Thu $2,000   
Fri $3,000   
; 
run;

data revenue2;
input Day : $3.
Revenue : dollar6.;
retain Total 0;
Total = Total + Revenue;
format Revenue Total dollar8.;   
datalines;   
Mon $1,000   
Tue $1,500   
Wed  .        
Thu $2,000   
Fri $3,000
;
run; 

data revenue3;
input Day : $3.
Revenue : dollar6.;
retain Total 0;
if not missing(Revenue) then Total = Total + Revenue;
format Revenue Total dollar8.;   
datalines;   
Mon $1,000   
Tue $1,500   
Wed  .        
Thu $2,000   
Fri $3,000
;
run; 
 
libname learn "C:\Users\muralikrishnaee\Desktop\SAS_DS";

******************************************* PRINT procedure (PROC PRINT) ****************************************;

* Simple and straight forward print;
proc print data=learn.sales;   
run; 

* Controlling the Variables;
proc print data=learn.sales;     
var EmpID Customer TotalSales;  
run; 

* omit the Obs column;
proc print data=learn.sales;   
ID EmpID; 
var Customer TotalSales;  
run; 

proc print data=learn.sales noobs;   
var EmpID Customer TotalSales;  
run; 

*Changing the Appearance of Values;
 proc print data=learn.sales;  
id EmpID;      
var Customer Quantity TotalSales;      
format TotalSales dollar10.2 Quantity comma5.;   
run; 

* Controlling the Observations;
 proc print data=learn.sales;      
id EmpID;      
var Customer Quantity TotalSales;      
where Quantity gt 400;   
format TotalSales dollar10.2 Quantity comma7.;   
run;

proc print data=learn.sales;      
where EmpID in ('1843' '0177');      
id EmpID;      
var Customer Quantity TotalSales;      
format TotalSales dollar10.2 Quantity comma7.;   
run; 

*Labeling Your Column Headings;
proc print data=sales label;      
id EmpID;      
var TotalSales Quantity;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;   
run;

* Break down the Listing;
 proc sort data=learn.sales out=sales;      
by Region;   
run;  

proc print data=sales label;      
by Region;      
id EmpID;      
var TotalSales Quantity;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;   
run;

*Adding Subtotals and Totals to Listing;

proc print data=sales label;      
by Region;      
id EmpID;      
var TotalSales Quantity;      
sum Quantity TotalSales;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;   
run;

* Better Readability;

proc sort data=learn.sales out=sales;
by EmpID;   run;  

proc print data=sales label;      
by EmpID;      
id EmpID;      
var Customer TotalSales Quantity;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;  
run; 

*Adding the Number of Observations to Your Listing ;
 proc print data=sales n="Total number of Observations:";      
id EmpID;      
var TotalSales Quantity;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;   
run;

*  Double-Spacing Your Listing ;
 proc print data=sales double;      
id EmpID;      
var TotalSales Quantity;      
label EmpID = "Employee ID"            
TotalSales = "Total Sales"            
Quantity = "Number Sold";      
format TotalSales dollar10.2 Quantity comma7.;   
run;  

 * Listing the First n Observations of Your Data Set ;
proc print data=learn.sales(obs=5);   run;


******************************************* SORT procedure (PROC SORT) ****************************************;

* Changing the Order of Listing;
 proc sort data=learn.sales;      
by TotalSales;   
run; 
 proc print data=learn.sales;
 run; 

   proc sort data=learn.sales;      
by  descending TotalSales ;   
run; 
 proc print data=learn.sales;
 run;

 *Sorting by More Than One Variable;
proc sort data=learn.sales out=sales;      
by EmpID descending TotalSales;   
run;  

proc print data=sales;
var EmpID descending TotalSales;
run;

/* DEFINING NODUP AND NODUPKEY OPTIONS  
The NODUP option checks for and eliminates duplicate observations. 
If you specify this option, PROC SORT compares all variable values for each observation to those for the previous observation 
that was written to the output data set. If an exact match is found, the observation is not written to the output data set. 
 
The NODUPKEY option checks for and eliminates observations with duplicate BY variable values. 
If you specify this option, PROC SORT compares all BY variable values for each observation to those for the previous 
observation written to the output data set. If an exact match using the BY variable values is found, the observation is not written 
to the output data set.  

Notice that with the NODUPKEY option, PROC SORT is comparing all BY variable values 
while the NODUP option compares all the variables in the data set that is being sorted. */

data best;        
input patient 1-2 arm $ 4-5 bestres $ 6-7 delay 9-10;     
datalines; 
01 A CR 0 
02 A PD 1 
03 B PR 1 
04 B CR 2 
05 C SD 1 
06 C SD 3 
07 C PD 2 
01 A CR 0 
03 B PD 1
; 
run;

proc sort data=best nodup out=ex1;   
by patient;  
run;
proc sort data=best nodup out=ex2_1;   
by arm;  
run;
proc sort data=best nodup out=ex2_2;   
by arm patient; 
run;

proc sort data=best nodupkey out=ex3;   
by patient;  run;
proc sort data=best nodupkey out=ex4;   
by arm;  run;

proc sort data=best nodupkey out=ex5;   
by arm bestres;  run;

libname airline 'E:\SAS\SAS DATASETS\SAS DATASETS\Sas datasets\Prog1';

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

proc import datafile="C:\Users\muralikrishnaee\Desktop\import1.txt" 
			out=mydata   	
			dbms=dlm    
			replace;
delimiter='&';
 getnames=yes;
run;

* Importing a Specific Delimited File Using a Fileref;

Filename stdata "C:\Users\muralikrishnaee\Desktop\import2.txt" lrecl=100;

proc import datafile=stdata
     out=stateinfo
     dbms=dlm
     replace;
     getnames=yes;
run;

* Importing a Tab-Delimited File;

proc import datafile='C:\Users\muralikrishnaee\Desktop\import3.txt'
     out=class
     dbms=dlm
     replace;
     delimiter='05'x;
	 datarow=5;
   run;

* Importing a Comma-Delimited File with a CSV Extension;

   proc import datafile="C:\Users\muralikrishnaee\Desktop\class.csv"
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
   outfile='C:\Users\muralikrishnaee\Desktop\export2.txt'
   dbms=dlm; 
    delimiter='&';
  run;

  proc export data=class
   outfile='C:\Users\muralikrishnaee\Desktop\exporttab.txt'
   dbms=dlm
  replace; 
    delimiter='05x';
  run;

  proc export data=class
   outfile='C:\Users\muralikrishnaee\Desktop\class.csv'
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

libname airline "E:\SAS\SAS DATASETS\SAS DATASETS\Sas datasets\Prog1";

******************************************************PROC FORMAT *********************************;
Proc Format < Library= FMTLIB CNTLOUT= CNTLIN= >;
Value <$> formatname Values;
Invalue <$> Informatname Values;
Picture formatname Values;
Select format/informat names;
Exclude format/informat names;
Run;


Proc Format;
Value $ Gend_Fmt 
		"M" = "Male" 
		"F" = "Female";
Value Gend_Fmtt 
		1 = "Male" 
		2 = "Female";
Value $ Gen_Fmt 
		"M" = 1 
		"F" = 2;
Value Range 
		1-9 = 1 
		10-100 = 2;
Value Age_Grps 	
		Low - 12 = "Child" 
		13-19 = "Teen" 
		20-25 = "Young Age"
		25 - 49 = "Adult"
		50 - High = "Sr Citgn"
		Other =     "Invalid Age"
;

Run;


Proc Print Data = sashelp.shoes;
Format Stores Gend_Fmtt.;
Run;

Proc Print Data = sashelp.class;
Format sex $Gend_Fmt.;
Run;

Proc Format;
InValue $ Gend_Fmt "M" = "Male" "F" = "Female";
*InValue Gend_Fmtt 1 = "Male" 2 = "Female"; /*doesn't work */
InValue $ Gen_Fmt "M" = 1 "F" = 2;
InValue Gen_Fmt 1-9 = 1 10-100 = 2;
Run;

data test;
Informat gender $Gend_Fmt. ;
input id dob ddmmyy10. gender $;
cards;
101 24/09/2011 M
102 12/08/2010 F
;

data test2;
input id dob ddmmyy10. gender :$Gend_Fmt. ; /* Colon is required for user defined formats */
cards;
101 24/09/2011 M
102 12/08/2010 F
;

data test3;
set test2;
Dob2 = Put(DOB,date9.);
Mon = Substr(dob2,3,3);
Run;

Proc Print;Run;

Proc Format;
Picture Ind_cur 
					LOW -< 0  =  "00,00,00,00,000" (Prefix=" - Rs. " Fill="*")
					0 <-  HIGH =  "00,00,00,00,000" (Prefix="Rs. " Mult=100 Fill="@");
Run;

Proc Print data = sashelp.buy;
format amount Ind_cur.;
Run;

proc format;
picture phn_fmt 0-High = "000-000-000/0" (Prefix="+91 ");
run;

data phn;
input cell;
cards;
9299995227
9246274227
9247849906
;

proc print data = phn;
format cell Phn_fmt.;
Run;

Proc Format Lib = Airline;
Value $ Gend_Fmt "M" = "Male" "F" = "Female";
Value Gend_Fmtt 1 = "Male" 2 = "Female";
Value $ Gen_Fmt "M" = 1 "F" = 2;
Value Range 1-9 = 1 10-100 = 2;
Value Age_Grps 	Low - 12 = "Child" 
				13-19 = "Teen" 
				20-25 = "Young Age"
				25 - 49 = "Adult"
				50 - High = "Sr Citgn"
				Other =     "Invalid Age"
;

Run;

Proc Format Library = Airline FMTLIB;
Run;

Proc Format Library = Airline FMTLIB;
Select Range Gend_Fmtt;

Run;


/*CNTLOUT Option Creates a SAS data set that stores information about informats or formats*/
Proc Format Library = Airline CNTLOUT=All_My_Fmts;
Run;

Proc Format Library = Airline CNTLOUT=All_My_Fmts;
Select Gen_Fmt $Gend_Fmt;
Run;


*******************************************************************************************************************
*******************************************************************************************************************
*******************************************************************************************************************;
******************************************** PROC FREQ ****************************************************;


/* One Way Freq Procedure - generates freq counts by default on each and
every variable specified on the input dataset for both char and numeric
data types
-----------------------------------------------------------------------
Default Frq Measures - Freq  CumFreq  Percent  Cumpercent */

* Syntax for One Way Freq Procedure;
proc freq data = libref.inputdataset nlevels;
	where ..condition.. ;
	table Var1 Var2 Var3;
	weight anavar1;
	by Grpvar1 Grpvar2;
	format Var1 fmtname. ;
run;

proc freq data = libref.inputdataset nlevels;
	where ..condition.. ;
	table Var1 / nocum nopercent outcum out = libref.outputdataset;
	table var2 / nopercent out = libref.outputdataset ;
	weight anavar1;
	by Grpvar1 Grpvar2;
	format Var1 fmtname. ;
run;

* Default Freq procedure - generates freq counts by default on all the 
  variables (char and numeric) from the input dataset;

proc freq data = airline.crew;
run;

* What is the total number of employees from each location and each
  jobcode ;
* TABLE statement restricts and prints freq counts for the variables 
  specified on TABLE Statement;
* One way frq procedure since it creates freq counts on each variable
  separately ;
proc freq data = airline.crew;
	table location jobcode;
run;

* Enhance the output results specifying options on table statement ;
* NOCUM - does not print cumfrqe and cumpercent;
* NOPERCENT - does not print cumpercent and percent ;
* NOCUM / NOPERCENT - is to restrict only to print to output report not to
  output sas dataset ;
* OUTCUM - by default the frq results in output dataset only store 
  freq and percent to store cumfrq and cumpercent use OUTCUM option ;
* NLEVELS - option on proc frq prints the number of unique values from
  each variable specified on table statement ;

proc freq data = airline.crew nlevels;
	where salary > 45000 ;
	table location / nocum nopercent ;
	table jobcode / nocum nopercent;
	run;

* what is the total salaries paid across each location and each jobcode;
* By default frq proc generates freq counts, to override frq counts with
  a summary variable value then use WEIGHT statement with analysis variable
  (numeric);
* WEIGHT statement perfroms a SUM summary function on only one single
  analysis variables ;

proc freq data = airline.crew nlevels;
	table location jobcode;
	weight salary;
run;

* What is the total number of employees from each location within each
  jobcode 
	dividing the repor tinto multiple groups by location
		within each location show total number of employees ;
* 'BY' statement in proc freq divides the report into multiple groups 
  for each variable specified (pre-req is to sort on BY statement variables);


proc sort data = airline.crew out = work.crewsort;
	by location;
run;

proc freq data = work.crewsort nlevels;
	table jobcode;
/*	weight salary;*/
	by location;
run;

/*					TWO WAY FREQ PROCEDURE (CROSS TABULAR REPORT)
- generates freq counts with a cross tabular report
- one variable is specified on row and the second variable is specified
  on column which makes cross tabular report
  (clubbing two variables into one single frq report)
-----------------------------------------------------------------------
Default Frq Measures - 	Freq 	Percent		RowPercent		CoPercent
***********************************************************************
----------------------------------------------------------------------- */

* Syntax for Two Way Freq Procedure;
proc freq data = libref.inputdataset nlevels;
	where ..condition.. ;
	table row-exp-var1*col-exp-var2;
	table row-exp-var3*col-exp-var4 / nopercent norow nocol 
                          crosslist out = libref.outputdataset;
	weight anavar1;
	by Grpvar1 Grpvar2;
	format Var1 fmtname. ;
run;

* Default Two Way Freq Procedure;
* TABLE Statement specifies a min and max of two variables only on which
  to generate freq results ;
proc freq data = airline.crew;
	table location*jobcode;
run;

********************************************************************
Frequency - Total number of employees from CARY / FLTAT1 = 5
Percent - What is the percentage of 5 employees from CARY / FLTAT1
          with respect to the total number of emplolyees i.e. 69 = 7.25%
RowPercent - What is the percentage of 5 employees from CARY / FLTAT1
          with respect to the total number of employees from CARY
          i.e 27 = 18.52%
ColPercent - What is the percentage of 5 employees from CARY / FLTAT1
          with respect to the total number of employees from FLTAT1
          i.e 14 = 35.71%
********************************************************************;

proc freq data = airline.crew nlevels;
	table location*jobcode / nopercent norow nocol crosslist
                        out=work.locjcfrq;
	* weight salary;
run;

*what is the total number of employees from each country within each city
  grouped by each division ;
proc sort data = airline.employees out = work.empsort;
	by division;
run;

proc freq data = work.empsort nlevels;
	where country in('USA','AUSTRALIA') ;
	table country*city / norow nocol nopercent ;
	by division;
run;

**************************************************************************
From airline.crew create a two way frq reprot on jobcode and salary vars.
Group Fltat1 to Fltat3 as Fltat
Group Pilot1 to Pilot3 as Pilot

Group Salary values as below
	20000 - 30000 = Low Salary
    30000.01 - 45000 = Medium Salary
    40000.01 - High = High Salary


**************************************************************************;
proc format ;
	value $jcode 
      "FLTAT1"-"FLTAT3" = "FLTAT"
       "PILOT1"-"PILOT3" = "PILOT"
       "A"-"C"="X";
	Value sals
      20000 - 30000 = "Low Salary"
    30000.01 - 45000 = "Medium Salary"
    45000.01 - High = "High Salary";
    
run;

proc freq data=airline.crew nlevels;
	table jobcode*salary/ nocol nopercent norow;
	format jobcode $jcode. salary sals.;
run; 

proc freq data = libref.inputdataset ;
	table page-exp-var1*row-exp-var2*col-exp-var3;
run;

***************************************PROC UNIVARIATE****************************
- Proc means by default generates descriptive stats, if required 
  specify addl stats on proc means statement
- proc univariate generates all the possible statistics onto output
  report
-----------------------------------------------------------------------
*/
******************************** Syntax***************;
Proc Univariate data = inputdata 
NoPrint 
Maxdec= 
Missing ;
Class Grouped data;
Var Analytical variables ;
Output Out = outputdataset statistical_keywords = alias_names ;
Histogram Grouped data/Options;

By sorting_variable;
Where stmt;
Format stmt;
Run;

Proc Univariate data = sashelp.class;
Run;

Proc Univariate data = sashelp.class N Mean Std Sum; /* doesn't work */
Run;

Proc Univariate data = sashelp.class;
Var Age;
Run;

Proc Univariate data = sashelp.class;
Var Height;
Class Sex;
Run;

Proc Univariate data = sashelp.class ;
Var Height;
Class Sex;
Output Out = xyz N = Freq Mean = Avg Std = Std_Dev;
Run;
Proc Print;run;

Proc Means data = sashelp.class;
Var Height;
Class Sex;
Output Out = xyz2 N = Freq Mean = Avg ;
Run;

Proc Univariate data = sashelp.class ;
Histogram Age/Midpoints = 11 To 16 Cfill=Red Normal BarWidth=6;
Run;

proc univariate data = airline.crew ;
	var salary;
	class location jobcode;
	output out = work.crewunivar
		N = Sal_N
		Mean = Sal_Mean
		Std = Sal_Std
		Min = Sal_Min
		Max = Sal_max ;
run;



/******************** Ways of creating Macro Variable ************************
• %LET statement
• macro parameters (named and positional)
• iterative %DO statement
• using the INTO in PROC SQL
• using the CALL SYMPUT routine

• %LET statement 
The %LET statement is followed by the macro variable name, an equal sign (=), and then the text value to be assigned to the
macro variable. 

Unlike data set variables, macro variables are neither character nor numeric; they always just store text. 

The syntax of the %LET statement is
%LET macro-variable-name = text-or-text-value;

If the %LET statement is outside of any macro, its value will be available throughout the entire program, and it is said to be a
global macro variable. On the other hand, if the macro variable is defined inside of a macro it may be local, and its value will
only be available within that macro. 

The macro language does not support the concept of a missing value. Unlike data set variables, macro variables can actually
contain nothing. In the macro language this is often referred to as a null value. The %LET statement does not store nonembedded
blanks, so each of the following pairs of %LET statements will store the same value (in this case the value stored
in &NADA is actually nothing – null).
%let nada =;
%let nada = ;
%let dsn =clinics;
%let dsn = clinics ;
If you do wish to store a blank, as opposed to a null value, you will need to use a quoting function.

• macro parameters (named and positional)
	Positional Parameters
Positional parameters are defined by listing the macro variable names that are to receive the parameter values in the
%MACRO statement. */ 

%LET DSN = CLINICS;
%LET OBS = 10;
%MACRO LOOK;
 PROC CONTENTS DATA=&dsn;
 TITLE "DATA SET &dsn";
 RUN;
 PROC PRINT DATA=&dsn (OBS=&obs);
 TITLE2 "FIRST &obs OBSERVATIONS";
 RUN;
%MEND LOOK;

%MACRO LOOK(dsn,obs);
 PROC CONTENTS DATA=&dsn;
 TITLE "DATA SET &dsn";
 RUN;
 PROC PRINT DATA=&dsn (OBS=&obs);
 TITLE2 "FIRST &obs OBSERVATIONS";
 RUN;
%MEND LOOK;

%LOOK(CLINICS,10)


/*The only difference in these two versions of %LOOK is in the %MACRO statement. 
The parameters allow us to create &DSN and &OBS as local macro variables and we are not required to modify the macro itself. 
Because the parameters are positional, the first value in the macro call is assigned to the macro variable that is listed 
first in the macro statement’s parameter list. 
When you have multiple parameters, you need to use commas to separate their values. 

Keyword or Named Parameters
Keyword parameters are designated by following the parameter name with an equal sign (=). Default values, when present,
follow the equal sign. You can use keyword parameters to redefine the previous version of the %LOOK macro. */

%MACRO LOOK(dsn=,obs=);
 PROC CONTENTS DATA=&dsn;
 TITLE "DATA SET &dsn";
 RUN;
 PROC PRINT DATA=&dsn (OBS=&obs);
 TITLE2 "FIRST &obs OBSERVATIONS";
 RUN;
%MEND LOOK;

%look(dsn=clinics, obs=10)

/*
• iterative %DO statement
Syntax */
%DO macro-variable = start %TO stop <%BY increment>;
. . . text . . .
%END;

* The iterative %DO defines and increments a macro variable. ;

%MACRO ALLYR(START,STOP);
 %DO YEAR = &START %TO &STOP; 

 	DATA TEMP;
 	SET YR&YEAR;
 	YEAR = 1900 + &YEAR;
 	RUN;

 	PROC APPEND BASE=ALLYEAR DATA=TEMP; 
 	RUN;

 %END;
%MEND ALLYR;

%allyr(95,97)

* The macro call %ALLYR(95,97) generates the following code;
DATA TEMP;
 SET YR95;
 YEAR = 1900 + 95;
RUN;
PROC APPEND BASE=ALLYEAR DATA=TEMP;
RUN;
DATA TEMP;
 SET YR96;
 YEAR = 1900 + 96;
RUN;
PROC APPEND BASE=ALLYEAR DATA=TEMP;
RUN;
DATA TEMP;
 SET YR97;
 YEAR = 1900 + 97;
RUN;
PROC APPEND BASE=ALLYEAR DATA=TEMP;
RUN;

/* INTO IN PROC SQL
PROC SQL can be used to create macro variables by writing directly to the symbol tables.
Placing a single value in a macro variable */

	*Placing a single value in a macro variable:;
%let cln = Beth;

proc sql noprint;
 select count(*) into :nobs from sasclass.clinics(where=(clinname=:"&cln")); 
 quit;
%put number of clinics for &cln is &nobs; 

*The INTO clause is used to create the new macro variable NOBS. 
The colon informs the SELECT statement that the result of the COUNT function is to be written into a macro variable.

Once created, the new macro variable is used in the same way as any other macro variable. Both macro variables are
preceded by an ampersand in the %PUT statement.;
	
	*Creating lists of values:;

proc sql noprint;
select lname, dob into :lastnames separated by ',',  :dobirths separated by ',' 
 from sasclass.clinics(where=(lname=:'S')); 
%let numobs=&sqlobs; 
quit;

%put lastnames are &lastnames;
%put dobirths are &dobirths;
%put number of obs &numobs;

*
The values of the variables LNAME and DOB will be written INTO macro variables.

The list of values of LNAME will be written into &LASTNAMES with the values separated by a comma. Without the
SEPARATED BY clause the individual values will replace previous values rather than be appended onto the list. The last
comma is needed to separate the two macro variables (:LASTNAMES and :DOBIRTHS).

The list of the dates of birth will be written to &DOBIRTHS.;


*Placing a List of Values into a Series of Macro Variables:;
%macro varlist(dsn);

	proc contents data= &dsn out= cont noprint;
 	run;

	proc sql noprint;
 	select distinct name 
 	into :varname1-:varname999 
 	from cont;
 	quit;

%do i = 1 %to &sqlobs; 
 %put &i &&varname&i;
%end;

%mend varlist;

%varlist(sasclass.clinics)

/********** CallSymput**********************/

*Syntax;
CALL SYMPUT(macro_varname,value);

data _null_;
 set sashelp.class;
 cnt = left(put(_n_,6.));
 call symput('name'||cnt,name);
 call symput('namecnt', cnt);
 run;
%put _user_;




* Using a Macro Variable to Select Observations to Process;

%let month_sold=4;
proc print data=books.ytdsales noobs;
title "Books Sold for Month &month_sold";
where month(datesold)=&month_sold;
var booktitle saleprice;
sum saleprice;
run;

%let month_sold=4;
proc print data=books.ytdsales (where=(month(datesold)=&month_sold)) noobs;
title "Books Sold for Month &month_sold";
var booktitle saleprice;
sum saleprice;
run;


*Creating datasets for multiple months;

%macro salemon;
%do mon_sold=7 %to 9;

data books.sold&mon_sold;
set books.ytdsales;
where month(datesold) = &mon_sold;
run;
%end;

%mend salemon;

%salemon



* Using a Macro Program to Execute the Same PROC Step on Multiple Data Sets;
%macro sales;
%do mon=7 %to 9;
proc means data=books.sold&mon;
title "Sales Information for &mon";
class section;
var listprice saleprice;
run;
%end;
%mend sales;
%sales


* Defining and Using Macro Variables;

%let repmonth=4;
%let repyear=2007;
%let repmword=%sysfunc(mdy(&repmonth,1,&repyear),monname9.);

data temp;
set books.ytdsales;
mosale=month(datesold);
label mosale='Month of Sale';
run;

proc tabulate data=temp;
title "Sales During &repmword &repyear";
where mosale=&repmonth and year(datesold)=&repyear;
class section;
var saleprice listprice cost;
tables section all='**TOTAL**',
(saleprice listprice cost)*(n*f=4. sum*f=dollar10.2);
run;


*Displaying System Information;
title "Sales Report";
title2 "As of &systime &sysday &sysdate";
title3 "Using SAS Version: &sysver";
proc means data=books.ytdsales n sum;
var saleprice;
run;

* Conditional Processing of SAS Steps;
%macro daily;
proc means data=books.ytdsales(where=(datesold=today()))
maxdec=2 sum;
title "Daily Sales Report for &sysdate";
class section;
var saleprice;
run;
%if &sysday=Friday %then %do;
proc means data=books.ytdsales
(where=(today()-6 le datesold le today()))
sum maxdec=2;
title "Weekly Sales Report Week Ending &sysdate";
class section;
var saleprice;
run;
%end;
%mend daily;
%daily




*SYMGET(‘macro_variable_nmae’)
Used to get value of macro variable in data step.;

%LET ok=yes;
DATA example_1a ;
LENGTH check2 $5;
check1 = SYMGET('ok') ;
check2 = SYMGET('ok') ;
check3 = "&ok";
check4 = SYMGET('ok') ;
LENGTH check4 $3 ;
RUN;

*PROC DATASETS is a data set management tool.;

data temp;
set db.agents;
run;


proc datasets;
quit;
run;

* If a library is not specified, the default is for SAS to look at the WORK library.;

libname db "D:\SAS\SAS DATASETS\SAS DATASETS\Sas datasets\Prog1";
proc datasets lib=db;
quit;
run;

* The results of the above statements are displayed in the LOG window, not in the OUTPUT window. A list containing 
all of the SAS data sets and SAS catalogs that reside in the specified library is displayed in the LOG window. 
This is similar to the PROC CONTENTS procedure.;

* DETERMING CONTENTS OF LIBRARY;
proc datasets lib=db;
quit;
run;

proc contents data=db._all_ nods;
run;

* The above two statements generate exactly the same results, although the DATASETS output goes to the LOG window 
and the CONTENTS output goes to the output window.;

* If more information is needed about each data set within a library (e.g. individual variable attributes);
proc datasets lib=db;
contents data=agents;
quit;
run;

proc contents data=db.agents;
run;


* Copy the contents from one library to other library;

proc datasets nolist;
copy in=db out=work;
/*exclude ;*/
/*select ;*/
quit;
run;


* RENAMING DATA SETS/CATALOGS;
proc datasets lib=db nolist;
change agents = agent;
quit;
run;

* DELETING DATA SETS/CATALOGS;
proc datasets lib=work nolist;
delete adverse summary;
quit;
run;
* to kill all the datassets;
* This only deletes the specified files on the DELETE command. In order to delete all members within a library, 
use the KILL option on the DATASETS statement. Although other SAS procedures have the option of using an _ALL_ 
option, the DELETE statement within PROC DATASETS does not allow this option.;

proc datasets lib=work
nolist kill;
quit;
run;

* MODIFYING DATA SETS/VARIABLES;
*using the Data Step:;
data db.agent(label= 'Adverse Events');
set db.agent;
run;

*Using the DATASETS procedure:;
proc datasets lib=db nolist;
modify agent (label='Adverse Events');
quit;
run;

* within the dataset;
proc datasets lib=db nolist;
modify adverse;
label pat = 'Subject Number'
inv = 'Site Number';
quit;
run;

proc datasets lib=db nolist;
modify adverse;
rename inv=site pat=subj;
format todate visdate
fromdate mmddyy10.;
informat todate visdate
fromdate mmddyy10.;
quit;
run;




DATA WITHOUT_1;
PUT "Before the INPUT statement: " _ALL_;
INPUT X @@;
PUT "After the INPUT statement: " _ALL_ /;
DATALINES;
1 2 . 3
;

DATA WITH_1;
RETAIN X;
PUT "Before the INPUT statement: " _ALL_;
INPUT X @@;
PUT "After the INPUT statement: " _ALL_ /;
DATALINES;
1 2 . 3
;
run;

DATA WITHOUT_2;
PUT "Before INPUT: " _ALL_ ;
INPUT X @@;
IF X NE . THEN OLD_X = X;
ELSE X = OLD_X;
PUT "After assignment: " _ALL_ /;
DATALINES;
1 2 . 3
;

DATA WITH_2;
RETAIN OLD_X;
PUT "Before INPUT: " _ALL_ ;
INPUT X @@;
IF X NE . THEN OLD_X = X;
ELSE X = OLD_X;
PUT "After assignment: " _ALL_ /;
DATALINES;
1 2 . 3
;

DATA WITHOUT_4;
PUT "Before the INPUT statement: " _ALL_ ;
INPUT X @@;
SUBJECT + 1; /* SUM statement */
PUT "After the INPUT statement: " _ALL_ /;
DATALINES;
1 3 5
;

DATA WITHOUT_4;
retain subject;
PUT "Before the INPUT statement: " _ALL_ ;
INPUT X @@;
SUBJECT + 1; /* SUM statement */
PUT "After the INPUT statement: " _ALL_ /;
DATALINES;
1 3 5
;


PROC FORMAT;
VALUE $DXCODE '1' = 'Routine Visit'
'2' = 'Cold'
'3' = 'Flu'
'4' = 'Ear Infection'
'5' = 'Heart Problem'
'6' = 'Abdominal Pain'
'7' = 'Fracture'
'8' = 'Breathing Problem'
'9' = 'Laceration';
VALUE $YESNO '0' = 'No'
'1' = 'Yes';
RUN;
DATA CLINICAL;
INPUT @1 PATIENT $3.
@4 VISIT_DATE MMDDYY8.
@12 GENDER $1.
@13 STATE $2.
@15 HR 3.
@18 SBP 3.
@21 DBP 3.
@24 (DX1-DX3) ($1.)
@27 VITAMINS $1.;
FORMAT VISIT_DATE DATE9.
DX1-DX3 $DXCODE.
VITAMINS $YESNO.;
LABEL PATIENT = "Patient Number"
VISIT_DATE = "Visit Date"
HR = "Heart Rate"
SBP = "Systolic Blood Pressure"
DBP = "Diastolic Blood Pressure"
VITAMINS = "Is PT Taking Vitamins?";
DATALINES;
00110211998MNJ 68130 801 0
00111111998MNJ 66132 782 0
00101051999MNJ 70140 8824 0
00205061999FNJ 781901004 1
00303042000FNJ 58108 662 1
00305122000FNJ 60110 682 1
00410301999MNY 8820011079 0
00412121999MNY 1021 1
00408082000MNY 90180 982 1
00505052000FNY 48110 6658 1
00608082000FNY 861841021 1
00610102000FNY 86 1001 0
00712122000FNY 805681
;
PROC SORT DATA=CLINICAL;
BY PATIENT;
RUN;

data new;
set clinical;
by patient;

first = first.patient;
last= last.patient;

keep patient first last;
run;
