/* 
Data Cleaning 
Functions 
	- Character Functions
		- length & lengthc
		- upcase, lowcase & Propcase 
		- compbl
		- compress 
		- left, trim & strip
		- index, indexc & indexw
		- find, findc & findw
		- substr & scan
		- tranwrd, translate 
		- countw & countc 
		- compare
	- Numeric Functions
		- Mathematical 
		- Statistical 
		- Date & Time
			- date and time literals 
			- mdy
			- dhms 
			- day, month, year, hour, minute, second
			- yrdif 
			- yearcutoff (SAS Option)
			- Intnx & Intck
Use cases 
		- Lag and retain together with use case - Pending 
			
*/

* Data type conversion functions 
	put 	 ---> num to char
	input	 ---> char to Num
;

* all functions - https://support.sas.com/publishing/pubcat/chaps/59343.pdf;
* Modifiers - https://www.lexjansen.com/phuse/2016/cc/CC01.pdf;


* 
length 
syntax: 
	length(varaible) ---> occupied length & actual length;
;

data class; 
set sashelp.class; 
actual_length = length(name);
assigned_length = lengthc(name);
put actual_length;
run;

data zipcodes (drop=len); 
input zip_code : $5.;
len = length(zip_code);
if length(zip_code) = 5; 
datalines;
98108
01024
1234
15679
23456
2687
;
run;

data zipcodes (drop=len) bad_zipcodes; 
input zip_code : $5.;
len = length(zip_code);
if length(zip_code) = 5 then output zipcodes;
else output bad_zipcodes; 
datalines;
98108
01024
1234
15679
23456
2687
;
run;

proc print;
run;

proc contents data = sashelp.class out=class_prop; 
run;


data names;
input name &: $25.;
name_upper = upcase(name);
name_lower = lowcase(name);
name_proper = propcase(name);
datalines; 
murali Krishna TENAli
Om
PraKASh sakHAMuri 
Pankaj chacha
;
run;

* compbl - compress multiple blanks into a sngle blank
	compbl(string)
; 

data names;
infile datalines dlm=",";
input name &: $25.;
prop_name = propcase(name);
name_final = compbl(prop_name); 
datalines; 
murali    Krishna TENAli
Om
PraKASh  sakHAMuri 
Pankaj           chacha
;
run;

data names;
infile datalines dlm=",";
input name &: $25.;
name = compbl(propcase(name)); 
datalines; 
murali    Krishna TENAli
Om
PraKASh  sakHAMuri     
Pankaj           chacha
;
run;

data name;
first = "      Murali";
last = "krishna      "; 
surname = "tenali";
full_name = cat(first,"     ",last,surname);
name = compbl(full_name);
run;

* compress 
by default ---> compress eliminates spaces 
If user required, then we can take help of argument and compress any character 
compress(variable)
compress(variable, "character");

 
data names;
infile datalines dlm=",";
input name &: $25.;
name1 = compress(propcase(name)); 
name2 = compbl(propcase(name)); 
datalines; 
murali    Krishna TENAli
Om
PraKASh  sakHAMuri     
Pankaj           chacha
;
run;

data mobile;
infile datalines dlm=",";
input mobile_number &: $25.;
mobile_number = compress(mobile_number, "\*abc ");
datalines; 
76\75043314
76750433***14
76750433 14
7675abc043314
;
run;



data name;
first = "      Murali";
last = "krishna"; 
surname = "tenali";
full_name = cat(first," ",last,surname);
full_name = strip(compress(full_name,","));
run;

* left, trim & strip; 
data name;
first = "      Murali";
last = "krishna          "; 
surname = "tenali                 ";

first_1 = left(first);
last_1 = trim(last);
surname_1 = strip(surname);


run;

*  index, indexc, indexw
	find, findc, findw;

data name;
name = "Murali Krishna Tenali";
position_1 = index(name, "li");
position_2 = indexc(name, "rs");
run;

data string; 
input name &: $30.;
index_p  = index(name, "is");
indexc_p = indexc(name, "is");
indexw_p = indexw(name, "is");

datalines;
this is a presentation
is this a fruit
how is your health
Om prakash have bad habits
;
run;


data string; 
input name &: $30.;
find_p  = find(name, "is");
findc_p = findc(name, "is");
findw_p = findw(name, "is");

datalines;
this is a presentation
is this a fruit
how is your health
Om prakash have bad habits
;
run;

data string; 
input name &: $30.;

find_p  = find(name, "IS", "i");
findc_p = findc(name, "is");
findw_p = findw(name, "is");

datalines;
this is a presentation
is this a fruit
how is your health
Om prakash have bad habits
;
run;


DATA O_MODIFIER;
   INPUT STRING      $15. ;
   POSITION_1 = FINDC(STRING,'A');
DATALINES;
Capital A here 
Lower a here   
Apple          
;
run;

DATA O_MODIFIER;
   INPUT STRING      $15. ;
   POSITION_1 = FINDC(STRING,'Aa');
DATALINES;
Capital A here 
Lower a here   
Apple          
;
run;

DATA O_MODIFIER;
   INPUT STRING      $15. ;
   POSITION_1 = FINDC(STRING,'A', "i");
DATALINES;
Capital A here 
Lower a here   
Apple          
;
run;

DATA O_MODIFIER;
   INPUT STRING      $15. 
         @16 LOOK_FOR $1.;
   POSITION_1 = FINDC(STRING,look_for);
DATALINES;
Capital A here A
Lower a here   X
Apple          B
;
run;

DATA O_MODIFIER;
   INPUT STRING      $15. 
         @16 LOOK_FOR $1.;
   POSITION_1 = FINDC(STRING,look_for,"o");
DATALINES;
Capital A here A
Lower a here   X
Apple          B
;
run;

DATA O_MODIFIER;
   INPUT STRING      $15.
		 @16 age 	2. 
         @19 LOOK_FOR $1.;
   POSITION_1 = FINDC(STRING,look_for,"io");
DATALINES;
Capital A here 23 A
Lower a here   45 X
Apple          56 B
;
run;

* Substr
	Fetch a part of the string based on position and length
	substr(string, start_position, length)
;

data vehicle_number; 
input reg_number $10.;

datalines; 
TN22BU1906
AP09CK5049
TS09GH5561
;
run;


data reg_numbers;
	set vehicle_number; 
	state = substr(reg_number,1,2); 
	rto_number = substr(reg_number,3,2);
	ser_num = substr(reg_number,5,2);
	number_plate = substr(reg_number,7,4);
run;

data vehicle_number; 
input reg_number : $10.;

datalines; 
TN22BU1906
AP09CK007
TS09GH1
;
run;
data reg_numbers;
	set vehicle_number; 
	state = substr(reg_number,1,2); 
	rto_number = substr(reg_number,3,2);
	ser_num = substr(reg_number,5,2);
	number_plate = substr(reg_number,7);
run;

* substr left
	substr(string, start_position, length) = "string";

* 1. extract the 1st 2 characters
  2. Match the first 2 characters with "TS"
  3. Repalce if setp 2 is true 
; 

data vehicle_number_1; 
	set vehicle_number; 
	/* extarct */
	step_one = substr(reg_number, 1, 2);
	step_two = index(step_one, 'TS');
	/*step_three*/
	if step_two gt 0 then substr(reg_number, 1, 2) = "TN";	 
run;

* Code enhancement; 
data vehicle_number; 
	set vehicle_number; 
	if index(substr(reg_number, 1, 2), 'TS') gt 0 then 
		substr(reg_number, 1, 2) = "TN";	 
run;

/* scan 
	fetching words from a string based on delimiter. 
	default delimiter is "space"

	Syntax:
	scan(string, n, "delimiter")
	n --> either a +ve or -ve integer

	If n is +ve integer ---> read the words from left to right
	If n is -ve integer ---> read the words from right to left

	Till 9.2 ---> If you use scan function and create a variable 
		then the length of that variable is 200

	After 9.2 ---> the parent varibale length applied to all the 
		child variables created using scan function 
*/

data name;
full_name = "Murali Krishna Tenali";
first_name = scan(full_name, 1); 
middle_name = scan(full_name, 2);  
last_name = scan(full_name, 3); 

first_name_1 = scan(full_name, -3); 
middle_name_1 = scan(full_name, -2);  
last_name_1 = scan(full_name, -1); 
run;

data name;
full_name = "Murali,Krishna,Tenali";
first_name = scan(full_name, 1, ","); 
middle_name = scan(full_name, 2, ",");  
last_name = scan(full_name, 3, ","); 

first_name_1 = scan(full_name, -3, ","); 
middle_name_1 = scan(full_name, -2, ",");  
last_name_1 = scan(full_name, -1, ",");  
run;

/* Use case 
Given any scentence, find the number of words in that scentence
Provide the solution, without using countw

Output:
String									Count
this is the scan function example		6
this is a presentation					4
hello world								2
stop									1
*/


data count_words; 
input string &: $50.;
no_of_words = countw(string);

datalines;
this is the scan function example		
this is a presentation					
hello world								
stop									
;
run;

/* tranwrd
	translate a word 
	find and replace a word

	Syntax: 
	tranwrd(string, old, new)
*/

data count_words; 
input string &: $50.;
new_string = tranwrd(string, "this", "that");

datalines;
this is the scan function example		
this is a presentation					
hello world								
stop									
;
run;

/* translate
	translate a character 
	find and replace a character

	Syntax: 
	translate(string, new, old)
*/

data count_words; 
input string &: $50.;
new_string = translate(string, "this", "that");

datalines;
this is the scan function example		
this is a presentation					
hello world								
stop									
;
run;

/* 
"that" ---> "this"
	t ---> t
	h ---> h
	a ---> i 
	t ---> s

	t ---> t ---> s
	h ---> h
	a ---> i 


stop ----> stop ---> ssop 
this ----> shis
*/

data transalate; 
input name $;
new_name = translate(name, "123", "ABC");
datalines; 
A
B
C
D
E
F
;
run;

data compare; 
string1 = "Murali";
string2 = "Murali";
comp = compare(string1, string2);
run;

data compare; 
string1 = "Murali";
string2 = "murali";
comp = compare(string2, string1);
run;


data compare; 
string1 = "Murali";
string2 = "murali";
comp = compare(string2, string1, "i");
run;


data compare; 
string1 = "Murali";
string2 = "     murali";
comp = compare(string2, string1, "iL");
run;

* 
i  --> Ignore case 
L  --> Ignore leading spaces
k 
O
;




















































