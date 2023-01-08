*===============================================================================
* Testing pre-trends
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
set graphics on

global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

*********************************************************************************
*********************************** 1986 ***************************************
use "cps_ucr_merged.dta", clear
drop if (age > 24) | (age<18)

preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==0 & sex==1), ///
	title("College enrollment over time (males)") xline(1986) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/college_enroll_byrace_1986.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/college_enroll_bysex_1986.png", replace
restore

preserve
collapse (mean) college_enrolled faminc, by(year black high_drug)
* High vs low drug arrest states
graph tw (line college_enrolled year if black==1 & high_drug==1) ///
	(line college_enrolled year if black==1 & high_drug==0), ///
	title("College enrollment over time, high/low drug arrests") /// 
	xline(1986) /// 
	legend(label(1 "High drug arrests") label(2 "Low drug arrests"))
graph export "$fig_outdir/college_enroll_bydrugarrests_1986.png", replace
restore

*** Plot covariates 
preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), ///
	title("Family income over time (males)") xline(1986) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/faminc_byrace_1986.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/faminc_bysex_1986.png", replace
restore

*********************************** 2010 ***************************************
clear
cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
use "cps_educ_2000s.dta", clear
drop if (age > 24) | (age<18)
preserve
collapse (mean) college_enrolled faminc, by(year sex white black)

* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if white==1 & sex==1), ///
	title("College enrollment over time (males)") xline(2010) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/college_enroll_byrace_2010.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(2010) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/college_enroll_bysex_2010.png", replace
restore

preserve
collapse (mean) college_enrolled faminc, by(year black high_drug)
* High vs low drug arrest states
graph tw (line college_enrolled year if black==1 & high_drug==1) ///
	(line college_enrolled year if black==1 & high_drug==0), ///
	title("College enrollment over time") xline(2010) /// 
	legend(label(1 "High drug arrests") label(2 "Low drug arrests"))
graph export "$fig_outdir/college_enroll_bydrugarrests_2010.png", replace
restore

*** Plot covariates 
preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), ///
	title("Family income over time (males)") xline(2010) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/faminc_byrace_2010.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(2010) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/faminc_bysex_2010.png", replace

restore

