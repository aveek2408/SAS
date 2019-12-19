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
