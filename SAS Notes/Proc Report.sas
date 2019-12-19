/* Proc Report 

PROC REPORT DATA= datasetname <options>;
COLUMN variable list and column specifications;
DEFINE column / column usage and attributes;
COMPUTE column; compute block statements; ENDCOMP;
RUN;

The COLUMN statement is used to identify all variables used in the generation of the table. 
This statement is followed by the DEFINE statement which specifies how the column is to be
used and what its attributes are to be. 
One DEFINE statement is used for each variable in the COLUMN statement.

*/

data tq84_report;
  length txt $3 val 4.;
  input  txt    val   ;
datalines;
foo 42
bar .
foo 18
baz 332
bar 7
foo 219
foo .
bar 153
bar 22
quit;

* Simple call - use as a print procedure; 
proc report data=tq84_report;
run;

* subset data using where statement; 
proc report data=tq84_report;
     where val > 20;
run;

* using by statement; 
proc sort data=tq84_report out=sort_ds; 
by txt; 
run;

proc report data=sort_ds;
     by txt;
run;

* assign report variables & usage of compute; 
proc report data=tq84_report;
     where val > 20;

  /* The column statement identifies all variables that are used in the report: */
     column txt val val_sq;

     define txt / display;
     define val / display;
     
     compute val_sq;
       val_sq = val ** 2;
     endcomp;
run;

* define order;
data tq84_report;
  length txt $3 val 4.;
  input  txt    val   ;
datalines;
foo 42
bar 61
foo 18
baz 332
bar .
foo 219
foo .
bar 153
bar 22
quit;


proc report data=tq84_report;
     column txt val;

     define txt / order;    /* Order by txt */
     define val / display;
run;

* define group;
data tq84_report;
  length txt1 $3
         txt2 $3
         txt3 $2
         val   4.;
  input  txt1 txt2 txt3 val;
datalines;
abc jkl uv  13
ghi mno uv 288
ghi pqr wx   7
abc mno yz  15
def pqr uv   3
abc jkl uv   .
ghi jkl wx  96
ghi mno yz  75
abc pqr yz 111
abc jkl uv  86
def pqr uv  39
ghi jkl yz  22
abc pqr wx   .
ghi mno uv  41
def pqr yz  52
quit;


proc report data=tq84_report;
     column txt1 txt2 txt3 val;

     define txt1 / group;
     define txt2 / group;
     define txt3 / group;
     define val  / analysis sum;
     
run;

* define analysis;
data tq84_report;
  length txt1 $3
         txt2 $3
         txt3 $2
         val   4.;
  input  txt1 txt2 txt3 val;
datalines;
abc jkl uv  13
ghi mno uv 288
ghi pqr wx   7
def jkl uv   3
abc jkl uv   .
ghi jkl wx  96
ghi mno uv  75
abc pqr wx 111
abc jkl uv  86
def pqr yz  39
abc jkl uv  15
ghi jkl wx  22
abc pqr wx   .
ghi mno uv  41
def pqr yz  52
quit;


proc report data=tq84_report;
     column txt1 txt2 txt3
         /* val is used for multiple statistics per
            group. Therefore, we create an alias
            for each statistics: */
            val = val_sum
            val = val_avg
            val = val_min
            val = val_max 
            val = val_cnt;

     define txt1    / group;
     define txt2    / group;
     define txt3    / group;
     define val_sum / analysis sum             'Total';
     define val_avg / analysis mean format=3.1 'Avg.' ;
     define val_min / analysis min             'Min.' ;
     define val_max / analysis max             'Max.' ;
     define val_cnt / analysis n               'Count';
     
run;

* define across
define / across is used to create pivot tables:;
data tq84_report;
  length txt1 $3
         txt2 $3
         txt3 $2
         val   4.;
  input  txt1 txt2 txt3 val;
datalines;
abc jkl uv  13
ghi mno uv 288
ghi pqr wx   7
def jkl uv   3
abc jkl uv   .
ghi jkl wx  96
ghi mno uv  75
abc pqr wx 111
abc jkl uv  86
def pqr yz  39
abc jkl uv  15
ghi jkl wx  22
abc pqr wx   .
ghi mno uv  41
def pqr yz  52
quit;


proc report data=tq84_report;

     column txt1 txt2 txt3 val;

     define txt1 / group        'txt one';
     define txt2 / group        'txt two';
     define txt3 / across       'txt three';
     define val  / analysis sum 'Total';
run;

* define compute
compute can be used to add addtional text before and after groups:;
data tq84_report;
  length txt1 $3
         txt2 $3
         txt3 $2
         val   4.;
  input  txt1 txt2 txt3 val;
datalines;
abc jkl uv  13
ghi mno uv 288
ghi pqr wx   7
def jkl uv   3
abc jkl uv   .
ghi jkl wx  96
ghi mno uv  75
abc pqr wx 111
abc jkl uv  86
def pqr yz  39
abc jkl uv  15
ghi jkl wx  22
abc pqr wx   .
ghi mno uv  41
def pqr yz  52
quit;

proc report data=tq84_report;

     column txt1 txt2 txt3 val;

     define txt1 / group        'txt one';
     define txt2 / group        'txt two';
     define txt3 / across       'twt three';
     define val  / analysis sum 'Total';

     compute before txt1;
       line  @1 "Values for " txt1 $20.;
     endcomp;

     compute after txt1;
       length group_txt $20;

       if txt1 = 'abc' then group_txt = 'Computed text foo'; else
       if txt1 = 'def' then group_txt = 'Computed text bar'; else
       if txt1 = 'ghi' then group_txt = 'Computed text baz'; else
                            group_txt = '???';

       line @1 group_txt $20.;
     endcomp;
run;

* use list option; 
data tq84_dat;

 length txt_one $10
        txt_two $10
        num_one   8.
        num_two   8.;

  input txt_one
        txt_two
        num_one
        num_two;

datalines;
foo abc  2 40 
run;

proc report
     data=tq84_dat
     list;
run;

******************************************************;
data mnthly_sales; 
length zip $ 5 cty $ 8 var $ 10;
input zip $ cty $ var $ sales; 
label zip="Zip Code"
cty="County" 					
var="Variety" 					
sales="Monthly Sales"; 		
datalines; 					
52423 Scott Merlot 186. 		
52423 Scott Chardonnay 156.61 	
52423 Scott Zinfandel 35.5 	
52423 Scott Merlot 55.3 		
52388 Scott Merlot 122.89 		
52388 Scott Chardonnay 78.22 	
52388 Scott Zinfandel 15.4 	
52200 Adams Merlot 385.51 		
52200 Adams Chardonnay 246 	
52200 Adams Zinfandel 151.1 	
52200 Adams Chardonnay 76.24
52199 Adams Merlot 233.03
52199 Adams Chardonnay 185.22
52199 Adams Zinfandel 95.84
;

 proc print data=mnthly_sales;
 title "Raw Data";
 run; 

  proc report data=mnthly_sales ; 
 title1 "Simple Report";
 column cty zip var sales; 
 define cty / display; 
 define zip / display; 
 define var / display; 
 define sales / display; 
 run; 

  proc report data=mnthly_sales headline headskip;
 title1 "Simple Formatted Report"; 
 column cty zip var sales;
 define cty / display width=6 "County/Name";
 define zip / display;
 define var / display; 
 define sales / display format=6.2 width=10;
 run;

 proc report data=mnthly_sales nofs headline headskip;
 title1 "Ordered Report (Order Type)";
 column cty zip var sales;
 define cty / order width=6 "County/Name";
 define zip / display;
 define var / display;
 define sales / display format=6.2 width=10;
 run; 

  proc report data=mnthly_sales headline headskip;
 title1 "Grouped Report (Group Type)"; 
 column cty zip var sales; 
 define cty / group width=6 "County/Name";
 define zip / group;
 define var / group order=freq descending; 
 define sales / display format=6.2 width=10; 
 run; 

  proc report data=mnthly_sales headline headskip;
 title1 "Summed Groups Rept (Analysis Type)";
 column cty zip sales; 
 define cty / group width=6 "County/Name";
 define zip / group;
 define sales / analysis sum 
 format=6.2 width=10; 
 run; 

 proc report data=mnthly_sales nofs headline headskip;
 title1 "Cross Tab Report (Across Type)";
 column cty zip var,sales;
 define cty / group width=6 "County/Name";
 define zip / group;
 define var / across order=freq descending '- Grape Variety -';
 define sales / analysis sum format=6.2 width=10 'Revenue';
 run; 

  proc report data=mnthly_sales nofs headline headskip;
 title1 "Report with Breaks";
 column cty zip var,sales;
 define cty / group width=6 'County/Name';
 define zip / group;
 define var / across order=freq descending '- Grape Variety -';
 define sales / analysis sum format=6.2 width=10 'Revenue';
 break after cty / ol skip summarize suppress;
 rbreak after / dol skip summarize;
 run; 
