* 
Infile options
1. dlm 
2. dsd 
3. missover
4. flowover 
5. stopover 
6. truncover 

Input options: 
1. @@
2. @
;


data student;
infile datalines dlm=",<#^ ";
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC#F,23,167 76
102,DEF,M^25,176<87
;
run;

data student;
infile datalines dlm="," dsd;
input
	std_id 		$
	name		$
	gender		$
	age
	height
	weight
;
datalines;
101,ABC,F,,167,76
102,DEF,,25,176,87
103,GHI,M,27,178,99
;
run;

* Shorten line; 
*flowover;
data student;
infile datalines dlm=",";
input
	std_id 		$
	name		$
	age
	gender		$
	height
	weight
;
datalines;
101,ABC,23,F,167,35
102,DEF,,M,176,87
103,GHI,26,F,167,56
;
run;


* stopover;
data student;
infile datalines dlm="," stopover;
input
	std_id 		$
	name		$
	age
	gender		$
	height
	weight
;
datalines;
101,ABC,23,F,167,35
102,DEF,,M,176,87
103,GHI,26,F,167,56
;
run;

* missover;
data student;
infile datalines dlm="," missover;
input
	std_id 		$
	name		$
	age
	gender		$
	height
	weight
;
datalines;
101,ABC,23,F,167,35
102,DEF,25,M,176
103,GHI,26,F,167,56
;
run;

* shorten length;
* flowover;
data numbers; 
infile "D:\SASUniversityEdition\myfolders\EdueMasters\input_data\numbers_input.txt";
input number 5.;
run;


* stopover;
data numbers; 
infile "D:\SASUniversityEdition\myfolders\EdueMasters\input_data\numbers_input.txt"
stopover;
input number 5.;
run;

* missover;
data numbers; 
infile "D:\SASUniversityEdition\myfolders\EdueMasters\input_data\numbers_input.txt"
missover;
input number 5.;
run;

* truncover;
data numbers; 
infile "D:\SASUniversityEdition\myfolders\EdueMasters\input_data\numbers_input.txt"
truncover;
input number 5.;
run;


* Mobile number 
Student Data 
	- Not Mandatory (missover)

Student ID
	- Mandatory (stopover)

Social Networking: 
	- Mobile (Mandatory) - 11 / 10
	- 7675
	- 7675043314
	- 07675043314

length = 11, first pisition = 0 then 2-11 (7675043314)
length = 10, then 1-10
length <10, then missing value
;













































































































