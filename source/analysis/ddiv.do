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
use "cps_ucr_18_merged_1986.dta", clear
set scheme s1mono 

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"



*********************************** DDIV ***************************************
egen stratum = group(statefip year)


drop if sex==2 // males only
gen age_1986 = age - (year - 1986) // construct age in 1986
* Keep ppl aged 18-24 or 28-34 in  1986
drop if (age_1986 < 18) | (age_1986 > 24 & age_1986 < 28) | (age_1986 > 34)
* Drop middle states
drop if (low_drug25==0 & high_drug75==0) //
* Generate post-period indicator
gen treat = (age_1986 >= 18 & age_1986 <=24 & black==1)
gen interact = treat*high_drug75 // gen treatment indicator

reg college_enrolled treat high_drug75 interact pop [pweight=edsuppwt], cluster(stratum)
reg faminc treat high_drug75 interact [pweight=edsuppwt], cluster(stratum)
reg educ treat high_drug75 interact [pweight=edsuppwt], cluster(statefip)

ivregress 2sls faminc (college_enrolled=interact) treat high_drug75, cluster(stratum)

* Create table
foreach v in "college_enrolled" "faminc" {

	if "`v'"=="college_enrolled" {
		local x = "ed"
	}
	else if "`v'"=="faminc" {
		local x = "wg"
	}

	* Difference-in-differences specification for Panel A
	reg `v' treat high_drug75 interact pop [pweight=edsuppwt], cluster(stratum)
	
	* Difference-in-differences
	lincom interact
	local b_dd33_`x' = r(estimate)
	local s_dd33_`x' = r(se)
	
	* Difference in position 1-3
	lincom high_drug75 + interact
	local b_df13_`x' = r(estimate)
	local s_df13_`x' = r(se)
	
	* Difference in position 2-3
	lincom high_drug75
	local b_df23_`x' = r(estimate)
	local s_df23_`x' = r(se)
	
	* Difference in position 3-1
	lincom treat + interact
	local b_df31_`x' = r(estimate)
	local s_df31_`x' = r(se)
	
	* Difference in position 3-2
	lincom treat
	local b_df32_`x' = r(estimate)
	local s_df32_`x' = r(se)

	* Coefficient in position 1-1 (post, high)
	lincom _cons + treat + high_drug75 + interact
	local b_cf11_`x' = r(estimate)
	local s_cf11_`x' = r(se)

	* Coefficient in position 1-2 (post, low)
	lincom _cons + treat
	local b_cf12_`x' = r(estimate)
	local s_cf12_`x' = r(se)

	* Coefficient in position 2-1 (pre, high)
	lincom _cons + high_drug75
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
gen name 		= "Aged 18-24 in 1986 and black" in 1
replace name 	= "Aged 28-34 in 1986" in 3
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
tostring c*, replace force format(%5.2f)
* Add brackets to standard errors
foreach v of varlist c* {
	replace `v' = "(" + `v' + ")" if name==""
}
* Export table
listtex using "$outdir/ddiv.tex", rstyle(tabular) replace
restore


************************** Checking parallel trends
collapse (mean) college_enrolled, by(year treat)
* Black vs white males college enrollment
graph tw (line college_enrolled year if treat==1) ///
	(line college_enrolled year if treat==0), ///
	title("College enrollment over time (males)") xline(1986) /// 
	legend(label(1 "Aged 18-24 in 1986 and black") label(2 "Aged 28-34 in 1986"))
*graph export "$fig_outdir/1986/college_enroll_byrace_1986.png", replace

* Manual event-study
forvalues yr = 1982/1992{
	cap gen t`yr' = treat * (year == `yr')
}

replace t1986 = 0
label var t1982 "-4"
label var t1983 "-3"
label var t1984 "-2"
label var t1985 "-1"
label var t1986 "0"
label var t1987 "1"
label var t1988 "2"
label var t1989 "3"
label var t1990 "4"
label var t1991 "5"
label var t1992 "6"

reg college_enrolled t19* i.year i.state [pweight=edsuppwt], cluster(stratum)

coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("College enrolled, black adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test): `pval'" "Event time 0 = 1986") label ylabel(, format(%8.0g))
*graph export "$outdir/eventstudy/eventstudy_black_punitiveness.png", replace

******************************* Old attempt ************************************


* Generate period indicator (not necesary)
forvalues yr = 1984/1992{
	gen t`yr' = year == `yr'
}

* Reduced form
g zt = z*after1986
reg college_enrolled after1986 zt [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
loc rho = e(b) // some element in the coefficient matrix

* First stage
reg s after1986 zt [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
loc pi = e(b) // some element in the coefficient matrix

* Beta, ratio of reduced / first
loc beta = `rho' / `pi'
di "Beta is " `beta'

* Using ivregress (make sure the coefficents match)
ivregress 2sls college_enrolled after1986 (c.black c.after1986#c.black = c.agdist c.after1986#c.agdist) ///
	[pweight=edsuppwt], vce(cluster statefip)
	
ivregress 2sls log_wage (education=D) post high_intensity, r


/*
* ECON 1630; Fall 2022, Problem Set 5 (Question 2)
* This version: 11/12/2022
* Author: Peter Hull 

clear all
set more off

* If needed, install command to export tables in .tex format
cap ssc install listtex
* If needed, install command to export regression output tables in .tex format
cap ssc install outreg2

********************************************************************************
********************************** ENVIRONMENT *********************************
********************************************************************************

* Set directories
global 	root 		"C:\Users\Peter Hull\Dropbox (Personal)"
global	maindir		"$root\Brown\Teaching\Fall2022\ProblemSets\PS5_Solutions"
global 	dtadir 		"$maindir\dta"
global	outdir 		"$maindir\out"

********************************************************************************
*********************************** ANALYSIS ***********************************
********************************************************************************

* Load dataset
use "$dtadir/inpres_data.dta", clear

* Construct age in 1974
gen age_1974 = 74-birth_year

* Keep children aged 2-6 or 12-17 in 1974
drop if (age_1974 < 2) | (age_1974 > 6 & age_1974 < 12) | (age_1974 > 17)

* Generate post-period indicator
gen post = age_1974 <=6

* Generate treatment indicator
gen D = post*high_intensity

/* Part (b): replicate Panel A of Table 3 */
foreach v in "education" "log_wage" {

	if "`v'"=="education" {
		local x = "ed"
	}
	else if "`v'"=="log_wage" {
		local x = "wg"
	}

	* Difference-in-differences specification for Panel A
	reg `v' post high_intensity D, r
	
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
gen name 		= "Aged 2 to 6 in 1974" in 1
replace name 	= "Aged 12 to 17 in 1974" in 3
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
tostring c*, replace force format(%5.2f)

* Add brackets to standard errors
foreach v of varlist c* {
	replace `v' = "(" + `v' + ")" if name==""
}

* Export table
listtex using "$outdir/q2_b.tex", rstyle(tabular) replace

restore

/* Part (c): check how things change with clustering */
reg education post high_intensity D, cluster(birth_region)
reg log_wage post high_intensity D, cluster(birth_region)

/* Part (d): duplicate the data and see what happens to SEs */
expand 2
reg education post high_intensity D, cluster(birth_region)
reg log_wage post high_intensity D, cluster(birth_region)
reg education post high_intensity D, r
reg log_wage post high_intensity D, r

/* Part (g): IV regression */
ivregress 2sls log_wage (education=D) post high_intensity, r

/* Part (i): overidentified 2SLS regression */
gen highnum_region=birth_region>3317
gen highnum_region_post=highnum_region*post
gen highnum_region_high=highnum_region*high_intensity 
gen highnum_region_D=highnum_region*D
ivregress 2sls log_wage (education=D highnum_region_D) post high_intensity highnum_region highnum_region_post highnum_region_high, r

/* Part (j): overidentified 2SLS regression */
ivregress 2sls log_wage (education=D) post high_intensity highnum_region highnum_region_post highnum_region_high, r

* checking the first stage
reg education D highnum_region_D post high_intensity highnum_region highnum_region_post highnum_region_high, r
/*
