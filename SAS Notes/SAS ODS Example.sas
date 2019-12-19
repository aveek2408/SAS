/*
The Output Delivery System (ODS) enables you to produce output in a variety of formats, such as:
	an HTML file
	a traditional SAS Listing
	a PostScript file
	an RTF file (for use with Microsoft Word)
	an output data set

*/

ods listing close;
ods excel file="/folders/myfolders/Edureka/class.xlsx";

	proc print data=sashelp.class;
	run;
ods excel close;
ods listing;


ods listing close;
ods csv file="/folders/myfolders/Edureka/class_csv.csv";

	proc print data=sashelp.class;
	run;
ods csv close;
ods listing;


ods listing close;
ods pdf file="/folders/myfolders/Edureka/class.pdf";

	proc print data=sashelp.class;
	run;
ods pdf close;
ods listing;



ods listing close;
ods html file="/folders/myfolders/Edureka/class.html";

	proc print data=sashelp.class;
	run;
ods html close;
ods listing;


ods listing close;
ods rtf file="/folders/myfolders/Edureka/class.rtf";

	proc print data=sashelp.class;
	run;
ods rtf close;
ods listing;


* Input dataset;
data sat_scores;
   input Test $ Gender $ Year SATscore @@;
   datalines;
Verbal m 1972 531  Verbal f 1972 529
Verbal m 1973 523  Verbal f 1973 521
Verbal m 1974 524  Verbal f 1974 520
Verbal m 1975 515  Verbal f 1975 509
Verbal m 1976 511  Verbal f 1976 508
Verbal m 1977 509  Verbal f 1977 505
Verbal m 1978 511  Verbal f 1978 503
Verbal m 1979 509  Verbal f 1979 501
Verbal m 1980 506  Verbal f 1980 498
Verbal m 1981 508  Verbal f 1981 496
Verbal m 1982 509  Verbal f 1982 499
Verbal m 1983 508  Verbal f 1983 498
Verbal m 1984 511  Verbal f 1984 498
Verbal m 1985 514  Verbal f 1985 503
Verbal m 1986 515  Verbal f 1986 504
Verbal m 1987 512  Verbal f 1987 502
Verbal m 1988 512  Verbal f 1988 499
Verbal m 1989 510  Verbal f 1989 498
Verbal m 1990 505  Verbal f 1990 496
Verbal m 1991 503  Verbal f 1991 495
Verbal m 1992 504  Verbal f 1992 496
Verbal m 1993 504  Verbal f 1993 497
Verbal m 1994 501  Verbal f 1994 497
Verbal m 1995 505  Verbal f 1995 502
Verbal m 1996 507  Verbal f 1996 503
Verbal m 1997 507  Verbal f 1997 503
Verbal m 1998 509  Verbal f 1998 502
Math   m 1972 527  Math   f 1972 489
Math   m 1973 525  Math   f 1973 489
Math   m 1974 524  Math   f 1974 488
Math   m 1975 518  Math   f 1975 479
Math   m 1976 520  Math   f 1976 475
Math   m 1977 520  Math   f 1977 474
Math   m 1978 517  Math   f 1978 474
Math   m 1979 516  Math   f 1979 473
Math   m 1980 515  Math   f 1980 473
Math   m 1981 516  Math   f 1981 473
Math   m 1982 516  Math   f 1982 473
Math   m 1983 516  Math   f 1983 474
Math   m 1984 518  Math   f 1984 478
Math   m 1985 522  Math   f 1985 480
Math   m 1986 523  Math   f 1986 479
Math   m 1987 523  Math   f 1987 481
Math   m 1988 521  Math   f 1988 483
Math   m 1989 523  Math   f 1989 482
Math   m 1990 521  Math   f 1990 483
Math   m 1991 520  Math   f 1991 482
Math   m 1992 521  Math   f 1992 484
Math   m 1993 524  Math   f 1993 484
Math   m 1994 523  Math   f 1994 487
Math   m 1995 525  Math   f 1995 490
Math   m 1996 527  Math   f 1996 492
Math   m 1997 530  Math   f 1997 494
Math   m 1998 531  Math   f 1998 496
;
run;

* HTML Output:;

options pageno=1 nodate pagesize=30 linesize=78;
ods html file='/folders/myfolders/Datasets/sat_scores.html';

proc means data=sat_scores fw=8; 
   var SATscore;
   class Test Gender;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods html close; 

proc sort data=sat_scores out=sorted_scores;
   by Test;
run;

options pageno=1 nodate;

ods listing close;  
ods rtf file='/folders/myfolders/Datasets/odsprinter_output.rtf'; 

proc means data=sorted_scores fw=8;  
   var SATscore;
   class Gender ;
   by Test;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods rtf close;  
ods listing;  

ods trace on;

proc univariate data=sat_scores;
   var SATscore;
   class Gender;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods trace off;





ods listing close;  
ods csv file='/folders/myfolders/Datasets/odsprinter_output.csv'; 

proc means data=sorted_scores fw=8;  
   var SATscore;
   class Gender ;
   by Test;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods csv close;  
ods listing;  



ods listing close;  
ods excel file='/folders/myfolders/Datasets/odsprinter_output.xlsx'; 

proc means data=sorted_scores fw=8;  
   var SATscore;
   class Gender ;
   by Test;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods excel close;  
ods listing;  



ods listing close;  
ods pdf file='/folders/myfolders/Datasets/odsprinter_output.pdf'; 

proc means data=sorted_scores fw=8;  
   var SATscore;
   class Gender ;
   by Test;
   title1 'Average SAT Scores Entering College Classes, 1972-1998*';
   footnote1 '* Recentered Scale for 1987-1995';
run;

ods pdf close;  
ods listing;  










