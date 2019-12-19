
/* Proc Transpose 
proc transpose data=inp_ds out=out_ds <options>;
<statements>;
run;

*/

data narrow_file1;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Blk    bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;

proc print; run;

proc transpose data=narrow_file1 out=default;
run;
proc print; run;


proc transpose data=narrow_file1 out=default_id;
id pet_owner;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id suffix = _new prefix=fraud_;
id pet_owner
;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
id pet_owner 
;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner;
run;
proc print; run;


proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner pet;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed;
;
var pet_owner pet;
id population;
run;
proc print; run;

proc transpose data=narrow_file1 out=default_id name=column_that_was_transposed
prefix=population_;
var pet_owner pet;
id population;
run;
proc print; run;


data narrow_file1;
infile cards;
length pet_owner $10 pet $4 population 4;
input pet_owner $1-10 pet $ population;
cards;
Mr. Black dog 2
Mr. Black bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;

proc transpose data=narrow_file1 out=default_1 ; 
id pet_owner; 
run;


proc transpose data=narrow_file1 out=default_1 let; 
id pet_owner; 
run;

proc print; run;
