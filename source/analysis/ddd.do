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
summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

* Create indicator variables
g high_drug_black_interact = black*high_drug50
g high_drug_post_interact = after1986*high_drug50
g triple_interact = after1986*black*high_drug50
g ab_post_interact = ab*after1986

******************************** DDD 1986 **************************************
* Set control variables
loc controls age age2 hispan faminc unemployment

*didregress (satis) (procedure), group(hospital) time(month)
preserve
drop if (age > 24) | (age<18)
drop if sex == 2
drop if (ab > `percentile_25') & (ab < `percentile_75')

eststo basic: qui reg college_enrolled after1986 black high_drug50 ///
	post_black high_drug_black_interact high_drug_post_interact  ///
	triple_interact [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE "N"
estadd local Demographic_controls  "N"
eststo controls: qui reg college_enrolled after1986 black high_drug50 ///
	post_black high_drug_black_interact high_drug_post_interact  ///
	triple_interact `controls' [pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE "N"
estadd local Demographic_controls  "Y"
eststo fe: qui reghdfe college_enrolled after1986 black high_drug50 ///
	post_black high_drug_black_interact high_drug_post_interact triple_interact ///
	`controls' [pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
esttab basic controls fe using "$outdir/ddd_1986.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DDD 1986") /// 
	scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Highdrug50" "Controls: age, age squared hispanic, family income, state unemployment.") ///
	drop(`controls') nomtitles
eststo clear
restore
	