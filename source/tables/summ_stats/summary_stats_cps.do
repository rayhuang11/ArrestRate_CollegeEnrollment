*===============================================================================       
* Summary statistics table, Britton (CPS)
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables/summ_stats"

********************************* 1986 Table ***********************************

use "cps_ucr_merged_1986.dta", clear
* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if educ > 80 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if educ > 80 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if educ == 091 | educ == 092
g four_yr_college = 0
replace four_yr_college = 1 if (educ > 80) & (educ != 091) & (educ != 092)

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-Black males)"
label var two_yr_college "Enrolled in 2-year coll."
label var four_yr_college "Enrolled in 4-year coll."

preserve
drop if educ == 1 // removing observations missing education
drop if (age > 24) | (age<18)

loc summ_vars male black hs_grad college_enrolled college_enrolled_black college_enrolled_notblack ///
	two_yr_college four_yr_college
loc presentation_table male black hs_grad college_enrolled ///
	four_yr_college
	
eststo pre_period1986: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period1986: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
/*
esttab pre_period post_period using "$outdir/cps_1986_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) ///
	title("Summary Statistics CPS 1986") ///
	mtitle("Pre-period" "Post-period") label nostar /// 
	note("SD in ()." "Sample limited to ages 18-24. Observations missing education data were dropped.")
eststo clear
*/
restore

********************************* 2010 Table ***********************************
use "cps_ucr_merged_2010.dta", clear

* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 2010
g post_law = 0
replace post_law = 1 if year >= 2010

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if educ > 80 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if educ > 80 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if educ == 091 | educ == 092
g four_yr_college = 0
replace four_yr_college = 1 if (educ > 80) & (educ != 091) & (educ != 092)

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-Black males)"
label var two_yr_college "Enrolled in 2-year coll."
label var four_yr_college "Enrolled in 4-year coll."

preserve
drop if educ == 1 // removing observations missing education
drop if (age > 24) | (age<18)

loc summ_vars male black hs_grad college_enrolled college_enrolled_black college_enrolled_notblack ///
	two_yr_college four_yr_college
loc presentation_table male black hs_grad college_enrolled ///
	four_yr_college
	
eststo pre_period2010: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period2010: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
esttab pre_period1986 post_period1986 pre_period2010 post_period2010 using "$outdir/cps_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) ///
	title("Summary Statistics CPS") ///
	mtitle("Pre-period 1986" "Pre-period 1986" "Pre-period 2010" "Post-period 2010") label nostar /// 
	note("SD in ()." "Sample limited to ages 18-24. Observations missing education data were dropped.")
eststo clear

restore
