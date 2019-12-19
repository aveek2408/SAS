libname airline 'E:\Documents\SAS\SAS DATASETS\SAS DATASETS\Sas datasets\Prog1';
*****************************************************************
						Combining Sas Datasets
-----------------------------------------------------------------
- Concatenation
- Interleaving
- One to One Reading
- One to One Merging
- Match Merging
	Types	
	* One to One
	* One to Many / Many to One
	* Many to Many
- Update
- Modify
*****************************************************************;
***********************************************************************
Concatenation - Reading observations from multiple input datasets to 
one output dataset in the order in which it is defined in the SET 
Statement . Define Multiple datasets on set statement in the order in
which it has to be read.
-------------------------------------------------------------------------
Note: Datasets with variying structures can be concatenated alternatively
using APPEND PROCEDURE
**************************************************************************;
* In the below example the data structures differ (Month/Mth);
data jansales;
	length year $7 month $3;
	infile datalines ;
	input year $ month $ saleamt;
	datalines;
	1999 Jan 25000
	2000 Jan 30000
	;
run;

data febsales;
	length year $7 mth $3;
	infile datalines ;
	input year $ mth $ saleamt;
	datalines;
	1999 Feb 55000
	2000 Feb 35000
	;
run;

* Before renaming mth to month ;
data  work.salesdata;
	set jansales febsales;
run;

* Rename the existing variable to a new variable name (not label);
* Rename as a dataset option
	rename=(Existingvarname = NewVarName) ;
* Rename option on input dataset is valid, renames before reading to 
  output dataset ;
data  febsales1(rename=(mth=month));
	set febsales;
run;

* Rename as a statement
	rename existingvarname = newvarname ;
data work.febsales1;
	set febsales ;
	rename mth = month;
run;

* Note: Rename as a statement applies only on output dataset
        Rename a a dataset option can be specified on both input and output
        dataset ;

* Concatenate after renaming mth to month on febsales1;
data work.salesdata;
	set jansales febsales1;
run;

* The dataset adjacent to set statement(jansales) is the basic structure to 
  the output dataset(monthlysales);
* The data is not sorted;

***********************************************************************
Interleaving - is similar to concatenation but in interleaving the data
is sorted on the key variable specified in BY Statement;
***********************************************************************;
data work.salesdata;
	set jansales febsales1;
	by year;
run;

data  employees;
	set airline.miamiemp airline.romeemp airline.parisemp;
	by id;
run;

* to udnerstand difference between concatenation and merging;
data sample; 
	set airline.goals airline.performance;
run;

data sample1; 
	set airline.goals airline.performance;
	by month;
run;


/*******************************************************************
		CONCATENATION EXAMPLES - When VARIABLE ATTRIBUTE CHANGES 
*******************************************************************/

data HydEmp;
	infile cards ;
	format Doj date7.;
	input Empid $ 1-4 EmpName $6-14 @17 Doj date7. Salary Phone $;
	cards;
1001 Ram       01mar89 22000 040-2780
	;
run;

data MumEmp;
	infile cards ;
	format Doj date7.;
	input Empid $ 1-4 EmpName $6-14 @17 Doj date7. Salary Phone $;
	cards;
1004 Das       05Feb90 22000 050-9383
	;
run;

* Compare procedure compares the total dataset structure ;
proc compare base = hydemp compare=mumemp;
run;

* Concatenate Hyd and Mum Employees;
data  hydmumemp;
	set hydemp mumemp;
run;

data DelEmp;
	infile cards ;
	input Empid $ 1-4 EmpName $6-14 @17 Doj date7. Salary Sex $ 30 ;
	format Doj date7.;
	cards;
1007 Das       11Feb99 22023 M
	;
run;

proc compare base = hydmumemp compare=delemp;
run;

* Output dataset(HydMumDelEmp) has the same variable structure as the first 
input dataset 
        defined on the set statement(HydEmp);
* If the variable in not found on the input datasets, then the variable 
  is added to the output dataset but it has missing values for the 
  variable that is not output from input dataset;

* Concatenate to HydMumEmp with DelEmp;
data hydmumdelemp;
	set hydmumemp delemp;
run;

data BlrEmp;
	infile cards ;
	input Empid 1-4 EmpName $6-14 @17 Doj date7. Salary Sex $ 30 ;
	format Doj date7.;
	cards;
1010 Ambedkar  21Mar91 43000 F
1011 Mithun    23Dec93 75000 F
1012 Badrinath 19Nov97 91300 F
	;
run;

data  blremp1;
	set blremp;
	empid = put(empid,4.);
run;

proc compare base = hydmumdelemp compare=blremp;
run;

* Concatenate to HydMumDelEmp with BlrEmp;
data hydmumdelemp;
	set hydmumdelemp blremp;
run;

* The EMPID in BLRemp dataset is numeric, convert to char variable 
  as defined on HYDMUMDELemp dataset ;

/*  8n      4c*/
/*newvar   empid*/
/*   1001  1001*/

* Concatenate to HydMumDelEmp with BlrEmp1 after changing data type;
data hydmumdelemp;
	set hydmumdelemp blremp1;
run;


******************************************************************
					Merging of datasets (horizontally)
							Merging
******************************************************************;
Data One;
	infile datalines ;
	input Studid $ StudName $;
datalines;
S101 Ram 
S102 Mahesh
S103 Rakesh
;
run;

Data Two;
	infile datalines;
	input studid $ Maths Science Social;
datalines;
S101 55 65 75
S102 65 95 75
S104 55 65 75
S105 75 85 95
;
run;


/****************************************************************
			ONE to ONE READING and ONE to ONE MERGING
------------------------------------------------------------------------
ONE to ONE READING - One-to-one reading combines observations from 
two or more SAS data sets by creating observations that contain all 
of the variables from each contributing data set. Observations are 
combined based on their relative position(obs no) in each data set, that is,
the first observation in one data set with the first in the other, 
and so on. The DATA step stops after it has read the last observation 
from the smallest data set

Example: One to One Reading
Data Combined;
	Set Data1;
	Set Data2;
run;

ONE to ONE Merging - is similar to a one-to-one reading, with two 
exceptions: you use the MERGE statement instead of multiple SET 
statements, and the DATA step reads all observations from all data 
sets

* Merging wihtout key variable which generates undesirable results
  when the key vairable values are not matching since it also reads
  with the obs number

Data Combined;
	Merge Data1 Data2;
run;
****************************************************************/
* One to ONe Reading ;
data  onetoonereading;
	set one;
	set two;
run;


* One to One Merging wihtout key variable ;
* One to One Merging without key variable has advantage over ONe to One 
  Reading, wherein it reads all the osbervations ;

data onetoonemerge;
	merge one two;
run;



/****************************************************************
							MATCH MERGING
Match-merging combines observations from two or more SAS data sets 
into a single observation in a new data set based on the values of 
one or more common variables

Data Combined;
	Merge Data1 Data2;
	by Keyvariable/s;
run;

- when match merging is specified on the key variable in BY Statment
  the pre-req is to sort the data on key variable ;
****************************************************************/

data  work.matchmerge;
	merge one two;
	by studid; * pre-req is to sort data using proc sort;
run;

*************************************************************************
			The FOUR WAYS THE DATA CAN BE REALTED USING MERGE
-Based on the common variable values define whether it is one or 
 many join
- Pre req is to sort the data on the key variable specified on
  BY Statement
*************************************************************************;
* always sort on key variable;
data onetoonemerge; 
	merge airline.goals airline.performance;
	by month;
	difference = sales-goal;
run;


data onetomanymerge; 
	merge airline.allgoals airline.allsales;
	by month;
	difference = sales-goal;
run;

data manytomanymerge; 
	merge airline.allgoals2 airline.allsales2;
	by month;
	difference = sales-goal;
run;

****************************************************************************
	Finding which observation is contributing while merging the data
----------------------------------------------------------------------------
* Create activtrans, inactivtrans, branches datasets based on the 
  common variable value 
	If actnum exists in both transaction and branches table then it is activtrans
    If actnum exists in trans but not in branches then it is no branches
    if actnum exists in branches but not in transaction then it inactivtrans
* use IN = <tempvar> dataset option on each input dataset in merge statement to
  find which observation is contributing
	=1 then the value exists otherwise the same value does not exist which
       is = 0
****************************************************************************;
data  activtrans inactivtrans nobranches;
	merge airline.transact(in = intrans)
           airline.branches(in = inbrans);
	by actnum;
	if intrans=1 and inbrans=1 then output activtrans;
	else if intrans=1 and inbrans=0 then output nobranches;
	else if intrans=0 and inbrans=1 then output inactivtrans;
run;
* if intrans and not inbrans;

/* Find which observation is contributing from the corresponding dataset ;
1 - if actnum exists
0 - if actnum does not exist 

ActNum   Intrans        Inbrans	  OutputDaaset
-------------------------------------------------
56891       1              1      Activtrans
56900       0              1      Inactivtrans
57900       1              0      Nobranches  */
           

/***********************************************************************
						UPDATING & MODIFYING
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Find Below Differences between update and modify

Transaction dataset -----------Update ---------> Master ----> Reports
C101  Secbad                                     C101 Hyd

------------------------------------------------------------------------

- Updating uses information from observations in a transaction data 
  set to delete, add, or alter information in observations in a master 
  data set. You can update a master data set by using the UPDATE 
  statement or the MODIFY statement. 


- If you use the UPDATE statement, your input data sets must be sorted 
  by the values of the variables listed in the BY statement. (In this 
  example, MASTER and TRANSACTION are both sorted by Year.) 

- If you use the MODIFY statement, your input data does not need to 
  be sorted. 

- UPDATE replaces an existing file with a new file, allowing you to 
  add, delete, or rename columns. 

- MODIFY performs an update in place by rewriting only those records 
  that have changed, or by appending new records to the end of the file.

- The MODIFY statement can save disk space because it modifies data in 
  place, without creating a copy of the data set
------------------------------------------------------------------------
Note that by default, UPDATE and MODIFY do not replace nonmissing values 
in a master data set with missing values from a transaction data set
------------------------------------------------------------------------

*************************************************************************/
data master;
	UPDATE master-data-set<(data-set-options)> 
           transaction-data-set<(data-set-options)>  <END=variable>  
 			<UPDATEMODE= MISSINGCHECK|NOMISSINGCHECK>;  
 BY by-variable;  
run;

data Master;
	infile datalines ;
	input Custid $1-4 CustName $6-19 Country $21-25 City $27-36 StrAdd $38-65;
datalines;
C103 Karthis.M.     USA   New Jersey Mc.Donals Road, L1254
C101 Ram.K.         India Hyderabad  Ameerpet, 10-2-238/M
C102 Maheshwaran.P. India Mumbai     M.G.Road, Phase II, Block-II
;
run;

* Only changes to the existing data and new employees data exists, update
  mastrer from transaction dataset ;
data Transaction;
	infile datalines ;
	input Custid $1-4 CustName $6-19 Country $21-25 City $27-36 StrAdd $38-65;
datalines;
C102                                 Panvel, Sixth Phase
C104 Ashok.M.       UK    London     L2145, Pretorious Rd
C105 Charles        USA   Wisconsin  Blueberry Strt, L125 
C101 Ramky.P.
C103                UAE   Abdul Strt 2nd Street
C103                UAE   Abdul Strt St.Martin Road
;
run;


proc sort data = master out=mas_sort;
	by custid;
run;

proc sort data = transaction out = tran_sort;
	by custid;
run;

data  work.master;
	update mas_sort tran_sort;
	by custid;
run;

/*************************************************************************
					MISSINGCHECK / NOMISSINGCHECK Options
--------------------------------------------------------------------------
- The MISSINGCHECK value in the UPDATEMODE option prevents missing values
  in a transaction data set from replacing values in a master data set. 
  This is the default.
- The NOMISSINGCHECK value in the UPDATEMODE option enables missing values
  in a transaction data set to replace values in a master data set by 
  preventing the check for missing data from being performed.
*************************************************************************/
data  work.master1;
	update mas_sort tran_sort updatemode=nomissingcheck;
	by custid;
run;

***************************************************************************
								MISSING STATEMENT
Assigns characters(a-z) in your input data to represent special missing values 
for numeric data. 

Special missing values can be any of the 26 letters of the alphabet 
(uppercase or lowercase) or the underscore (_).
***************************************************************************;
data empdata;
   missing a r;
   input empid Salary;
   datalines;
001 20000
002 R
003 10000
004 A
005 25000
;
run;

proc sort data = empdata;
	by salary;
run;

data testmissing;
	set empdata;
	bonus = .10*salary;
run;

***************************************************************************
						Updating with Missing Values
---------------------------------------------------------------------------
If you want the resulting value in the master data set to be a regular 
missing value(period), use a single underscore (_) to represent missing values in 
the transaction data set. The resulting value in the master data set will be 
a period (.) for missing numeric values and a blank for missing character 
values
***************************************************************************;
* Create a master dataset ;
data payroll;
   input ID SALARY;
   datalines;
011 245
026 269
028 374
034 333
057 582
;
run;

/* Create the Transaction Data Set */
data increase;
   input ID SALARY;
   missing A _;
   datalines;
011 376
026 .
028 374
034 A
057 _
;
run;

   /* Update Master with Transaction */
data newpay;
   update payroll increase;
   by id;
run;

*****************************************************************************
MODIFY is similar to UPDATE
	in modify need not sort the data on keyvariable (internally sorts)
    in modify the output master dataset name should be the same as master
     dataset name on modify statement
-----------------------------------------------------------------------------
Checking for Program Errors 
-----------------------------------------------------------------------------
You can use the _IORC_ automatic variable for error checking in your DATA step 
program. The _IORC_ automatic variable contains the return code for each I/O 
operation that the MODIFY statement attempts to perform. 

The best way to test the values of _IORC_ is with the mnemonic codes that 
are provided by the SYSRC autocall macro. Each mnemonic code describes one 
condition. The mnemonics provide an easy method for testing problems in a 
DATA step program. The following is a partial list of codes:

_DSENMR 
specifies that the transaction data set observation does not exist in 
the master data set (used only with MODIFY and BY statements). If 
consecutive observations with different BY values do not find a match in 
the master data set, then both of them return _DSENMR.

_SOK 
specifies that the observation was located in the master data set.

-----------------------------------------------------------------------------
Adding New Observations to Master Dataset from Transaction Datset
-----------------------------------------------------------------------------
You can use the MODIFY statement to add observations to an existing master data 
set. If the transaction data set contains an observation that does not match 
an observation in the master data set, then SAS enables you to write a 
new observation to the master data set if you use an explicit OUTPUT statement 
in your program
-----------------------------------------------------------------------------
REPLACE statement if you want to replace observations in place
-----------------------------------------------------------------------------
_ERROR_ = 0 to prevent displaying the non-match record in the sas log window
-----------------------------------------------------------------------------

*****************************************************************************;
data  master;
	modify master transcation;	
	by keyvar;
run;

* Mdofiy example without sorting;


data  master;
	modify master transaction ;	
	by custid;
	if _iorc_ = %sysrc(_sok) then replace;
	else if _iorc_ = %sysrc(_dsenmr) then do;
		output;
		_error_ = 0 ;
	end;
run;

















