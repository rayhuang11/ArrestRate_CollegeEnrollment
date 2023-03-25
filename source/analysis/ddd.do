*===============================================================================
* Triple DiD
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
use "cps_ucr_18_merged_1986.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Generate an indicator for being a state with high drug arrests or low
summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
g ab_post_interact = norm_ab_100000*after1986

label var after1986 "Post-1986"
label var high_drug75 "High-drug arrest state"
label var ab_post_interact "Post-1986 x Drug arrest rate per 100000"
label var high_drug_post_interact "Post-1986 X High-drug arrest state"

******************************** DDD 1986 **************************************
* Set control variables
loc controls age age2 hispan faminc unemployment
loc indepen_vars after1986 black high_drug75 post_black /// 
	high_drug_black_interact high_drug_post_interact triple_interact

preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
*drop if (norm_ab_100000 > `percentile_25') & (norm_ab_100000 < `percentile_75')

eststo basic: qui reg college_enrolled_edtype `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE "N"
estadd local Demographic_controls  "N"
eststo controls: qui reg college_enrolled_edtype `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE "N"
estadd local Demographic_controls  "Y"
eststo fe: qui reghdfe college_enrolled_edtype `indepen_vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
esttab basic controls fe using "$outdir/ddd_1986.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: Triple DiD") scalars("State_yr_FE" "Demographic_controls") ///
	drop(`controls') nomtitles
eststo clear
restore
	