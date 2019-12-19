
/*Summary is almost identical to Means, have only 2 differences */

Proc Summary data = inputdata Stat_keywords Print Maxdec= Missing Order=;
Class Grouped data;
Var Analytical variables ;
Output Out = outputdataset statistical_keywords = alias_names ;

By sorting_variable;
Where stmt;
Format stmt;
Run;

/*
First difference::::

Means - Printable output
Summary - Doesn't print

*/

Proc Summary data = sashelp.class Print;
Run;

/* Observe the outputs of below and above programs */

Proc Means data = sashelp.class;
Run;

Proc Summary data = sashelp.class Print;
Var Age Height;
Run;

Proc Means data = sashelp.class;
Var Age Height;
Run;

Proc Summary data = sashelp.class Print;
Var Age Height;
Class Sex;
Run;

Proc Means data = sashelp.class;
Var Age Height;
Class Sex;
Run;


* Second Difference:::: If you omit the VAR statement, then PROC SUMMARY produces 
a simple count of observations, whereas PROC MEANS analyze 
all the numeric variables that are not listed in the other statements.  ;

Proc Means data = sashelp.class;
Class Sex;
Run;

Proc Means data = sashelp.class ;
Class Sex Age;
Run;

Proc Summary data = sashelp.class Print;
Class Sex Age;
Run;

Proc Summary data = sashelp.class Maxdec=2; /* Maxdec option is only for report */
Class Sex;
Var Age;
Output Out = Abc N = Freq Mean = Avg Std = Std_Dev;
Run;


Options nolabel;
Proc Summary data = sashelp.shoes;
class region product;
var sales;
Format sales comma10.;
output out = test2 N=Obs Mean=avg Sum=total Std=std_dev;
run;
