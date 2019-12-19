
Proc Means data = inputdata Stat_keywords Noprint Maxdec= Missing Order= nway;
Class Grouped data;
Var Analytical variables ;
Output Out = outputdataset statistical_keywords = alias_names ;

By sorting_variable;
Where stmt;
Format stmt;
Run;

/*examples*/

Proc Means data = sashelp.class;
Run;

Proc Means data = sashelp.class N Mean Std Sum Range 
					Median Variance NMISS   Maxdec = 2;
Run;

Proc Means data = sashelp.class SUM;
Run;

/*What is the diff bet a descriptive stat function and des stat procedure?*/

Proc Means data = sashelp.class;
Var Age Height;
Run;

Proc Means data = Bank_Dts N Mean Std Sum;
Var Loan_Amt Clm_Amt Sav_Amt;
Class Branch_Nm;
Run;

Proc Means data = sashelp.class;
Var Age Height;
Class Sex;
Run;

Proc Means data = sashelp.shoes;
Var Sales;
Class Region Product;
*Where Region = "Asia";
Run;

Proc Means data = sashelp.shoes;
Var Sales;
Class Product;
Run;

Proc Means data = sashelp.shoes;
Var Sales;
Class Subsidiary/Missing; /* Includes the missing groups */
Run;

Proc Means data = sashelp.class Noprint;
Var Age;
Output Out = Class_Means ;
Run;

Proc Means data = sashelp.class N Mean Std Sum Noprint;/*doesn't hav effect here */
Var Age;
Output Out = Class_Means2 N=Obs Mean=Avg Std=Std_Dev Sum = Total;
Run;


/****** IMP START**********/

Options nolabel;
proc means data = sashelp.shoes N Mean Sum Std;
class region;
var sales;
Format sales ;
output out = test N=Obs Mean=avg Sum=total Std=std_dev;
run;

data asia_sales(drop=_type_ _freq_);
set test;
where region = "Asia";
Run;

proc print;run;

Options nolabel;
proc means data = sashelp.shoes Noprint;
class region product;
var sales;
Format sales comma10.;
output out = test2 N=Obs Mean=avg Sum=total Std=std_dev;
run;

data asia_sales(drop = _type_ _freq_);
set test2;
where _Type_ = 3 and Region = "Asia";
Run;

proc print;run;

/******* IMP END **********/

Proc Means data = sashelp.class(Keep = Age Sex) Noprint;
Var Age;
Class Sex;
Output Out = Class_Means3 N=Obs Mean=Avg Std=Std_Dev Sum = Total;
Run;

Proc Means data = sashelp.class(Keep = Age Sex Height) Noprint;
Var Height;
Class Sex Age;
Output Out = Class_Means4 N=Obs Mean=Avg Std=Std_Dev Sum = Total;
Run;

Data Cls_Mns5(Drop = _Type_ _Freq_ Obs Avg Std_Dev Total);
Set Class_Means4;
Where _Type_ = 3;
Format Avg Std_Dev 7.2;
N_Mn_Std = "(" || Put(Obs,2.) || "," || Put(Avg,7.2) || "," || Put(std_dev,7.2) || ")";
Run;

Data class;
set sashelp.class; /* Create some missing values manually */
run;

Proc means data = class Missing NMiss N Mean Std;
Class Sex;
Var Height;
Run;

/*OR*/

Proc means data = class  NMiss N Mean Std;
Class Sex/Missing;
Var Height;
Run;


Proc means data = sashelp.shoes NONOBS N Mean Std Order = Freq; /* Internal, Data, Formatted options can also be used */
Class Region;
Var Sales;
Run;


Proc means data = sashelp.shoes NWAY;
Class Region Product;
Var Sales;
Run;

Proc sort data = class;
by Sex;
Run;

Proc Means data = class;
By Sex;
Var Age Height;
Run;

Options FMTSEARCH = (MYLIB);
Proc Means data = Class;
Class Sex/Missing;
Format Sex $Myfmt.;
Var Age Height;
Run;
