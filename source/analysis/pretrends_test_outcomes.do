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
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986

preserve
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year sex black)
* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==0 & sex==1), ///
	title("College enrollment over time (males)") xline(1986) /// 
	legend(label(1 "Black males") label(2 "White males")) ///
	ytitle("(Mean) College Enrolled") xtitle("Year")
graph export "$fig_outdir/1986/college_enroll_byrace_1986.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), ///
	title("College enrollment over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females")) ///
	ytitle("(Mean) College Enrolled") xtitle("Year")
graph export "$fig_outdir/1986/college_enroll_bysex_1986.png", replace
restore

* High vs low drug black ADULT arrest states
preserve
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year black high_drug75)
graph tw (line college_enrolled year if black==1 & high_drug75==1) ///
	(line college_enrolled year if black==1 & high_drug75==0), /// 
	legend(label(1 "High drug arrest states") label(2 "Low drug arrest states")) /// 
	ytitle("(Mean) College Enrolled") xtitle("Year") xline(1986)
graph export "$fig_outdir/1986/college_enroll_bydrugarrests_1986.png", replace
restore

* High vs low drug black JUVENILE arrest states
preserve
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled [pweight=edsuppwt], by(year high_drug75)
drop if year > 1992
* High vs low drug arrest states
graph tw (line college_enrolled year if high_drug75==1) ///
	(line college_enrolled year if high_drug75==0), /// 
	legend(label(1 "High drug arrest states") label(2 "Low drug arrest states")) /// 
	ytitle("(Mean) College Enrolled") xtitle("Year") xline(1986) xscale(range(1982 1992))
graph export "$fig_outdir/1986/college_enroll_bydrugarrests_jb_1986.png", replace
restore


*** Plot covariates
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
preserve
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), ///
	title("Family income over time (males)") xline(1986) /// 
	legend(label(1 "Black males") label(2 "White males")) ///
	ytitle("(Mean) Family Income") xtitle("Year")
graph export "$fig_outdir/1986/faminc_byrace_1986.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), ///
	title("Family income over time") xline(1986) /// 
	legend(label(1 "Black males") label(2 "Black females")) ///
	ytitle("(Mean) Family Income") xtitle("Year")
graph export "$fig_outdir/1986/faminc_bysex_1986.png", replace
restore

*********************************** 2010 ***************************************
clear
use "cps_ucr_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
* Limit plotting sample to 2004 and onwards 
drop if year < 2005

preserve
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year sex white black)
* Black vs white males college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if white==1 & sex==1), ///
	title("College enrollment over time (males)") xline(2010) /// 
	legend(label(1 "Black males") label(2 "White males")) /// 
	ytitle("(Mean) College Enrolled") xtitle("Year")
graph export "$fig_outdir/2010/college_enroll_byrace_2010.png", replace

* Black males vs black females college enrollment
graph tw (line college_enrolled year if black==1 & sex==1) ///
	(line college_enrolled year if black==1 & sex==2), xline(2010) /// 
	legend(label(1 "Black males") label(2 "Black females")) ///
	ytitle("(Mean) College Enrolled") xtitle("Year")
graph export "$fig_outdir/2010/college_enroll_bysex_2010.png", replace
restore

* High vs low drug black adult arrest states
preserve
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year black high_drug75)
graph tw (line college_enrolled year if black==1 & high_drug75==1) ///
	(line college_enrolled year if black==1 & high_drug75==0), ///
	legend(label(1 "High drug arrest states") label(2 "Low drug arrests states")) ///
	ytitle("(Mean) College Enrolled") xtitle("Year") xline(2010)
graph export "$fig_outdir/2010/college_enroll_bydrugarrests_2010.png", replace
restore

* High vs low drug black JUVENILE arrest states
preserve
use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 1986
drop if sex == 2
drop if black == 0
collapse (mean) college_enrolled [pweight=edsuppwt], by(year high_drug75)
* High vs low drug arrest states
graph tw (line college_enrolled year if high_drug75==1) ///
	(line college_enrolled year if high_drug75==0), /// 
	legend(label(1 "High drug arrest states") label(2 "Low drug arrest states")) /// 
	ytitle("(Mean) College Enrolled") xtitle("Year") xline(2010) 
graph export "$fig_outdir/2010/college_enroll_bydrugarrests_jb_2010.png", replace
restore

*** Plot covariates 
preserve
collapse (mean) college_enrolled faminc [pweight=edsuppwt], by(year sex black)
* Black vs white males family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==0 & sex==1), xline(2010) /// 
	legend(label(1 "Black males") label(2 "White males")) ///
	ytitle("(Mean) Family Income") xtitle("Year")
graph export "$fig_outdir/2010/faminc_byrace_2010.png", replace

* Black males vs black females family income
graph tw (line faminc year if black==1 & sex==1) ///
	(line faminc year if black==1 & sex==2), xline(2010) ///
	legend(label(1 "Black males") label(2 "Black females")) ///
	ytitle("(Mean) Family Income") xtitle("Year")
graph export "$fig_outdir/2010/faminc_bysex_2010.png", replace

restore


******************************** Arrest rate 1986 ***********************************
* Adult
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(year)

graph tw (line norm_ab_100000 year), xline(1986) /// 
	ytitle("(Mean) Adult Black Male Arrest Rate Per 100,000") xtitle("Year")
graph export "$fig_outdir/1986/ab.png", replace
restore

* Juvenile 
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
drop if year < 1984

preserve 
collapse (mean) norm_jb_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(year)

graph tw (line norm_jb_100000 year), xline(1986) /// 
	ytitle("(Mean) Adult Black Male Arrest Rate Per 100,000") xtitle("Year")
graph export "$fig_outdir/1986/jb.png", replace
restore

***************************** Arrest rate 2010 *********************************
* Adult
use "cps_ucr_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) 
drop if year < 2005

preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(year)
graph tw (line norm_ab_100000 year), xline(2010) /// 
	ytitle("(Mean) Adult Black Male Arrest Rate Per 100,000") xtitle("Year")
graph export "$fig_outdir/2010/ab.png", replace
restore

* Juvenile 
use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) 
drop if year < 2005

preserve 
collapse (mean) norm_jb_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(year)
graph tw (line norm_jb_100000 year), xline(2010) /// 
	ytitle("(Mean) Adult Black Male Arrest Rate Per 100,000") xtitle("Year")
graph export "$fig_outdir/2010/jb.png", replace
restore

set graphics on
