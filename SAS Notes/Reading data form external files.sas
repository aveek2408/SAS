* 
1. Types of variables 
	numeric
	character 
2. Library 
	Perm
	Temp
		Rules for Library names 
3. Perm DS
	Temp DS
		Rules for DS names
;

/* 
To read any external files:
How SAS WORKS......
Input Methods:
	1. List input (or) Fixed input 
	2. Column input
	3. Mixed input (or) Formatted input 
		a. Absolute pointer
		b. Relative pointer 
*/

* 1. List input method
	
	data 	--> 	creates a dataset 
	set  	-->		supply input dataset 
	infile	--> 	supply input file
	input	--> 	define varibles to be part of output dataset 
	length 	-->		to take control over length of the variable
	delimiter->		Space

;

data student;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\student_data.txt";
input 
student_id	$
age			
gender		$
height		
weight
;
run;



/* How SAS WORKS???
1. Look for syntax errors. 
2. Input Buffer - Logical memory 
	-	Tokenization
		Breaking your program into tokens 
	-	Assign your program to the respective processors 
3.	PDV - Program Data Vector - Logical Memory 
	-	Heart of SAS program
	- 	Place where your SAS dataset gets build
	-	N --> observation number
	-	_ERROR_ ---> Default value is "0".
					 0 - No error
					 1 - Error
	-	Once we reach end of the file then SAS exports the data from PDV to active libraries
*/

data student_1;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\student_data.txt";
input 
student_id	$
age			
gender		$
height		
weight
;
length 
student_id	$	3.
gender		$	1.
;
run;

data student_2;
length 
student_id	$	3.
gender		$	1.
;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\student_data.txt";
input 
student_id	$
age			
gender		$
height		
weight
;
run;

data temp_1;
retain 
student_id	
age			
gender		
height		
weight
;
length 
student_id	$	3.
gender		$	1.
;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\student_data.txt";
input 
student_id	$
age			
gender		$
height		
weight
;
run;






/* Options 
	1. Infile options;
		dlm  ---> to specify a delimiter
		dsd ----> delimited separated data
		flowover
		stopover
		missover
		truncover
	2. Input option
		@@ ---> to read ultiple records from the same line
		@
*/

data student;
infile datalines dlm=",*&|";
input 
student_id	$
age			
gender		$
weight
height	
;
datalines;
101,23,F*145,52
102|25,M,165&67
;
run;

data student;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\student_data.txt" dlm=",";
input 
student_id	$
age			
gender		$
weight
height	
;
run;

data student_1;
infile datalines dlm=",";
input 
student_id	$
age			
gender		$
weight
height
@@	
;
datalines;
101,23,F,145,52
102,25,M,165,67,103,25,M,165,76
;
run;

data student_2;
infile datalines dlm="," dsd;
input 
student_id	$
age			
gender		$
weight
height
;
datalines;
101,23,F,145,52
102,,M,165,67
103,25,M,165,76
104,25,M,165,76
;
run;


/*Flowover 
	1. When SAS encounters a shorten line ( input file has lesser values than we defined in input statement)
	2. Length criteria not meet

Stopover:
	Don't Process the data ---> create an erro in log 
*/

data student_3;
infile datalines dlm="," dsd;
input 
student_id	$
age			
gender		$
weight
height
;
datalines;
101,23,F,145,52
102,,M,165,67
103,25,M,165,76
104,25,M,165,76
;
run;

data flowovr;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\numbers.txt";
input number 5.;
run;

data stopover;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\numbers.txt" stopover;
input number 5.;
run;

data missovr;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\numbers.txt" missover;
input number 5.;
run;

data truncovr;
infile "C:\Documents and Settings\Administrator\Desktop\Class Datasets\numbers.txt" truncover;
input number 5.;
run;

data valid invalid;
set truncovr;
n = strip(put(number,5.));
if length(n) in (4,5) then output valid;
else output invalid;
run;

/* 
List input Drawbacks:
1. Proper delimited file
2. reading selected variables are not possible
3. I cannt change the order in which the data is exist in file

*/

* Column input method.;
data col_1;
infile datalines;
input 
id 		$	1-3
age 		5-6
gender 	$ 	8
wt 			10-11
ht 			13-15
;
datalines;
101 23 m 52 143
102 25 f 45 130
103 26 f 50 140
104 28 m 60 154
105 29 f 45 112
;
run;

data col_3;
length 
id 		$	4.
gender 	$	2.
; 
infile datalines;
input 
id 		$	1-3
age 		4-5
gender 	$ 	6
wt 			7-8
ht 			9-11
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;
    
data col_4;
infile datalines;
input 
id 		$	1-3
ht 			9-11
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

data col_5;
infile datalines;
input 
ht 			9-11
id 		$	1-3
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

* Mixed or Formatted input method
	1. absolute pointer
	2. relative pointer;

data abs_1;
infile datalines;
input 
@1		id 		$	3.
@4		age 		2.
@6		gender 	$ 	1.
@7		wt 			2.
@9		ht 			3.
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

data abs_2;
infile datalines;
input 
@1		id 		$	3.
@9		ht 			3.
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

data abs_3;
infile datalines;
input 
@9		ht 			3.
@1		id 		$	3.
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

data rel_1;
infile datalines;
input 
@1		id 		$	3.
+2		age 		2.
+0		gender 	$ 	1.
+3		wt 			2.
+1		ht 			3.
;
datalines;
101  23m   52 143
102  25f   45 130
103  26f   50 140
104  28m   60 154
105  29f   45 112
;
run;

data rel_2;
infile datalines;
input 
@1		id 		$	3.
+11		ht 			3.
@6		age 		2.
+0		gender 	$ 	1.
+3		wt 			2.
;
datalines;
101  23m   52 143
102  25f   45 130
103  26f   50 140
104  28m   60 154
105  29f   45 112
;
run;

data rel_3;
infile datalines;
input 
@1		id 		$	3.
+11		ht 			3.
;
datalines;
101  23m   52 143
102  25f   45 130
103  26f   50 140
104  28m   60 154
105  29f   45 112
;
run;

data rel_4;
infile datalines;
input 
@1		id 		$	3.
+0		age 		2.
+0		gender 	$ 	1.
+0		wt 			2.
+0		ht 			3.
;
datalines;
10123m52143
10225f45130
10326f50140
10428m60154
10529f45112
;
run;

* Line pointer methods;
data lp_4;
infile datalines;
input 
#1	@1		id 		$	3.
	+1		age 		2.
#2	@1		gender 	$ 	1.
	+0		wt 			2.
#3	@1		ht 			3.
;
datalines;
101 23 
m52
143
102 25
f45
130
103 26
f50
140
104 28
m60
154
105 29
f45
112
;
run;

/*
Informat ---> How to read your data
Format	 ---> Write your data

Non Standarad data:
amount 
1500.60
1,560.6
1,560.32 
input amount : comma8.2;
$ 1,560.60

2017/12/14
12/14/2017
14/12/2017
14Dec2017

22:25:26


Refernce date:
31 Dec 1959		---> -1
01 Jan 1960		---> 0
02 Jan 1960		---> 1
31 Dec 1960		---> 365

Time:
00:00:00     	---> 0
00:00:01		---> 1
00:01:00		---> 60

*/






















