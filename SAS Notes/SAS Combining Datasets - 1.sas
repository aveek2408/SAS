* Combining SAS Datasets

- Vertical
	- Concatenation 
	- Interleaving 
- Horizontal
	- one to one reading 
	- one to one merging
	- match merging 

- If we perform joining the tables horizontally using datastep then we call it as SAS Merges
- A sort is required before we go with the merging datasets 
;

/* Concatenation: 
	Appending one dataset to other. 
	Syntax: 
		data concat; 
			set inp_ds1 inp_ds2 .... inp_dsn;
		run;
*/
data super_market1;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
01Oct2019 20000
03Oct2019 12000
05Oct2019 40000
;
run;

data super_market2;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
02Oct2019 30000
04Oct2019 18000
;
run;

data super_market3;
input run_date : date9. sales_amount;
format run_date : date9. sales_amount comma20.2;
datalines; 
29Sep2019 32000
30Sep2019 48000
05Oct2019 40000
;
run;

data super_market_total;
set super_market1 super_market2 super_market3;
run;

proc sort data=super_market_total;
by run_date;
run;

/* Interleaving: 
	Appending one dataset to other with sorting option
	Concatenation with a "by" statement (Sort option)
	Syntax: 
		data interleave; 
			set inp_ds1 inp_ds2 .... inp_dsn;
			by by_variable1 by_variable2 ... by_variablen;
		run;
*/


proc sort data=super_market1; 
by run_date;
run;
proc sort data=super_market2; 
by run_date;
run;
proc sort data=super_market3; 
by run_date;
run;

data super_market_total_1;
set super_market1 super_market2 super_market3;
by run_date;
run;

/* One to one reading 
	Which will merge the datasets based on observations. 
	1st observation of first dataset merges with first observation of second dataset 
	and keeps going on. 

	Number of rows in my final dataset is equal to number of rows from a
	small dataset.

	Varaibles from all datasets present in my output datasets.

Sytax: 
	data one_2_one_read; 
		set one;
		set two; 
	run;

*/

data one; 
input Emp_ID $ Name $ Age Location $;
datalines;
101	abc	32	MA
102	def	33	MA
105	mno	34	NJ
106	pqr	26	NJ
109	ghi	28	WA
;
run;

data two; 
input Emp_ID $ Dept : $11. Salary;
datalines;
101	Finance		10000
106	Banking		20000
107	Health_Care 35000
102	Clinical	40000
;
run;

data one_2_one_read; 
	set one; 
	set two; 
run;

/* alternative approach bust still results are wrong */
proc sort data=one out=one_sort; by emp_id; run;
proc sort data=two out=two_sort; by emp_id; run;
data one_2_one_read; 
	set one_sort; 
	set two_sort; 
run;

/* 
One to one merging 
Merge datasets based on "By varaibles". 
All the observations & varibales from all the datasets present in the final table.
If there are any missing columns it loads them with missing values

Pre req: 
All the input datasets must be sorted on "By Variables" before merging 

Syntax: 
	data one_2_one_merge; 
		merge one two;
		by group_var1 group_var2 ... group_varn;
	run;
*/

proc sort data=one ; by emp_id; run;
proc sort data=two ; by emp_id; run;

data one_2_one_merge; 
	merge one two;
	by emp_id;
run;

/* 
Match merging 
Merge datasets based on "By varaibles" conditionally. 
All the varibales from all the datasets present in the final table.
Only the matching observations on "By variables" are part of my final table. 

Pre req: 
All the input datasets must be sorted on "By Variables" before merging 

Syntax: 
	data match_merge; 
		merge one two;
		by group_var1 group_var2 ... group_varn;
		<Conditions>
	run;

3 types of merges: 
	1. Inner join 
	2. Left Join 
	3. Right Join 
*/


proc sort data=one ; by emp_id; run;
proc sort data=two ; by emp_id; run;

* Inner join;

data match_merge_inner; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if a and b ; /* one.empid = two.empid */
run;

/* 	by emp_id age; 
	if one.empid = two.empid and one.age = two.age
*/

* Left join;

data match_merge_left; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if a  ; /* one.empid*/
run;


* Right join;

data match_merge_right; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if b  ; /* two.empid*/
run;



data match_merge_1; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if a and not b  ; 
run;

data match_merge_1; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if not a and  b  ; 
run;

data match_merge_1; 
	merge one (in=a)  two (in=b);
	by emp_id;
	if not a and not b  ; 
run;
