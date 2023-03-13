*===============================================================================       
* Event study for high/low marijuana arrest (18) states looking at norm AB
*===============================================================================

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
set graphics on
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

******************************** Event study 1986 ******************************
use "cps_ucr_18_merged_extended_1986.dta", clear
drop if (age>24) | (age<18)
drop if sex == 2

preserve
* Collapse data
collapse (mean) norm_ab_100000 pop unemployment [pweight=edsuppwt], by(state year)
* Drop unbalanced states
drop if (state == 9) | (state == 14) | (state == 25) | (state == 33) | (state == 39) | (state == 40) | (state == 44)
xtset state year

summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
g treatment = 0
g treatment_new = 0
replace treatment = 1 if (norm_ab_100000 >= `percentile_75') & (year > 1986)
replace treatment_new = 1 if (norm_ab_100000 >= `percentile_75') 
* Controls
loc controls pop unemployment

* Use xtevent
xtevent norm_ab_100000 `controls', panelvar(state) timevar(year) policyvar(treatment) window(3) diffavg 
xteventplot, title("Treatment: high drug arrest states after 1986") /// 
	note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986." "High marijuana states defined to be states above 75th percentile" "Controls: population and unemployment at the state-year level." "Arrest rate normalized to per 100,000.")
graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_1986.png", replace

di "var-cov matrix"
mat list e(Vdelta) , nohalf
di "coefficient vector"
mat list  e(delta), nohalf
*svmat e(delta) e(Vdelta) , outsheet id gender race read write science using smauto1.csv , comma
restore 


preserve 
collapse (mean) norm_ab_100000 pop unemployment [pweight=edsuppwt], by(statefip year)

summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
g treatment = 0
g treatment_new = 0
replace treatment = 1 if (norm_ab_100000 >= `percentile_75') & (year > 1986)
replace treatment_new = 1 if (norm_ab_100000 >= `percentile_75') 
* Manual event-study
forvalues yr = 1981/1992{
	cap gen t`yr' = treatment_new * (year == `yr')
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

reg norm_ab_100000 t1982-t1985 t1986 t1987-t1992 i.year i.statefip, cluster(state)
coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("College enrolled, black adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test): `pval'" "Event time 0 = 1986") label ylabel(, format(%8.0g))

restore

******************************** Event study 2010 ******************************
use "cps_ucr_18_merged_2010.dta", clear
drop if (age>24) | (age<18)

preserve
* Collapse data
collapse (mean) norm_ab_100000 pop unemployment [pweight=edsuppwt], by(statefip year)
* Drop unbalanced states
drop if (state == 8) | (state == 48)
xtset state year

summ norm_ab_100000, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 
g treatment = 0
replace treatment = 1 if (norm_ab_100000 >= `percentile_75') & (year > 2010)

* Use xtevent
xtevent norm_ab_100000 `controls', panelvar(statefip) timevar(year) policyvar(treatment) window(4) diffavg
xteventplot, title("Treatment: high drug arrest states after 2010") ///
	note("Estimates of 2010 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 2010." "High marijuana states >= 75th percentile" "Controls: population and unemployment at the state-year level.")
graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_2010.png", replace

di "var-cov matrix"
mat list e(Vdelta) , nohalf
di "coefficient vector"
mat list  e(delta), nohalf
restore
