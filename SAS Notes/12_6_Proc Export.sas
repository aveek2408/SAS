
PROC EXPORT DATA= SASHELP.CLASS(Keep = Name Sex Age Where = (Sex ="M"))  
            OUTFILE= "D:\Batch_July14\Outputs\Class_Export.xls" 
            DBMS=EXCEL
			REPLACE;
     SHEET="Students"; 
RUN;


PROC EXPORT DATA= SASHELP.CLASS(Keep = Name Sex Age Where = (Sex ="M")) 
            Table="Students"
            DBMS=ACCESS
			REPLACE;
Database = "D:\Batch_July14\Outputs\Class_Export_Access.mdb" ;
RUN;
