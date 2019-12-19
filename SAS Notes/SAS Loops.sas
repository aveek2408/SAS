* SAS Loops 
	- DO loop 
	- Do While 
	- Do Until

;

/* Do Loop 
	
	do <Initialization> to <maximum value / limit>; (Internally increment value by 1)
		statement 1 ; 
		statement 2 ; 
		statement 3 ; 
	end;
*/

* Print all the numbers from 1 to 100; 

data number; 
	do number = 1 to 100;
		output;
	end;
run;

/* Do While Loop 
	
	initialization ; 

	do while (<condition>);
		statement 1 ; 
		statement 2 ; 
		statement 3 ; 
	end;
*/

* Print all the even numbers from 1 to 100;
data even; 
	even_number = 2;

	do while (even_number <=100);
		output; 
		even_number = even_number + 2; 
	end;
run;

/* Do Until Loop 
	
	initialization ; 

	do until (<condition>);
		statement 1 ; 
		statement 2 ; 
		statement 3 ; 
	end;
*/

* Print all the even numbers from 1 to 100;
data even; 
	even_number = 2;

	do until (even_number  > 100);
		output; 
		even_number = even_number + 2; 
	end;
run;

* Print all the even numbers from 1 to 100;
data number; 
	do number = 2 to 100 by 2;
		output;
	end;
run;



































