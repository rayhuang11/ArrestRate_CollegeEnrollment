*===============================================================================       
* Summary statistics table, Britton
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

*********************************** Table **************************************

* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

g male = 0
replace male = 1 if sex == 1

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
label var male "Male" // relabel varaiables 
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"
label var two_yr_college "Enrolled in 2-year coll."
label var four_yr_college "Enrolled in 4-year coll."

preserve
drop if educ == 1 // removing observations missing education
drop if (age > 24) | (age<18)

loc summ_vars male black hs_grad college_enrolled college_enrolled_black college_enrolled_notblack ///
	two_yr_college four_yr_college
	
eststo pre_period: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
esttab pre_period post_period using "$outdir/britton_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) ///
	title("Balance table") ///
	mtitle("Pre-period" "Post-period") label
eststo clear

restore
