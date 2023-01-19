
*********************************** Setup **************************************

graph set window fontface "Garamond"
graph set print fontface "Garamond"
set scheme s1mono 
set scheme sj
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

********************************************************************************

use "cps_ucr_18_merged_1986.dta", clear
drop if (age>24) | (age<18)

preserve
* Collapse data
collapse (mean) ab pop [pweight=edsuppwt], by(state year)
tab state year
* Drop unbalanced states
drop if (state == 9) | (state == 14) | (state == 25) | (state == 33) | (state == 39) | (state == 40) | (state == 44)
xtset state year

loc percentile_25_states 1, 3, 11, 15, 16, 18, 23, 25, 28, 30, 33, 40, 43, 46, 47, 49, 50
loc percentile_50_states 4, 5, 6, 8, 12, 17, 19, 20, 21, 24, 26, 27, 31, 34, 37, 48
loc percentile_75_states 5, 8, 12, 19, 27, 31

g treatment = 0
replace treatment = 1 if (inlist(state, `percentile_50_states')) & (year > 1986)

* Use xtevent
xtevent ab pop, panelvar(state) timevar(year) policyvar(treatment) window(2) diffavg
xteventplot, title("Treatment: high marijuana arrest states after 1986") /// 
	note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986." "High marijuana states >= 75th percentile" "Controlling for population.")
*graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_1986.png", replace

di "var-cov matrix"
mat list e(Vdelta) 
di "coefficient vector"
mat list  e(delta) 
*svmat e(delta) , outsheet id gender race read write science using smauto1.csv , comma 

restore

******************************** Event study 2010 ******************************
use "cps_ucr_18_merged_2010.dta", clear
drop if (age>24) | (age<18)

preserve
* Collapse data
collapse (mean) ab pop [pweight=edsuppwt], by(state year)
* Drop unbalanced states
drop if (state == 8) | (state == 48)
xtset state year

summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
g treatment = 0
replace treatment = 1 if (ab >= `percentile_75') & (year > 2010)

* Use xtevent
xtevent ab pop, panelvar(state) timevar(year) policyvar(treatment) /// 
	window(4) diffavg
xteventplot, title("Treatment: high marijuana arrest states after 2010") note("Estimates of 2010 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 2010." "High marijuana states >= 75th percentile" "Controlling for population.")
*graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_2010.png", replace

di "var-cov matrix"
mat list e(Vdelta) 
di "coefficient vector"
mat list e(delta) 

restore
