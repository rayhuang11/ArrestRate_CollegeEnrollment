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

******************************** Experiment ******************************
use "cps_ucr_18_merged_1986.dta", clear
drop if (age>24) | (age<18)
drop if sex == 2

g treatment = 0
replace treatment = 1 if (black == 1)

* run manual event study, xtevent only works on panel data
* Manual event-study
forvalues yr = 1982/1992{
	cap gen t`yr' = treatment * (year == `yr')
}

replace t1986 = 0
label var t1982 "-4"
label var t1983 "-3"
label var t1984 "-2"
label var t1985 "-1"
cap label var t1986 "0"
label var t1987 "1"
label var t1988 "2"
label var t1989 "3"
label var t1990 "4"
label var t1991 "5"
label var t1992 "6"

forvalues yr = 1982/1992{
	cap gen fe`yr' = 1 * (year == `yr')
}
drop fe1990

forvalues state = 1/52{
	cap gen fe_`state' = 1 * (state == `state')
}
drop fe_5

*reg college_enrolled t19* fe1985 fe1986 fe1987 fe_1-fe_45 [pweight=edsuppwt], cluster(state)

reg college_enrolled t1982-t1985 t1986 t1987-t1992 i.year i.state [pweight=edsuppwt], cluster(state)


coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("College enrolled, black adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test): `pval'" "Event time 0 = 1986") label ylabel(, format(%8.0g))
*graph export "$outdir/eventstudy/eventstudy_black_punitiveness.png", replace



******************************** Event study 1986 ******************************
use "cps_ucr_18_merged_1986.dta", clear

drop if (age>24) | (age<18)
drop if sex == 2

preserve
* Collapse data
collapse (mean) ab pop [pweight=edsuppwt], by(black year state more_punitive)
* Drop unbalanced states
*drop if (state == 9) | (state == 14) | (state == 25) | (state == 33) | (state == 39) | (state == 40) | (state == 44)
xtset black year

g treatment = 0
replace treatment = 1 if (black ==1) & (year > 1986) & (more_punitive ==1)

* Use xtevent
xtevent college_enrolled, panelvar(black) timevar(year) policyvar(treatment) window(2) 
xteventplot, title("Treatment: high marijuana arrest states after 1986") note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986." "High marijuana states >= 75th percentile" "Controlling for population.")
*graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_1986.png", replace

restore
