libname new "C:\Users\user\Desktop\SAS Output";

*to deassign a library
libname libref clear;


libname new clear; 


data class; 
set sashelp.class; 
keep name age;
run;

data class(keep=name age); 
set sashelp.class; 
run;

data class(drop=sex height weight); 
set sashelp.class; 
run;



data class; 
set sashelp.class; 
rename sex=gender;
run;

data class (rename=(sex=gender)); 
set sashelp.class; 
run;

data class (drop=age keep=name height sex rename=(sex=gender)); 
set sashelp.class; 
run;

data class (drop=age keep=name height  rename=(sex=gender)); 
set sashelp.class; 
run;

data class (drop=age keep=age); 
set sashelp.class; 
run;

data class (keep=age name drop=age ); 
set sashelp.class; 
run;

*where;








