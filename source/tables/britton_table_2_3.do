*===============================================================================
* Britton Table 2, replication
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off
use "cps_educ.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Create indicator variables
g after1986 = 0
replace after1986 = 1 if year > 1986
g interaction = after1986*black
g age2 = age^2
egen stratum = group(statefip year)
g male = 0
replace male = 1 if sex == 1
g sex_interaction = after1986*male

********************************** Table 2 *************************************

loc controls age age2 hispan faminc

* Run 3 DiD regressions
* 18-24, males
* using educ weights, cluster @ state level
preserve
drop if (age > 24) | (age<18)
drop if sex == 2

eststo simple: qui reg college_enrolled after1986 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after1986 black interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton Table 2") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. Males only. SEs clustered at state level. Still missing some demographic controls.") ///
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

eststo simple: qui reg college_enrolled after1986 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after1986 male sex_interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton Table 3") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Still missing some demographic controls.") ///
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

eststo simple: qui reg college_enrolled after1986 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after1986 black interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/britton_table2_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton Table 2, control experiment") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. Males only. SEs clustered at state level. AGES 35-50.") ///
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

eststo simple: qui reg college_enrolled after1986 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after1986 male sex_interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/britton_table3_DiD_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Britton Table 3, control experiment") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. AGES 35-50.") ///
	drop(`controls') nomtitles
eststo clear

restore
