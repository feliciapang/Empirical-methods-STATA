********************************************************************************
* Empirical Methods in Economics 2
* Assignment 4
* Maria Hajman, Felicia Pang, Anna Maria Roubert
*******************************************************************************

*******************************************************************************
* For question 1 & 2, please see PDF-file */				  
*******************************************************************************

clear all
cd "C:\Users\anro0293\Downloads"
set more off

* Open the data set	
use "pums80.dta"

ssc install estout, replace //* Installing estout. *//

*******************************************************************************
* Question 3 a				  
*******************************************************************************
 
ttest morekids, by(samesex) //* Two sample t-test, mean and standard error *//  

*******************************************************************************
* Question 3 b			  
*******************************************************************************

eststo clear
estpost ttest morekids kidcount workedm weeksm1, by(samesex) //* Mean and standard error *//
esttab using "Table3b.doc", cell ("b se") nomtitle nonumber //* Exporting the table *//

*******************************************************************************
* Question 3 c		  
*******************************************************************************

*Worked for pay
sum workedm if samesex==1 //* Summarize "worked for pay" when both kids are of the same sex. *//
scalar wp1=r(mean) 

sum workedm if samesex==0 //* Summarize "worked for pay" when both kids are not of the same sex. *//
scalar wp0=r(mean)

scalar wd1=wp1-wp0
di wd1 //* This command displays the calculation. *//

*Weeks worked
sum weeksm1 if samesex==1 //* Summarizes "weeks worked" if both kids are of the same sex. *//
scalar ww1=r(mean)

sum weeksm1 if samesex==0  //* Summarizes "weeks worked" if both kids are not of the same sex. *//
scalar ww0=r(mean)

scalar wd2=ww1-ww0
di wd2 //* This command displays the calculation. *//

* More kids
sum morekids if samesex==1 //* Summarizes "more kids" if both kids are of the same sex. *//
scalar mk1=r(mean)

sum morekids if samesex==0 //* Summarizes "more kids" if both kids are not of the same sex. *//
scalar mk0=r(mean)

scalar mkdiff=mk1-mk0
di mkdiff //* This calculation dispays the difference between samesex==1 and samesex==0. *//

* Calucation for the Beta-coefficient for the different y's
scalar Laboursupply1=wd1/mkdiff //* Calculation for labour supply when "worked for pay" is the y-variable. *//
di Laboursupply1
 
scalar Laboursupply2=wd2/mkdiff //* Calculation for labour supply when "weeks worked" is the y-variable. *//
di Laboursupply2

* See PDF for table. 

*******************************************************************************
* Question 3 d		  
*******************************************************************************

eststo clear
eststo: reg morekids samesex //* First stage regression *//
eststo: ivregress 2sls workedm (morekids = samesex) //* IV when y = working for pay *//
eststo: ivregress 2sls weeksm1 (morekids = samesex) //* IV when y = weeks worked*//

esttab using "Table3D.doc", ///
keep(morekids samesex) se star(* 0.10 ** 0.05 *** 0.01) ///
mlabels("First" "IV WorkPay" "IV WeeksWorked") ///
title("IV analyses") stats(N ymean) compress ///
cells( b(star fmt(4)) se(par fmt(3)) ) replace //* Exporting the result into a table *//

*******************************************************************************
* Question 3 e	  
*******************************************************************************

eststo clear

eststo: ivregress 2sls workedm (morekids = samesex) //* IV when y= working for pay without control variables*//
eststo: ivregress 2sls workedm agem1 agefstm boy1st boy2nd black hispan othrace (morekids = samesex) //* IV when y= working for pay with control variables*//
eststo: ivregress 2sls weeksm1 (morekids = samesex) //* IV when y= weeks worked without control variables*//
eststo: ivregress 2sls weeksm1 agem1 agefstm boy1st boy2nd black hispan othrace (morekids = samesex) //* IV when y= weeks worked with control variables*//

esttab using "Table3E.doc", ///
keep(morekids) se star(* 0.10 ** 0.05 *** 0.01) ///
mlabels("WPnC" "WPC" "WWnC" "WWC") /// //* WPnC = Worked for pay without control variables, WPC = Worked for pay with control variables, WWnC = Weeks worked without control variables, WWC = Weeks worked with control variables *//
title("IV analyses") stats(N ymean) compress ///
cells( b(star fmt(4)) se(par fmt(3)) ) replace //* Exporting the result into a table *//

*******************************************************************************
