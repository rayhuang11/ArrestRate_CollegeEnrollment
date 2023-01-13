*===============================================================================       
* Event study
*===============================================================================

*********************************** Setup **************************************

graph set window fontface "Garamond"
graph set print fontface "Garamond"
set scheme s1mono 
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

******************************** Event study 1986 ******************************
use "cps_ucr_merged_1986.dta", clear
drop if (age>24) | (age<18)

preserve
* Collapse data
collapse (mean) ab, by(black year)
* Drop unbalanced states
*drop if (state == 9) | (state == 14) | (state == 25) | (state == 33) | (state == 39) | (state == 40) | (state == 44)
xtset black year

g treatment = 0
replace treatment = 1 if (black ==1) & (year > 1986)

* Use xtevent
xtevent ab, panelvar(black) timevar(year) policyvar(treatment) window(2) 
xteventplot, title("Treatment: high marijuana arrest states after 1986") note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986." "High marijuana states >= 75th percentile" "Controlling for population.")
*graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_1986.png", replace

restore
