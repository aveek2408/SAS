DATA SCORES;
   INPUT ID TEST1-TEST3;
   TEST_AVE = MEAN(OF TEST1-TEST3);
   ROUND_ONE = ROUND(TEST_AVE);
   ROUND_TENTH = ROUND(TEST_AVE,.1);
   ROUND_TWO = ROUND(TEST_AVE,2);
DATALINES;
1  100 95 95
2  78 79 88
;
run;

*Using the ROUND function to group ages into 10-year intervals;
DATA DECADES;
   INFORMAT DOB MMDDYY10.;
   INPUT DOB @@;
   AGE = YRDIF(DOB,'01JAN2003'D,"ACTUAL");
   DECADE = ROUND(AGE + 5., 10);
   FORMAT DOB MMDDYY10.;
DATALINES;
10/21/1946 11/12/1956 6/7/2002 12/20/1966 3/6/1930 5/8/1980
11/11/1998 10/21/1990 5/5/1994 10/21/1992
;

**Primary functions: CEIL, FLOOR, INT, and ROUND;
DATA TRUNCATE;
   INPUT X @@;
   CEIL = CEIL(X);
   FLOOR = FLOOR(X);
   INT = INT(X);
   ROUND = ROUND(X);
DATALINES;
7.2 7.8 -7.2 -7.8
;

 ***Compute quiz average if 8 or more quizzes taken;

DATA QUIZ;
   INPUT QUIZ1-QUIZ10;
  
   IF N(OF QUIZ1-QUIZ10) GE 8 THEN QUIZ_AVE = MEAN(OF QUIZ1-QUIZ10);
DATALINES;
90 88 79 100 97 96 94 95 93 88
60 90 66 77 . . . 88 84 86
90 . . 90 90 90 90 90 90 90
;

*Computing a SUM and MEAN of a list of variables, only if there are no missing values;
 DATA NOMISS;
   INPUT X1-X3 Y Z;
   IF NMISS(OF X1-X3,Y,Z) EQ 0 THEN DO;
      SUM_VARS = SUM(OF X1-X3,Y,Z);
      AVERAGE = MEAN(OF X1-X3,Y,Z);
   END;
DATALINES;
1 2 3 4 5
9 . 8 7 6
8 8 8 8 8
;

*Computing a mean, median, and sum of eight variables, only if there are at least six non-missing values;

DATA SCORE;
   INPUT @1 (ITEM1-ITEM8)(1.);
   IF N(OF ITEM1-ITEM8) GE 6 THEN DO;
      MEAN = MEAN(OF ITEM1-ITEM8);
      MEDIAN = MEDIAN(OF ITEM1-ITEM8);
      SUM = SUM(OF ITEM1-ITEM8);
   END;
DATALINES;
12345678
1.3.5678
1...5678
;

*Program to read hourly temperatures and determine the  daily minimum and maximum temperature
***Primary functions: MIN and MAX;

DATA MIN_MAX_TEMP;
   INFORMAT DATE MMDDYY10.;
   INPUT DATE;
   INPUT TEMP1-TEMP24;
   MIN_TEMP = MIN(OF TEMP1-TEMP24);
   MAX_TEMP = MAX(OF TEMP1-TEMP24);
   KEEP MIN_TEMP MAX_TEMP DATE;
   FORMAT DATE MMDDYY10.;
DATALINES;
05/1/2002
38 38 39 40 41 42 55 58 60 60 59 62 66 70 75 77 60 59 58 57 54 52 51 50
05/02/2002
36 41 39 40 41 46 57 59 63 . 59 62 64 72 79 80 78 62 62 62 60 50 55 55
;


*Computing the three lowest golf scores for each player (using the SMALLEST function)
***Primary function: SMALLEST;

DATA GOLF;
   INFILE DATALINES MISSOVER;
   INPUT ID $ SCORE1-SCORE8;
   LOWEST = SMALLEST(1 ,OF SCORE1-SCORE8);
   NEXT_LOWEST = SMALLEST(2, OF SCORE1-SCORE8);
   THIRD_LOWEST = SMALLEST(3, OF SCORE1-SCORE8);
DATALINES;
001 100 98 . . 96 93
002 90 05 07 99 103 106 110
003 110 120
;



