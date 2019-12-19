/*
NATIONAL STUDENT CLEARINGHOUSE ENROLLMENT DATA: 
code      name                                state start 		end
001020-00 JACKSONVILLE STATE UNIVERSITY       AL 	8/26/2009 	12/12/2009
001020-00 JACKSONVILLE STATE UNIVERSITY       AL 	8/26/2009 	12/12/2009
001030-00 BISHOP STATE COMMUNITY COLLEGE      AL 	1/10/2011 	5/5/2011
001031-00 NORTHEAST ALABAMA COMMUNITY COLLEGE AL 	8/18/2008 	12/19/2008
001031-00 NORTHEAST ALABAMA COMMUNITY COLLEGE AL 	8/18/2008 	12/19/2008
001033-00 OAKWOOD UNIVERSITY                  AL 	8/20/2008 	12/5/2008
001047-04 TROY UNIVERSITY                     AL 	3/17/2008 	5/18/2008
001047-04 TROY UNIVERSITY                     AL 	5/27/2008 	7/27/2008

The data are structured with one row per enrollment period per student. The following variables are on the file:
The Office of Postsecondary Education (OPE) ID code for the school attended (presented here as CODE)
The name of the school attended (presented here as NAME)
The state in which the campus is located (STATE)
The start date of each enrollment period (START)
The end date of each enrollment period (END)
*/

*
Question:
MAP ENROLLMENT PERIODS TO SEMESTERS;

data college_data;
input 
	@1 	id $9. 
	@11 name  $35.
	@47 state $2. 
	@51 start : mmddyy10.
	@62 end : mmddyy10.
	;
format start end  mmddyy10.;
datalines;
001020-00 JACKSONVILLE STATE UNIVERSITY       AL 	8/26/2009 	12/12/2009
001020-00 JACKSONVILLE STATE UNIVERSITY       AL 	8/26/2009 	12/12/2009
001030-00 BISHOP STATE COMMUNITY COLLEGE      AL 	1/10/2011 	5/5/2011
001031-00 NORTHEAST ALABAMA COMMUNITY COLLEGE AL 	8/18/2008 	12/19/2008
001031-00 NORTHEAST ALABAMA COMMUNITY COLLEGE AL 	8/18/2008 	12/19/2008
001033-00 OAKWOOD UNIVERSITY                  AL 	8/20/2008 	12/5/2008
001047-04 TROY UNIVERSITY                     AL 	3/17/2008 	5/18/2008
001047-04 TROY UNIVERSITY                     AL 	5/27/2008 	7/27/2008
;
run;

*
Preparing Data for Analysis
Semesters tend to start and end around the same time year after year; 
this can be seen in the example using enrollment periods from The University of Texas at San Antonio, 
where the spring semesters start on 1/14, 1/12, 1/11, and 1/10 and 
end on 5/10, 5/9, 5/8, and 5/7. 

FASTCLUS requires numeric input, so dates are valid, but the
difference between 1/14/2008 and 1/12/2009 is 363 days. 
In order to identify clusters of start and end dates across years, it is necessary to set all start dates to the same year. 
Doing so in this case reduces the difference between 1/14 and 1/12 to 2 days. 
The code to create start and end dates that are scaled to the same starting year is shown below.
;
data college_data2 ;
 set college_data ;
 flat_start = mdy(month(start),day(start),2000) ;
 flat_end = mdy(month(end),day(end),2000+(year(end) - year(start))) ;
 format flat_start flat_end mmddyy10. ;
run ;

*
At this point, the data are ready for PROC FASTCLUS. 
Only the most basic syntax is necessary. 
MAXC has been set to 12, based on the assumption that most schools will have fewer than 12 semesters per year.
RADIUS has been set to 20 to allow for semesters less than three weeks (i.e., 21 days) long. 
;

proc fastclus data = college_data2 maxc = 12 radius = 20 out = final_clus noprint ;
 var flat_start flat_end ;
run ; 

data semesters ;
 set final_clus ;
 length semester $ 11 ;
 if cluster eq 1 then semester = catx(' ', "Spring", year(start)) ;
 else if cluster eq 2 then semester = catx(' ', "Summer", year(start)) ;
 else if cluster eq 3 then semester = catx(' ', "Fall", year(start)) ;
run ;
