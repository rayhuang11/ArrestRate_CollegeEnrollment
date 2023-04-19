*===============================================================================
* DDIV
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
set scheme s1mono 
global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

* Install packages
*cap ssc install listtex
*cap ssc install outreg2
******************************** Means table ***********************************
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

* Generate treatment indicator
gen D = after1986 * high_drug75
g post = after1986
g high_intensity = high_drug75

/* Part (b): replicate Panel A of Table 3 */
foreach v in "norm_ab_100000" "college_enrolled" {

	if "`v'"=="norm_ab_100000" {
		* xtreg norm_ab_100000 after1986 high_drug75 interact pop unemployment, fe vce(cluster statefip)
		local x = "ed"
		preserve
		collapse (mean) `v' after1986 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)
		summ norm_ab_100000, det
		loc ninefive = r(p95)
		replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
		gen D = after1986 * high_drug75
		g post = after1986
		g high_intensity = high_drug75
		reg `v' post high_intensity D, vce(cluster statefip)
		restore		
	}
	
	else if "`v'"=="college_enrolled" {
		local x = "wg"
		collapse (mean) `v' after1986 pop unemployment high_drug75 edsuppwt, by(statefip year)
		gen D = after1986 * high_drug75
		g post = after1986
		g high_intensity = high_drug75
		*reg `v' post high_intensity D [pweight=edsuppwt], vce(cluster statefip)
		reg `v' post high_intensity D [pweight=edsuppwt], vce(cluster statefip)
		
	}

	* Difference-in-differences specification for Panel A
	* reg `v' post high_intensity D, r // moved to if statements
	
	* Difference-in-differences
	lincom D
	local b_dd33_`x' = r(estimate)
	local s_dd33_`x' = r(se)
	
	* Difference in position 1-3
	lincom high_intensity + D
	local b_df13_`x' = r(estimate)
	local s_df13_`x' = r(se)
	
	* Difference in position 2-3
	lincom high_intensity
	local b_df23_`x' = r(estimate)
	local s_df23_`x' = r(se)
	
	* Difference in position 3-1
	lincom post + D
	local b_df31_`x' = r(estimate)
	local s_df31_`x' = r(se)
	
	* Difference in position 3-2
	lincom post
	local b_df32_`x' = r(estimate)
	local s_df32_`x' = r(se)

	* Coefficient in position 1-1 (post, high)
	lincom _cons + post + high_intensity + D
	local b_cf11_`x' = r(estimate)
	local s_cf11_`x' = r(se)

	* Coefficient in position 1-2 (post, low)
	lincom _cons + post
	local b_cf12_`x' = r(estimate)
	local s_cf12_`x' = r(se)

	* Coefficient in position 2-1 (pre, high)
	lincom _cons + high_intensity
	local b_cf21_`x' = r(estimate)
	local s_cf21_`x' = r(se)

	* Coefficient in position 2-2 (pre, low)
	lincom _cons
	local b_cf22_`x' = r(estimate)
	local s_cf22_`x' = r(se)
}

preserve

clear
set obs 6
* Row identifier
gen name 		= "Pre-1986" in 1
replace name 	= "Post-1986" in 3
replace name 	= "Difference" in 5

foreach x in "ed" "wg" {

	if "`x'"=="ed" {
		local j = 0
	}
	else if "`x'"=="wg" {
		local j = 3
	}
	
	* Column 1 or 4
	local k 		= `j'+1
	gen c`k' 		= `b_cf11_`x'' in 1
	replace c`k' 	= `s_cf11_`x'' in 2
	replace c`k' 	= `b_cf21_`x'' in 3
	replace c`k' 	= `s_cf21_`x'' in 4
	replace c`k' 	= `b_df31_`x'' in 5
	replace c`k' 	= `s_df31_`x'' in 6
	
	* Column 2 or 5
	local k 		= `j'+2
	gen c`k' 		= `b_cf12_`x'' in 1
	replace c`k' 	= `s_cf12_`x'' in 2
	replace c`k' 	= `b_cf22_`x'' in 3
	replace c`k' 	= `s_cf22_`x'' in 4
	replace c`k' 	= `b_df32_`x'' in 5
	replace c`k' 	= `s_df32_`x'' in 6

	* Column 3 or 6
	local k 		= `j'+3
	gen c`k' 		= `b_df13_`x'' in 1
	replace c`k' 	= `s_df13_`x'' in 2
	replace c`k'	= `b_df23_`x'' in 3
	replace c`k' 	= `s_df23_`x'' in 4
	replace c`k' 	= `b_dd33_`x'' in 5
	replace c`k' 	= `s_dd33_`x'' in 6

}

* Change format
tostring c*, replace force format(%9.4g)

* Add brackets to standard errors
foreach v of varlist c* {
	replace `v' = "(" + `v' + ")" if name==""
}

* Export table
listtex using "$outdir/ddiv/ddiv_high_low.tex", rstyle(tabular) replace
restore

******************************** IV table **************************************
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

* Gen var
gen D = after1986 * high_drug75
g post = after1986
g high_intensity = high_drug75
loc controls age age2 hispan faminc unemployment pop
*loc controls unemployment pop
label var post "Post-1986"
label var high_intensity "High drug arrest state"
label var norm_ab_100000 "Normalized arrest rate"

eststo ols: reghdfe college_enrolled norm_ab_100000 post high_intensity `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local Controls  "Y"
estadd local FE "Y"
estadd local Fstat "n/a"
eststo iv1: ivregress 2sls college_enrolled (norm_ab_100000=D) post high_intensity ///
	[pweight=edsuppwt], first vce(cluster statefip)
estadd local Controls  "N"
estadd local FE "N"
estadd local Fstat "15.92"
eststo iv2: ivregress 2sls college_enrolled (norm_ab_100000=D) post high_intensity ///
	`controls' [pweight=edsuppwt], first vce(cluster statefip)
estadd local Controls  "Y"
estadd local FE "N"
estadd local Fstat "15.92"
eststo iv3: ivregress 2sls college_enrolled (norm_ab_100000=D) post high_intensity ///
	`controls' i.year i.statefip [pweight=edsuppwt], first vce(cluster statefip)
estadd local Controls  "Y"
estadd local FE "N"
estadd local Fstat "20.22"
* Table
esttab ols iv1 iv2 iv3 using "$outdir/ddiv/iv.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: OLS and 2SLS Estimates Comparing Individuals from High vs Low Intensity States") /// 
	scalars("FE" "Controls" "Fstat") drop(*year* *statefip* `controls') /// 
	mtitles("OLS" "2SLS" "2SLS" "2SLS")
eststo clear


