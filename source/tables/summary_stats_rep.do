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

g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

g male = 0
replace male = 1 if sex == 1

g hs_grad = 0
replace hs_grad = 1 if educ >= 072

* Balance table
label var male "Male" // relabel varaiables 
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"

preserve
drop if educ == 1 // removing observations missing education
drop if (age > 24) | (age<18)

loc vars male black hs_grad college_enrolled
	
eststo pre_period: estpost summarize /// 
	`vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period: estpost summarize ///
	`vars' if post_law == 1 [aweight=edsuppwt]
esttab pre_period post_period using "$outdir/britton_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) ///
	title("Balance table") ///
	mtitle("Pre-period" "Post-period") label
eststo clear

restore
