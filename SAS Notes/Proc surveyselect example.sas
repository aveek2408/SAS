* 
A procedure that provides a variety of methods for choosing probability-based random
samples, including simple random sampling, stratified random sampling, and
systematic random sampling. 
;


data birthweights (keep=weight boy);
set sashelp.bweight;
run;

proc surveyselect data=birthweights out=ten_pct_sample method=srs samprate=0.1;
run;
