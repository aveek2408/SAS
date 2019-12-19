/*
datbase = excel/access
connect  --- location of the file
select sheet/table
sas output loc --- library/sas dataset */

proc import dbms = excel 
	datafile = "C:\Batch_Aug12\Rawdata\class.xls"
	out = class_data(keep= Name Age)
	replace; /* You can use these options in any order */
sheet = "Demog";
run;

proc import dbms = excel 
	datafile = "C:\Batch_Aug12\Rawdata\School.xls"
	out = class_data
	replace;
sheet = "ABC";
Getnames = No; /* When no headers in excel sheet */
run;


proc import dbms = access 
	table = "marks"
	out = std_marks
	replace; /* You can use these options in any order */
database = "C:\Batch_Aug12\Rawdata\student.mdb";
run;
