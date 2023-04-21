*===============================================================================
* Fair Sentencing Act DiD Analysis Using White Males / Black Females
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off
use "cps_educ_2000s.dta", clear
*use "cps_ucr_18_merged_2010.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Create indicator variables
cap g after2010 = 0
cap replace after2010 = 1 if year > 2010
cap g interaction = after2010*black
cap g age2 = age^2
cap g male = 0
cap replace male = 1 if sex == 1
cap g sex_interaction = after2010*male

label var after2010 "Post-2010"
label var interaction "Post-2010 X Black"
label var sex_interaction "Post-2010 X Male" 
label var male "Male"

*************************** Black/white counterfactual *************************

loc controls age age2 hispan faminc // unemployment

* Run 3 DiD regressions
* 18-24, males
* using educ weights, cluster @ state level
preserve
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2

eststo simple: qui reg college_enrolled after2010 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t1.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Comparing Black and White Males") scalars("FE" "Controls") ///
	drop(`controls') nomtitles
eststo clear

restore

********************************** Male/female *************************************

* Run 3 DiD regressions
* 18-24, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010

drop if race != 200

eststo simple: qui reg college_enrolled after2010 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t2.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Comparing Black Males and Females") scalars("FE" "Controls") ///
	addnote("Weights used. SEs clustered at state level. Still missing some demographic controls.") ///
	drop(`controls') nomtitles
eststo clear

restore

************************* Black/white control experiment ***********************

* Run 3 DiD regressions
* 30-50, males
* using educ weights, cluster @ state level
preserve
drop if ((2010 - year + age) > 50) | ((2010 - year + age) < 30) // age in 2010
drop if sex == 2

eststo simple: qui reg college_enrolled after2010 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t1_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Control Experiment Using Males 30-50. Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Comparing Black and White Males") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear

restore

************************* Male/female control experiment ***********************

* Run 3 DiD regressions
* 30-50, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if ((2010 - year + age) > 50) | ((2010 - year + age) < 30) // age in 2010
drop if race != 200

eststo simple: qui reg college_enrolled after2010 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "N"
eststo demographics: qui reg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local FE  "N"
estadd local Controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t2_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Control Experiment Using Black Males and Females 30-50. Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Comparing Black Males and Females") scalars("FE" "Controls") ///
	drop(`controls') nomtitles
eststo clear

restore
