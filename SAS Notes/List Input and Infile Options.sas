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























