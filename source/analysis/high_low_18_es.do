*===============================================================================       
* Event study for high/low drug arrest (18) states looking at normalized arrest rate
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
set graphics on
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

******************************** Event study 1986 ******************************
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by( year)

graph tw (line norm_ab_100000 year)

* Manual event-study
forvalues yr = 1980/1992{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t1986 = 0
cap label var t1980 "-6"
cap label var t1981 "-5"
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

* Winsorizing 
summ norm_ab_100000, det
loc ninefive = r(p95)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
drop if norm_ab_100000 > 1000 // should be 0 observations deleted 

*xtevent norm_ab_100000, repeatedcs panelvar(statefip) timevar(year) policyvar(high_drug75) window(2) cluster(statefip) diffavg plot
xtset statefip year
xtreg norm_ab_100000 t1984-t1992 pop unemployment, fe vce(cluster statefip)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986.png", replace
restore

* Appendix version
use "cps_ucr_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

* Manual event-study
forvalues yr = 1980/1992{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t1986 = 0
cap label var t1980 "-6 (1980)"
cap label var t1981 "-5"
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

* Winsorizing 
summ norm_ab_100000, det
loc ninefive = r(p95)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
drop if norm_ab_100000 > 1000 // should be 0 observations deleted 

xtset statefip year
xtreg norm_ab_100000 t1980-t1992 pop unemployment, fe vce(cluster statefip)
test t1980 t1981 t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986_extended_years.png", replace
restore

*** JB ver
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

preserve 
collapse (mean) norm_jb_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

* Manual event-study
forvalues yr = 1981/1992{
	cap gen t`yr' = high_drug75 * (year == `yr')
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

xtset statefip year
xtreg norm_jb_100000 t1982-t1992 pop unemployment i.year i.statefip, fe vce(cluster statefip)
test t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986_jb.png", replace

*xtevent norm_jb_100000, panelvar(statefip) timevar(year) policyvar(high_drug75) window(2) norm(-1) cluster(statefip) diffavg plot

restore

******************************** Event study 2010 ******************************
use "cps_ucr_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

* Manual ver
preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

forvalues yr = 2005/2015{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t2010 = 0
label var t2005 "-5"
label var t2006 "-4"
label var t2007 "-3"
label var t2008 "-2"
label var t2009 "-1"
cap label var t2010 "0"
label var t2011 "1"
label var t2012 "2"
label var t2013 "3"
label var t2014 "4"
label var t2015 "5"

reg norm_ab_100000 t2005-t2009 t2010 t2011-t2015 i.year i.statefip pop unemployment, cluster(statefip)
test t2005 t2006 t2007 t2008 t2009
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t20*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time") label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test): `pval'")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_2010_ab.png", replace

restore

*** JB ver
use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

* Manual ver
preserve 
collapse (mean) norm_jb_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

forvalues yr = 2005/2015{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t2010 = 0
label var t2005 "-5"
label var t2006 "-4"
label var t2007 "-3"
label var t2008 "-2"
label var t2009 "-1"
cap label var t2010 "0"
label var t2011 "1"
label var t2012 "2"
label var t2013 "3"
label var t2014 "4"
label var t2015 "5"

xtset statefip year
xtreg norm_jb_100000 t2005-t2015 pop unemployment i.year i.statefip, fe vce(cluster statefip)
test t2005 t2006 t2007 t2008 t2009
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t20*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time") label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test): `pval'")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_2010_jb.png", replace

restore






******************************** XTEVENT VERSIONS ******************************

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
xtevent norm_ab_100000 `controls', panelvar(state) timevar(year) policyvar(treatment) window(3)  
xteventplot, title("Treatment: high drug arrest states after 1986") /// 
	note("Estimates of 1986 law's effects on black adult marijuna arrests in an event study model." "Sample limited to ages 18-24 inclusive." "Event time 0 = 1986." "High marijuana states defined to be states above 75th percentile" "Controls: population and unemployment at the state-year level." "Arrest rate normalized to per 100,000.")
graph export "$fig_outdir/eventstudy/high_drug_use/high_marijuana_eventstudy_1986.png", replace

di "var-cov matrix"
mat list e(Vdelta) , nohalf
di "coefficient vector"
mat list  e(delta), nohalf
*svmat e(delta) e(Vdelta) , outsheet id gender race read write science using smauto1.csv , comma
restore 


* 2010
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

di "var-cov matrix"
mat list e(Vdelta) , nohalf
di "coefficient vector"
mat list  e(delta), nohalf
restore
