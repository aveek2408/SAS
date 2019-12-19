/* 
Conditional Processing 
	If 
	If else 
	If else If 
	Nested IF else 
	If with do

syntax: 
	1. Only if 
		if <condition> then <action>; 

	2. If else 
		if <condition> then <action>;
			else <action2>;

	3. If else if 
		if <condition1> then <action1>;
			else if <condition2> then <action2>;
				else if <condition3> then <action3>;
					else <action4>;	

	4. if then do 
		if <condition> then do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;

	5. if then do 
		if <condition1> then do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;
		else then do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;

	5.  
		if <condition1> then do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;
		else <condition2> then do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;
		else do; 
			<action1>;
			<action2>;
				.
				.
				.
			<actionn>; 
		end;

*/

data class; 
set sashelp.class; 
if sex = "M" then weight1 = weight + 10;
if sex = "F" then weight1 = weight - 10;
run;


data class; 
set sashelp.class; 
if sex = "M" then weight1 = weight + 10;
else weight1 = weight - 10;
run;

data class; 
set sashelp.class; 
if sex = "M" then weight = weight + 10;
else weight = weight - 10;
run;

data class; 
set sashelp.class; 

if sex = "M" then do;
	weight = weight + 10;
	weight_desc = "+ 10";
end;

else do;
	weight = weight - 10;
	weight_desc = "- 10";
end;
run;

* 
Scenario - 1: 
	Given any name which consists of Upper case and lower case characters
		1. Find number of upper case and lower case values count 
			Upper case count store as a "caps" varaible
			Lower case count store as a "lows" varaible
		2. Keep final dataset with only three varaibles called as "name", "caps" & "lows"
example: 
	name = "Murali Krishna"
	name				caps 	lows
	Murali Krishna		2		11

Approach (business logic):
	1. Find upper case letters
	2. count them 
	3. store them in a caps variable
	4. repeat the same for lower case cahracter and store them in lows variable

Deatiled approach - 1:
	1. Assign caps and lows varaible values as "0".
	2. Fetch each character and check whether its a Upper case char or lower case 
	3. If it is upper case, then increment "caps" varaible by "1" value
	4. Else increment "lows" varaible by "1" value
	5. Repeat steps 2-4 for all the characters in my string

Deatiled approach - 2:
	1. Assign caps varaible value as "0".
	2. Fetch each character and check whether its a Upper case
	3. If it is upper case, then increment "caps" varaible by "1" value
	4. Repeat steps 2-3 for all the characters in my string
	5. calculate ttal length 
	6. calculats lows as length - caps

Note: 
	Ensure we are eliminating all the special characters like space , comma and all
;

data name;
name = "Murali Krishna";
caps = countc(compress(name), "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
lows = length(compress(name)) - caps;
run;

* retain statement; 

data name; 
name = "Murali Krishna";
	caps = 0; 
	lows = 0;

	first = substr(name,1,1);
	first_upper = upcase(first);

	if first = first_upper then caps = caps +1; 
	else lows = lows + 1;

run;


























































































