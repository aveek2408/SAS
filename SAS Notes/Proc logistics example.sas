/* 
Consider a study on cancer remission (Lee; 1974). 
The data consist of patient characteristics and whether or not cancer remission occured. 
The following DATA step creates the data set Remission containing seven variables. 
The variable remiss is the cancer remission indicator variable with a value of 1 for remission and a value of 0 for nonremission. 
The other six variables are the risk factors thought to be related to cancer remission.

*/

data Remission;
   input remiss cell smear infil li blast temp;
   label remiss='Complete Remission';
   datalines;
1   .8   .83  .66  1.9  1.1     .996
1   .9   .36  .32  1.4   .74    .992
0   .8   .88  .7    .8   .176   .982
0  1     .87  .87   .7  1.053   .986
1   .9   .75  .68  1.3   .519   .98
0  1     .65  .65   .6   .519   .982
1   .95  .97  .92  1    1.23    .992
0   .95  .87  .83  1.9  1.354  1.02
0  1     .45  .45   .8   .322   .999
0   .95  .36  .34   .5  0      1.038
0   .85  .39  .33   .7   .279   .988
0   .7   .76  .53  1.2   .146   .982
0   .8   .46  .37   .4   .38   1.006
0   .2   .39  .08   .8   .114   .99
0  1     .9   .9   1.1  1.037   .99
1  1     .84  .84  1.9  2.064  1.02
0   .65  .42  .27   .5   .114  1.014
0  1     .75  .75  1    1.322  1.004
0   .5   .44  .22   .6   .114   .99
1  1     .63  .63  1.1  1.072   .986
0  1     .33  .33   .4   .176  1.01
0   .9   .93  .84   .6  1.591  1.02
1  1     .58  .58  1     .531  1.002
0   .95  .32  .3   1.6   .886   .988
1  1     .6   .6   1.7   .964   .99
1  1     .69  .69   .9   .398   .986
0  1     .73  .73   .7   .398   .986
;
run;

* The following invocation of PROC LOGISTIC illustrates the use of stepwise selection 
to identify the prognostic factors for cancer remission. ;

title 'Stepwise Regression on Cancer Remission Data';
   proc logistic data=Remission outest=betas covout;
      model remiss(event='1')=cell smear infil li blast temp
                   / selection=stepwise
                     slentry=0.3
                     slstay=0.35
                     details
                     lackfit;
      output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
   run;
   
    proc print data=betas;
      title2 'Parameter Estimates and Covariance Matrix';
   run;
   proc print data=pred;
      title2 'Predicted Probabilities and 95% Confidence Limits';
   run;
   
   */
  The data set pred created by the OUTPUT statement is displayed. 
  It contains all the variables in the input data set, the variable phat for the (cumulative)
  predicted probability, the variables lcl and ucl for the lower and upper confidence limits 
  for the probability, and four other variables (IP_1, IP_0, XP_1, and XP_0) for the PREDPROBS= 
  option. The data set also contains the variable _LEVEL_, indicating the response value to which phat, 
  lcl, and ucl refer. 
  
  For instance, for the first row of the OUTPUT data set, the values of _LEVEL_ and phat, lcl, 
  and ucl are 1, 0.72265, 0.16892, and 0.97093, respectively; 
  this means that the estimated probability that remiss=1 is 0.723 for the given explanatory variable values, and the corresponding 95% confidence interval is (0.16892, 0.97093). 
  The variables IP_1 and IP_0 contain the predicted probabilities that remiss=1 and remiss=0, respectively. 
  Note that values of phat and IP_1 are identical since they both contain the probabilities 
  that remiss=1. 
  The variables XP_1 and XP_0 contain the cross validated predicted probabilities that remiss=1 
  and remiss=0, respectively.
  */