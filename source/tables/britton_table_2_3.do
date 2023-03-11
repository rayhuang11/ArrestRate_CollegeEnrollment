*===============================================================================
* Britton Table 2, replication
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
*use "cps_educ.dta", clear
use "cps_ucr_18_merged_1986.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Create indicator variables
cap g after1986 = 0
cap replace after1986 = 1 if year > 1986
cap g interaction = after1986*black
cap g age2 = age * age
cap g male = 0
cap replace male = 1 if sex == 1
cap g sex_interaction = after1986*male

drop college_enrolled
gen college_enrolled = 0
replace college_enrolled = 1 if edtype == 02 | edtype == 01

********************************** Table 2 *************************************

loc controls age age2 hispan faminc unemployment

* Run 3 DiD regressions
* 18-24, males
* using educ weights, cluster @ state level
preserve
drop if (age > 24) | (age<18)
drop if sex == 2

* Create DiD table
eststo simple: reg college_enrolled after1986 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: reg college_enrolled after1986 black interaction `controls' /// 
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: reghdfe college_enrolled after1986 black interaction `controls' ///
	[pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton T2, DiD Impact of 1986 Act using white males") scalars("State_yr_FE" "Demographic_controls") ///
	postfoot("\tabnotes{3}{Estimates weighted using CPS October supplement weights. Robust standard errors clustered at state level. Controls: age, age-squared, Latino ethnicity, yearly state average unemployment rates, and (binned) family income.}") ///
	drop(`controls') nomtitles
eststo clear

restore

********************************** Table 3 *************************************

* Run 3 DiD regressions
* 18-24, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if (age > 24) | (age<18)
drop if race != 200

* Create DiD table
eststo simple: qui reg college_enrolled after1986 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction ///
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 male sex_interaction ///
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton T3, DiD Impact of 1986 Act using black females") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Estimates weighted using CPS October supplement weights." "Robust standard errors clustered at state level." "Controls: age, age-squared, Latino ethnicity," "yearly state average unemployment rates, and (binned) family income.") ///
	drop(`controls') nomtitles
eststo clear

restore

********************************************************************************

************************** Table 2, control experiment *************************

* Run 3 DiD regressions
* 35-50, males
* using educ weights, cluster @ state level
preserve
drop if (age > 50) | (age < 35)
drop if sex == 2

* Create DiD table
eststo simple: qui reg college_enrolled after1986 black interaction /// 
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 black interaction ///
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 black interaction /// 
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton T2, control experiment: males 35-50") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Estimates weighted using CPS October supplement weights." "Robust standard errors clustered at state level." "Controls: age, age-squared, Latino ethnicity," "yearly state average unemployment rates, and (binned) family income.") ///
	drop(`controls') nomtitles
eststo clear
restore

************************** Table 3, control experiment *************************

* Run 3 DiD regressions
* 35-50, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if (age > 50) | (age < 35)
drop if race != 200

* Create DiD table
eststo simple: qui reg college_enrolled after1986 male sex_interaction /// 		
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction /// 
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 male sex_interaction /// 
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton T3, control experiment: black females ages 35-50") /// 
	scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Estimates weighted using CPS October supplement weights." "Robust standard errors clustered at state level." "Controls: age, age-squared, Latino ethnicity," "yearly state average unemployment rates, and (binned) family income.") ///
	drop(`controls') nomtitles
eststo clear

restore
