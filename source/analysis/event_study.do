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

********************************** xtevent *************************************
use "cps_ucr_merged_1986.dta", clear
drop if (age>24) | (age<18)

preserve
collapse (mean) ab pop, by(state year)
drop if (state == 9) | (state == 14) | (state == 25) | (state == 33) | (state == 39) | (state == 40) | (state == 44)
xtset state year

summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
g treatment = 0
replace treatment = 1 if (ab >= `percentile_75') & (year > 1986)

xtevent ab pop, panelvar(state) timevar(year) policyvar(treatment) window(3) 
xteventplot, title("Treatment: high marijuana arrest states after 1986") note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986.")
graph export "$fig_outdir/eventstudy/high_marijuana_eventstudy.png", replace

restore

