/* 
first . and last. : 
	Whenever by varaibles used ---> first. and last. will be created on them

Example: 
proc sort data=new ; 
by name age; 
run;

first.name 
last.name 
first.age 
last.age 
*/

data test;
input ID NAME $; 
datalines; 
101 A
102 B
101 A
101 C
101 D
104 A
104 B
103 C
103 D
105 A
104 B
;
run;

* remove duplicates at a key level - alternative to nodupkey;
proc sort data=test out=test_sort; 
by id; 
run;

data test_sort_uniq;
	set test_sort; 
	by id; 
	if first.id; 
	* if first.id then output test_sort_uniq;
	* if first.id then output;
	* if first.id gt 0 then output;
	* if first.id gt 0 then output test_sort_uniq;
run;

* remove duplicates at a observation level - alternative to nodup/noduprec;
* Method - 1;
proc sort data=test out=test_sort; 
by id name; 
run;

data test_sort_uniq;
	set test_sort; 
	by id name; 
	if first.name; 
run;

* Method -2; 
data test_1; 
	set test;
	id_name = catx("_",id,name);
run;

proc sort data=test_1 out=test_1_sort; 
by id_name; 
run;

data test_1_sort_uniq (drop=id_name);
	set test_1_sort; 
	by id_name; 
	if first.id_name; 
run;

proc print data=test_sort_uniq; 
proc print data=test_1_sort_uniq; 
run;

* Class Task
Input dataset: 

ID	Name	Age	Location
101	A	32	Hyderabad
101	A	32	Chennai
101	A	32	Bangalore
102	B	32	Hyderabad
102	B	32	Chennai
103	C	31	Pune
103	C	31	Mumbai
103	C	31	Hyderabad
103	C	31	Delhi

Expected Output:
ID	Location
101	Bangalore & Chennai & Hyderabad
102	Chennai & Hyderabad 
103	Bangalore & Chennai & Delhi &Hyderabad
;


















