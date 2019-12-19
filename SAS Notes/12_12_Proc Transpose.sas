/*PROC TRANSPOSE*/

PROC TRANSPOSE DATA=input-data-set OUT=output-data-set 
LABEL=label NAME=name PREFIX=prefix;  

BY variable-1 ;

VAR variable(s);  

ID variable;  
IDLABEL variable;

COPY Variables;

Run;

/*Small example*/

data test;
input Name $ Test1 test2 test3;
cards;
Ram 1 2 3
Kiran 4 5 6
;

proc transpose data = test out = test3 Name = Exams ;
var Test1 test2;
ID Name;
run;

proc print;run;

data score;
Length Name $ 9;
input Name +1 IdNum $ Sec $ Maths Sci Soc;
datalines;
Capalleti 0545 1  94 91 87
Dubose    1252 2  51 65 91
Engles    1167 1  95 97 97
Grant     1230 2  63 75 80
Krupski   2527 2  80 76 71
Lundsford 4860 1  92 40 86
Mcbane    0674 1  75 78 72
;

proc transpose data = score out = trns_scr;
run;

proc print;run;

proc transpose data = score out = trns_scr;
Var Sec IdNum Maths; /* can transpose char also */
run;

proc print;run;

options nolabel;
proc transpose data = score out = trns_scr Name = Trns_Var;
Var Maths Sci Soc ;
run;
proc print;run;

proc transpose data = score out = trns_scr 
Name = Trns_Var Prefix = Student;
Var Maths Sci Soc ;
run;
proc print;run;

Options Label;
proc transpose data = score out = trns_scr 
Name = Trns_Var Prefix = Roll_;
Var Maths Sci Soc ;
Id IdNum;
IdLabel Name;
run;
proc print Label;run;

proc sort data = score;
by sec;
run;
proc transpose data = score out = trns_scr 
Name = Trns_Var Prefix = Roll_;
Var Maths Sci Soc ;
Id IdNum;
IdLabel Name;
By Sec;
run;
proc print Label;run;

proc transpose data = score out = trns_scr 
Name = Trns_Var Prefix = Roll_;
Var Maths Sci Soc ;
Copy Name IdNum;
run;
proc print Label;run;
