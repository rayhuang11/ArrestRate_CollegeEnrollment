*===============================================================================       
* Fig 5 and 6
*===============================================================================

*********************************** Setup **************************************

version 17
set scheme s1mono

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/UCR_ICPSR/clean"
}
clear all
set more off
set maxvar 20000

* Convert csv to dta
import delim using "icpsr_ucr_all_yrs.csv", clear
save "icpsr_ucr_all_yrs.dta", replace 
use "icpsr_ucr_all_yrs.dta", clear

sort state year

*********************************** Fig 5 **************************************

xtset state year, yearly

gen treatment = .
replace treatment = 1 if year >= 1987
replace treatment = 0 if year <= 1986
drop if treatment == .

xtevent ab pop, panelvar(state) timevar(year) policyvar(treatment) window(3)
xtevent ab pop, policyvar(treatment) window(4) 
xteventplot

* Manual event-study
forvalues yr = 1981/1992{
	gen t`yr' = treatment * (year == `yr')
}

cap ssc install coefplots, replace

replace t1986 = 0

reg ab t1982-t1985 t1986 t1987-t1991 i.year i.state, cluster(state)


coefplot, omitted keep(t2*) vertical 
