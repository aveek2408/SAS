*
Non Standard Data
	- Informat 	: Read data 
	- Format	: Write data

- Amount, Currencies : commaw.d, dollarw.d 
- Date, Time & Datetime 
;

* Single Trailing & Modifiers (: & ~);
* Proc format , Proc import & Proc Export ;


data scores;
infile datalines dlm=",";
input name $ 11. score1 score2 score3;
datalines; 
Smith,12,22,46
RamaKrishna,23,19,25
Jones,09,17,54
; 
run;

data scores;
infile datalines dlm=",";
input name : $11. score1 score2 score3;
datalines; 
Smith,12,22,46
RamaKrishna,23,19,25
Jones,09,17,54
; 
run;

*The : (colon) format modifier 
	- enables you to use list input but also to specify an informat after a variable name, 
whether character or numeric. 
SAS reads until it encounters a blank column, the defined length of the variable
(character only), or the end of the data line, whichever comes first.
;

data scores;
infile datalines dlm=",";
input name : $11. score1 score2 score3 exam_date;
informat exam_date date9.;
format exam_date date9.;
datalines; 
Smith,12,22,46,12Sep2019
RamaKrishna,23,19,25,12Sep2019
Jones,09,17,54,12Sep2019
; 
run;


data scores;
infile datalines dlm=",";
input name : $ 11. score1 - score3 exam_date : date9.;
format exam_date date9.;
datalines; 
Smith,12,22,46,12Sep2019
RamaKrishna,23,19,25,12Sep2019
Jones,09,17,54,12Sep2019
; 
run;
DATA citypops;
input city :& $11. ;
DATALINES;
New York
Los  Angeles
Chicago
Houstonnnnn
;
RUN;

*
The & (ampersand) format modifier 
	- enables you to read character values that contains 
one or more embedded blanks with list input and to specify a character informat. 
SAS reads until it encounters two consecutive blanks, the defined length of the variable, 
or the end of the input line, whichever comes first.
;
DATA citypops;
infile datalines firstobs=2;
input city :& $20. population : comma20.;
DATALINES;
City  Yr2000Popn
New York  8,008,278
Los Angeles  3,694,820
Chicago  2,896,016
Houston  1,953,631
Philadelphia  1,517,550
Phoenix  1,321,045
San Antonio  1,144,646
San Diego  1,223,400
Dallas  1,188,580
San Jose  894,943
;
RUN;

* New York 8,008,278;

DATA citypops;
infile datalines firstobs=2;
input state $ city &: $20. population : comma20.;
DATALINES;
City  Yr2000Popn
MA New York  8,008,278
;
RUN;

data scores;
   infile datalines dsd;
   input Name : $9. Score1-Score3 Team ~ $25. Div $;
   datalines;
Smith,12,22,46,"Green Hornets, Atlanta",AAA 
Mitchel,23,19,25,"High Volts, Portland",AAA 
Jones,09,17,54,"Vulcans, Las Vegas",AA 
; 
run;

*
The ~ (tilde) format modifier 
	- enables you to read and retain single quotation marks, double quotation marks, 
and delimiters within character values.
;


data name_plates;
input state $ @;
if state = "AP" then input DoR : mmddyy10. ;
else if state = "TN" then input DoR : date9. ;
format DoR ddmmyy10.;
datalines;
AP 01-24-2000 
TN 12JAN1995 
AP 2-21-1999 
TN 23MAR1997 
;
run;

data red_team;
   input Team $ 13-18 @;  
   if Team='red';   
   input IdNumber 1-4  StartWeight 20-22 EndWeight 24-26;   
   datalines;
1023 David  red    189 165
1049 Amelia yellow 145 124
1219 Alan   red    210 192
1246 Ravi   yellow 194 177
1078 Ashley red    127 118
1221 Jim    yellow 220   . 
;  
run; 

/*
@ --> Line-hold specifiers
Line-hold specifiers keeps the pointer on the current input line when
	• a data line is read by more than one INPUT statement (trailing @).
	• one input line has values for more than one observation (double trailing @).

Normally, each INPUT statement in a data step reads a new data line into the input buffer. 
When one uses a trailing @, the following occurs:
	• The pointer position remains the same.
	• No new record is read into the input buffer.
	• The next INPUT statement for the same iteration of the data step continues reading the
	  same record.

A line held with a trailing @ is released automatically when
	• A null INPUT statement executes: input;
	• The system retains to the top of the data step to begin the next iteration.
*/

















































