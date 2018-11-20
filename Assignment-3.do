********************************************************************************
* Empirical Methods in Economics 2
* Assignment 3
* Maria Hajman, Felicia Pang, Anna Maria Roubert
*******************************************************************************

*******************************************************************************
* For question 1 & 2. please see PDF-file */				  
*******************************************************************************

*******************************************************************************
* Question 3 				  
*******************************************************************************
clear all
cd "C:\Users\anro0293\Downloads"
set more off

* Open the data set	
use "ada_jpe.dta"

* ----------------------------------------------- * 
* 				Data management                   *
* ----------------------------------------------- *
* Earnings are for the year before the survey 
gen yearw = year-1

* Creating dummy variables
gen white = race==100
gen black = race==200
gen hispanic = hispan>0
gen somehs = educrec<6
gen hsgrad = educrec==7
gen somecol = educrec==8
gen disabled = disabwrk==2
gen ada = yearw>=1992
gen weekly_earn = incwage/wkswork1
gen disabled_state = 100*disabled+statefip


label var yearw "Year of work"
label var white "dummy=1 if white"
label var black "dummy=1 if black"
label var hispanic "dummy=1 if hispanic"
label var hsgrad "dummy=1 if high school graduate"
label var somecol "dummy=1 if have some college"
label var ada "dummy=1 in 1992 and beyond"
label var disabled "dummy=1 if have work disability"
label var disabled_state "unique ID for disability status and state"
label var weekly_earn "Weekly wage"

* Create work-year and region dummy variables
xi i.yearw i.region i.age

* Create a dummy variable that tells you if the individual had a job at all
gen working = wkswork1>0
* Create a dummy variable=1 if the individual has education above high school
gen posths = educrec>7

label var working "Working"
label var age "Age"
label var white "White"
label var posths "Post-high school"
label var wkswork1 "Weeks worked"

/* Save the data set so that you can collapse it, analyse the collapsed
	data set and then retrieve the uncollapsed data set. */
save "ada_jpe_cleaned.dta", replace

ssc install estout, replace
eststo clear
*******************************************************************************
* 3a) Descr. stat. on mean of some variables for treatm. and control group in 1988 */				  
*******************************************************************************

estpost sum age white posths working wkswork1 if disabled==1 
esttab using "table3aa.doc", replace main(mean) brackets nonum ///
mtitles("Control Mean") title ("Desriptive Statistics - Disabled") label

estpost sum age white posths working wkswork1 if disabled==0
esttab using "table3ab.doc", replace main(mean) brackets nonum ///
mtitles("Control Mean") title ("Desriptive Statistics - Non-Disabled") label

*******************************************************************************
* 3b)  Trends in workweeks for the treatment and control groups */				  
*******************************************************************************
preserve
collapse (sum) wkswork1 ,by(yearw disabled)
graph twoway (line wkswork1 yearw if disabled==0) (line wkswork1 yearw if disabled==1)
graph save "Weeks worked year", replace
graph export "Weeks worked year.pdf", replace

*******************************************************************************
* 4a)  Difference-in-differences  (DD)regressions				  
*******************************************************************************
use "ada_jpe_cleaned.dta", replace /* Retrive the collapsed data */

gen AfterDisabled = ada * disabled /* New interaction term generated */

eststo clear

eststo: reg wkswork1 disabled ada AfterDisabled
esttab using "table4aa.doc"
*******************************************************************************
* 4b) Which coefficient is your DD-effect and how do you interpret this effect?				  
*******************************************************************************

/* Please see PDF-file */

*******************************************************************************
* 4c) Generate a new interaction dummy variable for each year Year × Disabled				  
*******************************************************************************
gen ada88 = yearw==1988
gen ada89 = yearw==1989
gen ada90 = yearw==1990
gen ada91 = yearw==1991
gen ada92 = yearw==1992
gen ada93 = yearw==1993
gen ada94 = yearw==1994
gen ada95 = yearw==1995
gen ada96 = yearw==1996

gen AfterDisabled88 = ada88 * disabled
gen AfterDisabled89 = ada89 * disabled
gen AfterDisabled90 = ada90 * disabled
gen AfterDisabled91 = ada91 * disabled
gen AfterDisabled92 = ada92 * disabled
gen AfterDisabled93 = ada93 * disabled
gen AfterDisabled94 = ada94 * disabled
gen AfterDisabled95 = ada95 * disabled
gen AfterDisabled96 = ada96 * disabled

eststo clear

eststo: reg wkswork1 disabled ada88 ada89 ada89 ada90 ada91 ada92 ada93 ///
ada94 ada95 ada96 AfterDisabled88 AfterDisabled89 AfterDisabled90 ///
AfterDisabled91 AfterDisabled92 AfterDisabled93 AfterDisabled94 ///
AfterDisabled95 AfterDisabled96 

esttab using "Table4c.doc", replace main(mean) brackets nonum ///
mtitles("Weeks worked") title ("Regression with interaction term Year x Disabled") label

*******************************************************************************
* 4d) What does the coefficients on treatment for years 1988-1992 show?				  
*******************************************************************************
/* Please see PDF-file.*/

*******************************************************************************
* 5)  Staggered DD			  
*******************************************************************************

/* Please see PDF-file. */



