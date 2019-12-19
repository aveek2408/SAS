libname out "/folders/myfolders/Edureka/reference_datasets";


data out.mtcars;
informat cars $10.;
input cars$ mpg cyl disp hp drat;
format cars $6.;/*Format statement used to convert data to non standard form(user readable)*/
cards;/*cards used to insert instream data*/
mazdaRX4 21 6 160 110 3.9
mazdaRX4_wag 21 6 160 110 3.9
Datsun_710 22.8 4 108 93 3.85
;
run;


data out.mtcars1;
set out.mtcars (keep=cars mpg cyl);
run;

data out.mtcars0;
set out.mtcars (keep=cars mpg cyl);
price = mpg*100 + cyl*100;
format price dollar7.;
run;

data out.mtcars2;
set out.mtcars (drop=mpg cyl disp drat);
set out.mtcars0 (keep=price rename=(price=q_price));
qprice= qprice+0;
run;

proc sort data=out.mtcars1 out=mtcars1;
by cars;
proc sort data=out.mtcars2 out=mtcars2;
by cars;

data matchmerge_mtcars;
merge mtcars1 mtcars2;
by cars;
run;

