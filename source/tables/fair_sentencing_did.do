*===============================================================================
* Fair Sentencing Act DiD Analysis
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off
use "cps_educ_2000s.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Create indicator variables
g after2010 = 0
replace after2010 = 1 if year > 2010
g interaction = after2010*black
g age2 = age^2
egen stratum = group(statefip year)
g male = 0
replace male = 1 if sex == 1
g sex_interaction = after2010*male

*************************** Black/white counterfactual *************************

loc controls age age2 hispan faminc

* Run 3 DiD regressions
* 18-24, males
* using educ weights, cluster @ state level
preserve
drop if (age > 24) | (age<18)
drop if sex == 2

eststo simple: qui reg college_enrolled after2010 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t1.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD: Fair Sentencing Act, blacks vs whites") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. Males only. SEs clustered at state level. Still missing some demographic controls.") ///
	drop(`controls') nomtitles
eststo clear

restore

********************************** Male/female *************************************

* Run 3 DiD regressions
* 18-24, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if (age > 24) | (age<18)
drop if race != 200

eststo simple: qui reg college_enrolled after2010 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t2.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD Fair Sentencing Act, black males vs females") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Still missing some demographic controls.") ///
	drop(`controls') nomtitles
eststo clear

restore

************************* Black/white control experiment ***********************

* Run 3 DiD regressions
* 35-50, males
* using educ weights, cluster @ state level
preserve
drop if (age > 50) | (age < 35)
drop if sex == 2

eststo simple: qui reg college_enrolled after2010 black interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after2010 black interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t1_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD: Fair Sentencing Act, blacks vs whites, control experiment") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. Males only. SEs clustered at state level. AGES 35-50") ///
	drop(`controls') nomtitles
eststo clear

restore

************************* Male/female control experiment ***********************

* Run 3 DiD regressions
* 35-50, blacks. counterfactual: females
* using educ weights, cluster @ state level
preserve
drop if (age > 50) | (age < 35)
drop if race != 200

eststo simple: qui reg college_enrolled after2010 male sex_interaction [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after2010 male sex_interaction `controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE  "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/fair_sentencing_DiD_t2_control_experiment.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD Fair Sentencing Act, black males vs females, control experiment") scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. AGES 35-50") ///
	drop(`controls') nomtitles
eststo clear

restore
