* Data Extract 
	- File system
	
	1. List input (or) Fixed input 
		- delimted input file 
		- default delimiter is "Space"
		- any character or Spl char can be a delimiter 
		- works only if input file is a deliited file
		- can't change the order of variables 
		- Can't skip any variables - Need to read all varaibles 
		
	2. Column input
	3. Formatted (or) Mixed input 
		- Absolute pointer 
		- Relative pointer 

	SUGI
;

* file name = path & name - /folders/myfolders/EdueMasters/input_data/student.txt;

data student;
infile "/folders/myfolders/EdueMasters/input_data/student.txt";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
run;

* How SAS Works?;

* population 
  sample 
;

data student;
infile datalines;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;


data student;
infile cards;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
cards;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;


* datalines / cards / lines (till sas9.2 version);

data student;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;


data student;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
run;


data student;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;

data student;
infile datalines dlm="*|,";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC*F,23*167,76
102,DEF,M,25|176|87
;
run;

data student;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
length std_id $3. gender $1.;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;

data student;
length std_id $3. gender $1.;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;

* 
1. Why length should be the first statement?
2. Why the order of the variables are changed? 

length (optional)
infile 
input 
;

data student;
infile datalines dlm=",";
input
	std_id 		$
	gender		$
	weight
;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;



data student;
infile datalines dlm=",";
input
	std_id 		$
	age
	height
	weight
	name		$
	gender		$
;
length std_id $3. gender $1.;
datalines;
101,ABC,F,23,167,76
102,DEF,M,25,176,87
;
run;


* Column input method;
data student;
input
	std_id 		$	1-3
	name		$   4-6
	gender		$   7
	age				8-9
	height			10-12
	weight			13-14
;
datalines;
101ABCF2316776
102DEFM2517687
;
run;

* 
1-3 	---> id
4-6 	---> name
7 		---> gender 
8-9 	---> age
10-12 	---> height
13-14 	---> weight
;


data student;
input
	std_id 		$	1-3
	age				8-9
	height			10-12
	weight			13-14
	gender		$   7
	name		$   4-6
;
datalines;
101ABCF2316776
102DEFM2517687
;
run;


data student;
input
	std_id 		$	1-3
	age				8-9
	gender		$   7
;
datalines;
101ABCF2316776
102DEFM2517687
;
run;

data student;
input
	std_id 		$	1-3
	name		$   5-7 
	gender		$ 	9
	age				11-12
	height			14-16
	weight			18-19
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;


data student;
input
	std_id 		$	1-3
	age				8-9
	height			10-12
	weight			13-14
	gender		$   7
	name		$   4-6
;
datalines;
101ABC   F2316776
102DEFGHIM2517687
;
run;


* Formatted Input (or) Mixed Input method
	1. Absolute pointer
	2. Relative Pointer 
;


data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	@4	name		$	3.
	@7	gender 		$	1.
	@8	age				2.
	@10	height			3.
	@13	weight 			2.
;
datalines;
101ABCF2316776
102DEFM2517687
;
run;

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	@5	name		$	3.
	@9	gender 		$	1.
	@11	age				2.
	@14	height			3.
	@18	weight 			2.
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;
 

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	@5	name		$	3.
	@5	gender 		$	1.
	@11	age				2.
	@14	height			3.
	@18	weight 			2.
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	@11	age				2.
	@14	height			3.
	@18	weight 			2.
	@5	name		$	3.
	@9	gender 		$	1.
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	@9	gender 		$	1.
;
datalines;
101 ABC F 23 167 76
102 DEF M 25 176 87
;
run;

* Relative pointer method; 

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	+1	name		$	3.
	+2	gender 		$	1.
	+1	age				2.
	+1	height			3.
	+1	weight 			2.
;
datalines;
101 ABC  F 23 167 76
102 DEF  M 25 176 87
;
run;

data student; 
infile datalines;
input 
	@1	student_id	$	3.	
	+15	weight 			2.
;
datalines;
101 ABC  F 23 167 76
102 DEF  M 25 176 87
;
run;

* named input - assignment;
* Use of line pointers; 
data student; 
infile datalines;
input 
#1	@1	student_id	$	3.	
	@5	name		$	3.
#2	@1	gender 		$	1.
	@3	age				2.
	@6	height			3.
	@10	weight 			2.
;
datalines;
101 ABC  
F 23 167 76
102 DEF  
M 25 176 87
;
run;


data student; 
infile datalines;
input 
#1	student_id	$		
	name		$	
#2	gender 		$	
	age				
	height			
	weight 			
;
datalines;
101 ABC  
F 23 167 76
102 DEF  
M 25 176 87
;
run;

/* 
Infile options:
	1. flowover
	2. missover
	3. truncover
	4. stopover
	5. dlm 
	6. dsd

Input options:  
	1. @@
	2. @
*/

data student;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC F,23,167,76
102,DEF,M,25,176,87
;
run;

* 	Little SAS 
	SAS Programming made easy 
;
