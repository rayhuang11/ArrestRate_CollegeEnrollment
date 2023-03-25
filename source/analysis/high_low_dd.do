*===============================================================================
* Leveraging high / low drug arrests
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************
********************************** 1986 ***************************************
use "cps_ucr_18_merged_1986.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
g ab_post_interact = norm_ab_100000*after1986

label var after1986 "Post-1986"
label var high_drug75 "High-drug arrest state (AB)"
label var norm_ab_100000 "Drug arrest rate per 100000"
label var ab_post_interact "Post-1986 x Drug arrest rate per 100000"
label var high_drug_post_interact "Post-1986 X High-drug arrest state"

* Set control variables
loc controls age age2 hispan faminc unemployment

* Discrete treatment
preserve
summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
*drop if black == 0
*drop if (norm_ab_100000 > `percentile_25') & (norm_ab_100000 < `percentile_75')

* high_drug high_drug_post_interact / c.ab c.ab_post_interact
eststo simple: qui reg college_enrolled after1986 c.high_drug75 c.high_drug_post_interact ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 c.high_drug75 /// 
	c.high_drug_post_interact `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 c.high_drug75 ///
	c.high_drug_post_interact `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Individuals from High and Low Black Adult Drug Arrest States") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

* Continuous treatment
preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

eststo simple: qui reg college_enrolled after1986 c.norm_ab_100000 c.ab_post_interact ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 c.norm_ab_100000 /// 
	c.ab_post_interact `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 c.norm_ab_100000 ///
	c.ab_post_interact `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low_cont.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Using Normalized Black Adult Drug Arrest Rate as Continuous Treatment") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

*********************************** 2010 ***************************************
use "cps_ucr_18_merged_2010.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after2010*high_drug75
g triple_interact = after2010*black*high_drug75
g ab_post_interact = norm_ab_100000*after2010

label var after2010 "Post-2010"
label var high_drug75 "High-drug arrest state (AB)"
label var ab_post_interact "Post-2010 x Drug arrest rate per 100000"
label var high_drug_post_interact "Post-2010 X High-drug arrest state"
label var norm_ab_100000 "Drug arrest rate per 100000"

* Discrete treatment
preserve
summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2

loc independ_vars after2010 high_drug75 high_drug_post_interact

* high_drug high_drug_post_interact / c.ab c.ab_post_interact
eststo simple: qui reg college_enrolled_edtype `independ_vars' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled_edtype `independ_vars' /// 
	`controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled_edtype `independ_vars' /// 
	`controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_2010_high_low.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Comparing Individuals from High and Low Black Adult Drug Arrest States") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

* Continuous treatment
preserve
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2

eststo simple: qui reg college_enrolled_edtype after2010 c.norm_ab_100000 c.ab_post_interact ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled_edtype after2010 c.norm_ab_100000 /// 
	c.ab_post_interact `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled_edtype after2010 c.norm_ab_100000 ///
	c.ab_post_interact `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_2010_high_low_cont.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: DiD Estimates Using Normalized Black Adult Drug Arrest Rate as Continuous Treatment") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

********************************* 1986 JB **************************************
cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
* Use consistent years
drop if year < 1984

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
g jb_post_interact = norm_jb_100000*after1986

label var after1986 "Post-1986"
label var high_drug75 "High-drug arrest state (JB)"
label var norm_jb_100000 "JB Drug arrest rate per 100000"
label var jb_post_interact "Post-1986 x Drug arrest rate per 100000"
label var high_drug_post_interact "Post-1986 X High-drug arrest state"

* Discrete treatment
preserve
loc percentile_75 = r(p75) 
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

loc vars college_enrolled after1986 high_drug75 high_drug_post_interact
loc controls age age2 hispan faminc unemployment

eststo simple: qui reg `vars' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg `vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe `vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low_jb.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Comparing Individuals from High and Low Juvenile Drug Arrest States") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

* Continuous treatment
preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 16) // age in 1986
drop if sex == 2

loc vars college_enrolled after1986 norm_jb_100000 jb_post_interact
loc controls age age2 hispan faminc unemployment

eststo simple: qui reg `vars' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg `vars' `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe `vars'  `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low_jb_cont.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Using Normalized Black Juvenile Drug Arrest Rate as Continuous Treatment") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

* Control experiment (continuous treatment)
preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 1

loc vars college_enrolled after1986 norm_jb_100000 jb_post_interact
loc controls age age2 hispan faminc unemployment
eststo simple: qui reg `vars' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg `vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe `vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low_jb_cont_control_experiment_female.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Control Experiment Using Females: Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Using Normalized Black Juvenile Drug Arrest Rate as Continuous Treatment") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore

preserve
drop if ((1986 - year + age) > 50) | ((1986 - year + age) < 30) // age in 1986
drop if sex == 2

loc vars college_enrolled after1986 norm_jb_100000 jb_post_interact
loc controls age age2 hispan faminc unemployment
eststo simple: qui reg `vars' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg `vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe `vars'  `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low_jb_cont_control_experiment_old.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Control Experiment Using Females: Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Using Normalized Black Juvenile Drug Arrest Rate as Continuous Treatment") /// 
	scalars("State_yr_FE" "Demographic_controls") drop(`controls') nomtitles
eststo clear
restore
