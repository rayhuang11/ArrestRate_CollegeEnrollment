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
set graphics off

global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures/pretrends"

*********************************************************************************
*********************************** 1986 ***************************************
use "cps_ucr_merged_1986.dta", clear
drop if (age > 24) | (age<18)

preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==0 & sex==1), ///
	title("College enrollment over time (males)") xline(1986) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/1986/college_enroll_byrace_1986.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/1986/college_enroll_bysex_1986.png", replace
restore

preserve
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled faminc, by(year black high_drug)
* High vs low drug arrest states
graph tw (line college_enrolled year if black==1 & high_drug==1) ///
	(line college_enrolled year if black==1 & high_drug==0), ///
	title("College enrollment over time, high/low drug arrests") /// 
	xline(1986) note(Sample limited to black males) /// 
	legend(label(1 "High drug arrests") label(2 "Low drug arrests"))
graph export "$fig_outdir/1986/college_enroll_bydrugarrests_1986.png", replace
restore

*** Plot covariates 
preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), ///
	title("Family income over time (males)") xline(1986) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/1986/faminc_byrace_1986.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/1986/faminc_bysex_1986.png", replace
restore

*********************************** 2010 ***************************************
clear
use "cps_ucr_merged_2010.dta", clear
drop if (age > 24) | (age<18)
* Limit plotting sample to 2004 and onwards 
drop if year < 2005

preserve
collapse (mean) college_enrolled faminc, by(year sex white black)
* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if white==1 & sex==1), ///
	title("College enrollment over time (males)") xline(2010) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/2010/college_enroll_byrace_2010.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(2010) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/2010/college_enroll_bysex_2010.png", replace
restore

preserve
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled faminc, by(year black high_drug)
* High vs low drug arrest states
graph tw (line college_enrolled year if black==1 & high_drug==1) ///
	(line college_enrolled year if black==1 & high_drug==0), ///
	title("College enrollment over time") xline(2010) /// 
	legend(label(1 "High drug arrests") label(2 "Low drug arrests")) ///
	note(Sample limited to black males)
graph export "$fig_outdir/2010/college_enroll_bydrugarrests_2010.png", replace
restore

*** Plot covariates 
preserve
collapse (mean) college_enrolled faminc, by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), ///
	title("Family income over time (males)") xline(2010) /// 
	legend(label(1 "Black") label(2 "White"))
graph export "$fig_outdir/2010/faminc_byrace_2010.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(2010) /// 
	legend(label(1 "Black males") label(2 "Black females"))
graph export "$fig_outdir/2010/faminc_bysex_2010.png", replace

restore
