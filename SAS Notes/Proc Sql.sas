
/*  Basic Building Blocks */
DATA preteen;
	SET sashelp.class;
	WHERE age<13;
	LABEL  name = 'First Name';
	RENAME name = FName;
	FORMAT height weight 5.1;
RUN;

/* The Simplest SELECT Statement */
PROC SQL;
	SELECT       *                                                                  
		FROM         preteen                                                            
	;
QUIT;

PROC PRINT DATA=preteen;
RUN;

PROC PRINT NOOBS LABEL DATA=preteen;
RUN;

/* A More Selective SELECT */
PROC PRINT NOOBS LABEL DATA=preteen;
	VAR fname age;
RUN;

PROC SQL;
	SELECT       fname, age                                                         
		FROM         preteen                                                            
	;
QUIT;

/*  Storing Results */
DATA new;
	SET preteen;
RUN;

PROC SQL;
	CREATE TABLE new AS                                                             
		SELECT       *                                                                  
			FROM         preteen                                                            
	;
QUIT;

/* Column Subsets */
DATA subset;
	SET preteen;
	KEEP fname sex age;
RUN;

PROC SQL;
	CREATE TABLE subset AS                                                          
		SELECT       fname, sex, age                                                    
			FROM         preteen                                                            
	;
QUIT;

DATA subset;
	SET preteen;
	DROP height weight;
RUN;

PROC SQL;
	CREATE TABLE subset(DROP=height weight) AS                                      
		SELECT       *                                                                  
			FROM         preteen                                                            
	;
QUIT;

/*  New Columns */
DATA ratios;
	SET preteen;
	ATTRIB Ratio FORMAT=5.2 LABEL='Weight:Height Ratio';
	ratio = weight / height;
RUN;

PROC SQL;
	CREATE TABLE ratios AS                                                          
		SELECT       *,                                                                 
			weight / height AS Ratio                                           
			FORMAT=5.2 LABEL='Weight:Height Ratio'                            
		FROM         preteen                                                            
	;
QUIT;

/*  Aggregation */
PROC SUMMARY DATA=preteen;
	VAR age height weight;
	OUTPUT OUT=overall_averages(DROP = _type_ _freq_)                               
		MIN (age   )=Youngest                                                          
		MAX (age   )=Oldest                                                            
		MEAN(height)=Avg_Height                                                        
		MEAN(weight)=Avg_Weight;
RUN;

PROC SQL;
	CREATE TABLE overall_averages AS                                                
		SELECT       MIN (age)    AS Youngest,                                          
			MAX (age)    AS Oldest,                                            
			MEAN(height) AS Avg_Height FORMAT=5.1,                             
			MEAN(weight) AS Avg_Weight FORMAT=5.1                              
		FROM         preteen                                                            
	;
QUIT;

PROC SUMMARY DATA=preteen NWAY;
	CLASS sex;
	VAR age height weight;
	OUTPUT OUT=group_averages(DROP = _type_ _freq_)                                 
		MIN (age   )=Youngest                                                          
		MAX (age   )=Oldest                                                            
		MEAN(height)=Avg_Height                                                        
		MEAN(weight)=Avg_Weight;
RUN;

PROC SQL;
	CREATE TABLE group_averages AS                                                  
		SELECT       sex,                                                               
			MIN (age)    AS Youngest,                                          
			MAX (age)    AS Oldest,                                            
			MEAN(height) AS Avg_Height FORMAT=5.1,                             
			MEAN(weight) AS Avg_Weight FORMAT=5.1                              
		FROM         preteen                                                            
			GROUP BY     sex                                                                
	;
QUIT;

DATA threex3;
	INPUT a b c;
	CARDS;
1.1 2.0 3.0                                                                     
6.0 5.0 4.4                                                                     
7.7 8.0 9.0                                                                     
;

PROC SQL;
	SELECT       MEAN(a,b,c) LABEL='Mean of 3'                                      
		FROM         threex3                                                            
	;
QUIT;

PROC SQL;
	SELECT       MEDIAN(a,b,c) LABEL='Median of 3'                                  
		FROM         threex3                                                            
	;
QUIT;

PROC SQL;
	SELECT       MEAN(a) LABEL='Mean of 1'                                          
		FROM         threex3                                                            
	;
QUIT;

PROC SQL;
	SELECT       MEDIAN(a) LABEL='Median of 1'                                      
		FROM         threex3                                                            
	;
QUIT;

/* Conditionality */
DATA trip_list;
	SET preteen;

	IF      age=11 THEN
		Trip = 'Zoo   ';
	ELSE IF sex='F' THEN
		trip = 'Museum';
	ELSE                 trip = '[None]';
	KEEP fname age sex trip;
RUN;

PROC SQL;
	CREATE TABLE trip_list AS                                                       
		SELECT       fname,                                                             
			age,                                                               
			sex,                                                               
		CASE 
			WHEN age=11  THEN 'Zoo'                                       
			WHEN sex='F' THEN 'Museum'                                    
			ELSE              '[None]'                                    
		END                                                           
	AS Trip                                                           
		FROM         preteen                                                            
	;
QUIT;

DATA trip_list;
	SET preteen;
	SELECT;
		WHEN (age=11)  Trip = 'Zoo   ';
		WHEN (sex='F') trip = 'Museum';
		OTHERWISE      trip = '[None]';
	END;

	KEEP fname age sex trip;
RUN;

/*  Filtering */
DATA girls;
	SET preteen;
	WHERE sex='F';
RUN;

PROC SQL;
	CREATE TABLE girls AS                                                           
		SELECT       *                                                                  
			FROM         preteen                                                            
				WHERE        sex='F'                                                            
	;
QUIT;

PROC SQL;
	SELECT       *                                                                  
		FROM         preteen                                                            
			WHERE        age=10                                                             
	;
QUIT;

PROC SQL;
	CREATE TABLE tens AS                                                            
		SELECT       *                                                                  
			FROM         preteen                                                            
				WHERE        age=10                                                             
	;
QUIT;

PROC SUMMARY DATA=preteen NWAY;
	CLASS sex age;
	OUTPUT MAX(height)=Tallest MIN(height)=Shortest                                 
		OUT= hilo(DROP = _type_ _freq_);
RUN;

PROC SQL;
	CREATE TABLE hilo AS                                                            
		SELECT       sex,                                                               
			age,                                                               
			MAX(height) AS Tallest,                                            
			MIN(height) AS Shortest                                            
		FROM         preteen                                                            
			GROUP BY     sex, age                                                           
	;
QUIT;

PROC SUMMARY DATA=preteen NWAY;
	CLASS sex age;
	OUTPUT MAX(height)=Tallest MIN(height)=Shortest                                 
		OUT=hilo(WHERE = (tallest - shortest > 4)                                      
		DROP = _type_ _freq_ );
RUN;

PROC SQL;
	CREATE TABLE hilo AS                                                            
		SELECT       sex,                                                               
			age,                                                               
			MAX(height) AS Tallest,                                            
			MIN(height) AS Shortest                                            
		FROM         preteen                                                            
			GROUP BY     sex, age                                                           
				HAVING       tallest - shortest > 4                                             
	;
QUIT;

/* Reordering Rows */
PROC SORT DATA=preteen OUT=age_sort;
	BY DESCENDING age fname;
RUN;

PROC SQL;
	CREATE TABLE age_sort AS                                                        
		SELECT       *                                                                  
			FROM         preteen                                                            
				ORDER BY     age DESCENDING, fname                                              
	;
QUIT;

/*  Elimination of Duplicates */
PROC SQL;
	CREATE TABLE sex_age AS                                                         
		SELECT sex, age                                                                 
			FROM   preteen                                                                  
	;
QUIT;

PROC SORT DATA=sex_age OUT=sex_age_distinct NODUPRECS;
	BY _ALL_;
RUN;

PROC SQL;
	CREATE TABLE sex_age_distinct AS                                                
		SELECT       DISTINCT *                                                         
			FROM         sex_age                                                            
	;
QUIT;

/* The Simplest Merges and Joins */



DATA one;                                                                       
DO Value1 = 11,12;                                                              
   OUTPUT;                                                                      
   END;                                                                         
RUN;                                                                            
                                                                                
DATA two;                                                                       
DO Value2 = 21,22,23;                                                           
   OUTPUT;                                                                      
   END;                                                                         
RUN;                                                                            
                                                                                
DATA combined;                                                                  
MERGE one two;                                                                  
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined AS                                                        
SELECT       *                                                                  
FROM         one CROSS JOIN two                                                 
;                                                                               
QUIT;                                                                           


/*  Matching with Nonrepeating Keys */



DATA u1;                                                                        
INPUT Key $ Value1;                                                             
CARDS;                                                                          
A 11                                                                            
B 12                                                                            
;                                                                               
                                                                                
DATA u2;                                                                        
INPUT Key $ Value2;                                                             
CARDS;                                                                          
C 23                                                                            
A 21                                                                            
;                                                                               
                                                                                
PROC SORT DATA=u1 OUT=sorted1;                                                  
BY key;                                                                         
RUN;                                                                            
PROC SORT DATA=u2 OUT=sorted2;                                                  
BY key;                                                                         
RUN;                                                                            
                                                                                
DATA combined;                                                                  
MERGE sorted1 sorted2;                                                          
BY key;                                                                         
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
SELECT       *                                                                  
FROM         u1 FULL JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT       COALESCE(u1.key , u2.key) AS Key,                                  
             *                                                                  
FROM         u1 FULL JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined AS                                                        
SELECT       COALESCE(u1.key , u2.key) AS Key,                                  
             *                                                                  
FROM         u1 FULL JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined AS                                                        
SELECT       COALESCE(u1.key , u2.key) AS Key,                                  
             value1,                                                            
             value2                                                             
FROM         u1 FULL JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT       *                                                                  
FROM         u1 LEFT JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined_left AS                                                   
SELECT       u1.*,                                                              
             value2                                                             
FROM         u1 LEFT JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
DATA combined_left;                                                             
MERGE sorted1(IN=in1) sorted2;                                                  
BY key;                                                                         
IF in1;                                                                         
RUN;                                                                            
                                                                                
DATA combined_right;                                                            
MERGE sorted1 sorted2(IN=in2);                                                  
BY key;                                                                         
IF in2;                                                                         
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined_right AS                                                  
SELECT       u2.key,                                                            
             value1,                                                            
             value2                                                             
FROM         u1 RIGHT JOIN u2                                                   
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT       *                                                                  
FROM         u1 INNER JOIN u2                                                   
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE combined_inner AS                                                  
SELECT       u1.*,                                                              
             value2                                                             
FROM         u1 INNER JOIN u2                                                   
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
DATA combined_inner;                                                            
MERGE sorted1(IN=in1) sorted2(IN=in2);                                          
BY key;                                                                         
IF in1 AND in2;                                                                 
RUN;                                                                            


/* Matching with Repeating Keys */



DATA m1;                                                                        
INPUT Key $ Value1;                                                             
CARDS;                                                                          
A 11.1                                                                          
A 11.2                                                                          
B 12.1                                                                          
B 12.2                                                                          
;                                                                               
                                                                                
DATA m2;                                                                        
INPUT Key $ Value2;                                                             
CARDS;                                                                          
A 21.1                                                                          
A 21.2                                                                          
A 21.3                                                                          
C 23.1                                                                          
C 23.2                                                                          
;                                                                               
                                                                                
DATA many_inner;                                                                
MERGE m1(IN=in1) m2(IN=in2);                                                    
BY key;                                                                         
IF in1 and in2;                                                                 
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
SELECT       *                                                                  
FROM         m1 INNER JOIN m2                                                   
ON           m1.key = m2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE many_inner AS                                                      
SELECT       m1.*,                                                              
             value2                                                             
FROM         m1 INNER JOIN m2                                                   
ON           m1.key = m2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
DATA one_many_inner;                                                            
MERGE u1(IN=in1) m2(IN=in2);                                                    
BY key;                                                                         
IF in1 AND in2;                                                                 
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
CREATE TABLE one_many_inner AS                                                  
SELECT       u1.*,                                                              
             value2                                                             
FROM         u1 INNER JOIN m2                                                   
ON           u1.key = m2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
CREATE TABLE one_many_outer AS                                                  
SELECT       coalesce(u1.key, m2.key) AS Key,                                   
             value1,                                                            
             value2                                                             
FROM         u1 FULL JOIN m2                                                    
ON           u1.key = m2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
DATA one_many_outer;                                                            
MERGE u1 m2;                                                                    
BY key;                                                                         
RUN;                                                                            


/* More about Joins and Merges */



DATA from3;                                                                     
MERGE sorted1 m1(RENAME=(value1=Tenths) ) sorted2;                              
BY key;                                                                         
RUN;                                                                            
                                                                                
PROC SQL;                                                                       
CREATE TABLE sql_from3 AS                                                       
SELECT u1.*,                                                                    
       m1.value1 as Tenths,                                                     
       u2.value2                                                                
FROM   (u1 JOIN m1 ON u1.key=m1.key)                                            
           JOIN u2 ON u1.key=u2.key                                             
;                                                                               
QUIT;                                                                           


/*  More about Joins */



PROC SQL;                                                                       
SELECT       COALESCE(u1.key , u2.key) AS Key,                                  
             value1,                                                            
             value2                                                             
FROM         u1 FULL JOIN u2                                                    
ON           u1.key = u2.key                                                    
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT       *                                                                  
FROM         u2 NATURAL FULL JOIN u1                                            
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT u1.*,                                                                    
       m1.value1 as Tenths,                                                     
       u2.value2                                                                
FROM   (u1 JOIN m1 ON u1.key=m1.key)                                            
           JOIN u2 ON u1.key=u2.key                                             
;                                                                               
QUIT;                                                                           
                                                                                
PROC SQL;                                                                       
SELECT u1.*,                                                                    
       m1.value1 as Tenths,                                                     
       u2.value2                                                                
FROM   u1,  m1,  u2                                                             
WHERE  u1.key=m1.key AND u1.key=u2.key                                          
;                                                                               
QUIT;                                                                           


/*SAS SQL View*/


/*Creating view from a query expression/Result */

data class;
set sashelp.class;
run;

Proc SQL;
Create View work.Class12 As Select Name,Age,Height From class Where Age=12;
Insert into work.Class12 values("ABC",12,55);
Insert into work.Class12 values("PQR",13,76);
Insert into work.Class values("XYZ","F",12,50,66);
Create View work.Plfips As Select * From sashelp.Plfips;
Describe View work.Plfips;
Quit;

Proc contents data = work.class12;
Run;

Proc Means data = work.Plfips;
Run;


* INDEX;

/*It is used to locate the rows quickly and more effictively
An index is an auxiliary file that stores the physical location of values for one or more specified columns (key columns) 
in a table. 
In an index, each unique value of the key column(s) is paired with a location identifier for the row that contains that value. 

Simple and Composite Indexes

You can create two types of indexes:
A simple index is based on one column that you specify. 
The indexed column can be either character or numeric. 
When you create a simple index by using PROC SQL, you must specify the name of the indexed column as the name of the index.

A composite index is based on two or more columns that you specify. 
The indexed columns can be character, numeric, or a combination of both. 
In the index, the values of the key columns are concatenated to form a single value.

Unique Indexes

If you want to require that values for the key column(s) are unique for each row, you can create either 
a simple or a composite index as a unique index. 
Once a unique index is defined on one or more columns in a table, SAS will reject any change to the table that would cause 
more than one row to have the same value(s) for the specified column or composite group of columns.
*/

PROC SQL;
 
       CREATE <UNIQUE> INDEX index-name
              ON table-name (column-name-1<, ...column-name-n>);
 
       DESCRIBE TABLE table-name-1<, ... table-name-n>;
 
       SELECT column-1<, . . . column-n>
              FROM table-1 (IDXWHERE=Y | N)
              <WHERE expression>;
 
       SELECT column-1<, . . . column-n>
              FROM table-1 (IDXNAME=index-name)
              <WHERE expression>;
 
       DROP INDEX table-name-1<, ... table-name-n>;
              FROM table-name;
 
QUIT;



proc sort data = sashelp.Plfips Out = Test;
By State;/* try running before creating index */
run;

proc print data = Test;
where State = "AL";/* try running before creating index */
run;

/*Simple Index*/
*Create Index Ind_Name On Table;

Data Plfips;
Set sashelp.Plfips;
Run;

Data Class;
Set sashelp.Class;
Run;

Proc SQL;
Create Index Age On work.Class;
Create Index State On Plfips;
Quit;

proc print data = Plfips;;
where State = "AL";/* try running after creating index */
run;

Proc contents data = work.Class;
Run;

Proc contents data = work.Plfips;
Run;

Proc SQL;
*Create Unique Index age_gend On work.class(Sex,Age);
Create Index Age On work.Class; /*Simple*/
Create Index age_gend On work.class(Sex,Age); /*Composite*/
Quit;

data abc2;
set work.class;
where sex = "M" and Age = 12;
run;


/*Drop Stmt*/

Proc Sql;

Drop Table Age12,mylib.Class,abc2;
Drop View Class12;
Drop Index Age,Age_Gend from Class;

Quit;


/*Delete From stmt*/

Proc Sql;

Delete from class Where sex = "M" and age = 12;
Delete from class ; /* Deletes all records */

Quit;

data class;
set sashelp.class;
if Age = 12 then delete;
run;

Proc datasets;
delete class mylib.buy; /*Deletes the datasets from a library */
Quit;

Proc SQL Noprint; /* We will discuss in Macros */
Select Name into: all_names separated by "," From sashelp.class;
Quit;

%put &all_names;

/*Reset stmt*/

Proc SQL Double Outobs=7 Number Stimer;
Select * From sashelp.class;
Reset Inobs = 5 Nonumber;/*To reset the optins in PROC SQL stmt */
Select * From sashelp.class Where age = 12;
Quit;

/*Validate stmt*/

Proc SQL;
Validate Select * From sashelp.class wher age = 13;
Validate Select name,age height From sashelp.class where age = 13;
Validate Select name,age,height From sashelp.class where age = 13;
Quit;

/*Alter Table*/

/*add
drop
modify */

Data Class;
Set sashelp.class;
Run;

Proc Format;
Value $ Gend "M"="Male" "F"="Female";
Run;

Proc SQL;
Alter Table work.Class
	Add New_Height Num Format=5.2
	Drop Weight
	Modify Sex Format=$gend.;

Quit;

Proc Print data = class;
Run;

/*Update stmt*/

Proc SQL;
Update work.class
Set New_Height = 100; /* Constant value */
Select * From Class;
Quit;

Proc SQL;
Update class
Set New_Height = Height+
Case 
	When Sex="M" then 10
	Else 20
End;

Select * From Class;

Quit;

/* above changes using SAS datastep */
data class2(Drop=Weight);
set sashelp.class;
if sex = "F" then new_ht = height+20;
else new_ht = height+10;
Format Sex $Gend.;
run;



/*
NOT NULL  _NM0001_, _NM0002_....
Unique  UN0001
Primary Key PK0001, PK0002...
Check(Condition) CK0001,CK0002
*/


Proc SQL;
Create Table Students_SQL(ID Char(10) NOT NULL, Name Char(20), Age Num , Gender Char(6),DOB Num Format=ddmmyy10.);
Insert Into Students_SQL 
Values("101","Rajesh",23,"Male","23JAN1998"D)
Values("102","Rakesh",24,"Male","23JAN1997"D)
Values(" ","Madhu",25,"Male","23JAN2000"D)
Values("104","Ram",26,"Male","23JAN2001"D);
Quit;

Proc SQL;
Create Table Students_SQL(ID Char(10) UNIQUE, Name Char(20), Age Num, 
Gender Char(6),DOB Num Format=ddmmyy10.);
Insert Into Students_SQL 
Values("101","Rajesh",23,"Male","23JAN1998"D)
Values("102","Rakesh",24,"Male","23JAN1997"D)
Values("101","Madhu",25,"Male","23JAN2000"D)
Values("104","Ram",26,"Male","23JAN2001"D);
Quit;

Proc SQL;
Create Table Students_SQL(ID Char(10) PRIMARY KEY, Name Char(20), Age Num Check(Age<=30), 
Gender Char(6),DOB Num Format=ddmmyy10. Check(DOB>="01JAN1998"D));
Insert Into Students_SQL 
Values("101","Rajesh",23,"Male","23JAN1998"D)
Values("102","Rakesh",24,"Male","23JAN1997"D)
Values("103","Madhu",25,"Male","23JAN2000"D)
Values("104","Ram",26,"Male","23JAN2001"D);
Quit;

Proc Contents data = Students_SQL;
Run;
/*Creating IC through Datasets procedure for an existing dataset*/
Proc Datasets;
IC Create ID NOT NULL ON SASHELP.Class;
Quit;


/*Dictionary tables
The SAS System generates and maintains valuable information at run time about SAS libraries, data sets, catalogs,
indexes, macros, system options, titles, and views in a collection of read-only tables called dictionary tables. Although
called tables, Dictionary tables are not real tables. Information is automatically generated at runtime and the tables
contents are made available once a SAS session is started.
 DICTIONARY tables can be used to
capture information related to currently defined libnames, table names, column names and attributes, formats, and
much more. DICTIONARY tables are accessed using the libref DICTIONARY in the FROM clause of a PROC SQL
SELECT statement.*/

Proc SQL;
Select Distinct memname from sashelp.Vdctnry;
Quit;

Proc SQL;
Select * From DICTIONARY.LIBNAMES ;
/*Select * From DICTIONARY.LIBNAMES Where Libname="WORK";*/
Quit;

proc print data = DICTIONARY.LIBNAMES; /* doesn't work */
run;

Proc SQL;
*Select * From DICTIONARY.TABLES;
Select * From DICTIONARY.TABLES Where Libname="SASHELP" AND MemName = "CLASS";
Quit;

Options Nolabel;
Proc SQL;
Select * From DICTIONARY.COLUMNS Where Libname="SASHELP" AND MemName = "CLASS";
Quit;

Proc SQL;
Select * From sashelp.VCOLUMN Where Libname="SASHELP" AND MemName = "CLASS";
Quit;

/*All available dictionaries*/

proc sql;
select distinct memname from sashelp.Vdctnry;
select distinct memname from dictionary.DICTIONARIES;
quit;

data vcol;
set sashelp.Vcolumn;
where Libname="SASHELP" AND MemName = "CLASS";
run;

proc print data = vcol;
run;

Proc SQL;
Describe View sashelp.Vcolumn; /*check log */
Quit;

/*Sub-Query:-*/

Proc SQL;

Select * From Table1 Where Field(s) In(Select Field(s) From Table2 );

Quit;

data emp;
input EID $ ENAME $  MGR_EID $ Sal;
cards;
000250  XYZ 000010 1000
000010  Ram  000070  2000
000070  Gaurav  000220 3000
000220  Pawan  000280 4000
000280  Manoj  000300 5000
000300 Gautam 000400 6000
;

Proc SQL;

Select * From Emp Where Sal = (Select Max(Sal) From Emp);

Select * From sashelp.shoes Where Sales In (Select Max(Sales) From sashelp.shoes);

Select * From sashelp.shoes Where Stores In (Select Max(Stores) From sashelp.shoes);

Quit;

/*
SQL Procedure Pass-Through Facility
The SQL Procedure Pass-Through Facility is an extension of the SQL procedure that enables you to send DBMS-specific statements 
to a DBMS and to retrieve DBMS data. 

You specify DBMS SQL syntax instead of SAS SQL syntax when you use the Pass-Through Facility. 
You can use Pass-Through Facility statements in a PROC SQL query or store them in a PROC SQL view.

The Pass-Through Facility consists of three statements and one component:
 The CONNECT statement establishes a connection to the DBMS.
 The EXECUTE statement sends dynamic, non-query DBMS-specific SQL statements to the DBMS.
 The CONNECTION TO component in the FROM clause of a PROC SQL SELECT statement retrieves data directly from a DBMS.
 The DISCONNECT statement terminates the connection to the DBMS.

*/
proc sql;
   connect to oracle as myconn (user=smith password=secret 
      path='myoracleserver');

   select * 
      from connection to myconn
         (select empid, lastname, firstname, salary
            from employees
            where salary>75000);

   disconnect from myconn;
quit;

/*
The example uses the Pass-Through CONNECT statement to establish a connection with an ORACLE database with the specified values 
for the USER=, PASSWORD=, and PATH= arguments. 

The CONNECTION TO component in the FROM clause of the SELECT statement enables data to be retrieved from the database. 

The DBMS-specific statement that is sent to ORACLE is enclosed in parentheses. 

The DISCONNECT statement terminates the connection to ORACLE.

To store the same query in a PROC SQL , use the CREATE VIEW statement:
libname viewlib 'SAS-library';

*/

proc sql;    
   connect to oracle as myconn (user=smith password=secret 
      path='myoracleserver'); 
    
   create view viewlib.salary as
      select * 
         from connection to myconn       
            (select empid, lastname, firstname, salary          
               from employees          
               where salary>75000);  
   
   disconnect from myconn; 
quit; 

























