*===============================================================================
* ADAA DiD Analysis Using White Males / Black Females
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off
use "cps_educ.dta", clear
*use "cps_ucr_18_merged_1986.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Setup *************************************

* Create indicator variables
cap g after1986 = 0
cap replace after1986 = 1 if year > 1986
cap g interaction = after1986 * black
cap g age2 = age * age
cap g male = 0
cap replace male = 1 if sex == 1
cap g sex_interaction = after1986*male

label var after1986 "Post-1986"
label var interaction "Post-1986 X Black"
label var sex_interaction "Post-1986 X Male" 
label var male "Male"

********************************** Table 2 *************************************
loc controls age age2 hispan faminc //unemployment

* Run 3 DiD regressions
* 18-24, males
preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

* Create DiD table
eststo simple: reg college_enrolled after1986 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: reg college_enrolled after1986 black interaction `controls' /// 
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: reghdfe college_enrolled after1986 black interaction `controls' ///
	[pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Black and White Males") ///
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear

restore

********************************** Table 3 *************************************

* Run 3 DiD regressions
* 18-24, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if race != 200

* Create DiD table
eststo simple: qui reg college_enrolled after1986 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction ///
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 male sex_interaction ///
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Black Males and Females") /// 
	scalars("FE" "Controls") ///
	drop(`controls') nomtitles
eststo clear

restore

********************************************************************************

************************** Table 2, control experiment *************************

* Run 3 DiD regressions
* 35-50, males
* using educ weights, cluster @ state level
preserve
drop if ((1986 - year + age) > 50) | ((1986 - year + age) < 30) // age in 1986
drop if sex == 2

* Create DiD table
eststo simple: qui reg college_enrolled after1986 black interaction /// 
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after1986 black interaction ///
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 black interaction /// 
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) ///
	title("Control Experiment Using Males 30-50. Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Black and White Males") scalars("FE" "Controls") ///
	drop(`controls') nomtitles
eststo clear
restore

************************** Table 3, control experiment *************************

* Run 3 DiD regressions
* 35-50, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if ((1986 - year + age) > 50) | ((1986 - year + age) < 30) // age in 1986
drop if race != 200

* Create DiD table
eststo simple: qui reg college_enrolled after1986 male sex_interaction /// 		
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction /// 
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 male sex_interaction /// 
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) ///
	title("Control Experiment Using Blacks Aged 30-50. Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Black and Males and Females") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear

restore
