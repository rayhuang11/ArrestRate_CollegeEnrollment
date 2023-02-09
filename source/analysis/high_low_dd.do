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
use "cps_ucr_18E_merged_1986.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Generate an indicator for being a state with high drug arrests or low
summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
g ab_post_interact = ab*after1986

*********************************** DD *****************************************
* Set control variables
loc controls age age2 hispan faminc unemployment

preserve
drop if (age > 24) | (age<18)
drop if sex == 2
drop if black == 0
drop if (ab > `percentile_25') & (ab < `percentile_75')

* high_drug high_drug_post_interact / c.ab c.ab_post_interact
eststo simple: qui reg college_enrolled after1986 c.ab c.ab_post_interact ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 c.ab c.ab_post_interact `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui reghdfe college_enrolled after1986 c.ab c.ab_post_interact `controls' ///
	[pweight=edsuppwt], absorb(state year) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD 1986, high vs low drug arrest states") /// 
	scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Dropped obs between 25 and 75th percentile" "Controls: age, age squared hispanic, family income, state unemployment.") ///
	drop(`controls') nomtitles
eststo clear
restore
