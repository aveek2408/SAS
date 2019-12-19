Title Cluster Analysis for Hypothetical Data;

data t;
	input cid $ 1-2 income educ;
cards;
c1 5 5
c2 6 6
c3 15 14
c4 16 15
c5 25 20
c6 30 19
run;


data t2;
	input cid $ 1-2 income educ;
cards;
c1 5 5
c2 6 6
c3 15 14
c4 16 15
c5 25 20
c6 30 19
run;

title'unclustered data';
proc sgplot data=sashelp.cars;
   scatter y=make x=enginesize;
run;


ods graphics on;
proc cluster data=SASHELP.CARS method=ward ccc pseudo PRINT=20 plots=den(height=rsq);
            var Wheelbase;
            id make;
run; 
proc sgplot data=sashelp.cars;
   scatter y=make x=wheelbase / group=origin;
run;
