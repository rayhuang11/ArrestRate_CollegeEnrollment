*===============================================================================
* Testing pre-trends
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off

global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

*********************************** 1986 ***************************************
use "cps_educ.dta", clear
preserve
drop if (age > 24) | (age<18)
collapse (mean) college_enrolled faminc, by(year sex white black)
br
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if white==1 & sex==1), ///
	title("College enrollment over time (males)") xline(1986, lstyle(grid)) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/college_enroll_byrace_1986.png", replace

graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(1986, lstyle(grid)) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/college_enroll_bysex_1986.png", replace

*** Plot covariates 
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if white==1 & sex==1), ///
	title("Family income over time (males)") xline(1986, lstyle(grid)) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/faminc_byrace_1986.png", replace

graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(1986, lstyle(grid)) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/faminc_bysex_1986.png", replace
restore

*********************************** 2010 ***************************************
clear
use "cps_educ_2000s.dta", clear
preserve
drop if (age > 24) | (age<18)
collapse (mean) college_enrolled, by(year sex white black)

graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if white==1 & sex==1), ///
	title("College enrollment over time (males)") xline(2010, lstyle(grid)) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/college_enroll_byrace_2010.png", replace

graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(2010, lstyle(grid)) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/college_enroll_bysex_2010.png", replace

restore

