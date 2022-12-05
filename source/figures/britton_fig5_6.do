*===============================================================================       
* Fig 5 and 6
*===============================================================================

*********************************** Setup **************************************

version 17
graph set window fontface "Garamond"
graph set print fontface "Garamond"
set scheme s1mono

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/UCR_ICPSR/clean"
}
clear all
set more off
set maxvar 20000
global outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

********************************* Clean data ***********************************

* Convert csv to dta
import delim using "icpsr_ucr_all_yrs.csv", clear
save "icpsr_ucr_all_yrs.dta", replace 
use "icpsr_ucr_all_yrs.dta", clear

sort state year

cap gen less_punitive = 0
cap gen more_punitive = 0
cap gen same_punitive = 0

cap replace less_punitive = 1 if state == 50 | state == 2 | state == 48 | state == 14
cap replace more_punitive = 1 if state == 5 | state == 26 | state == 1 | ///
	state == 34 | state == 13 | state == 18 | state == 20 | state == 28
cap replace same_punitive = 1 if less_punitive == 1 | more_punitive == 1 

label var same_punitive "No change in Marijuana Minimum Distribution Penalty from 1986 to 1988"
label var less_punitive "Decrease in Marijuana Minimum Distribution Penalty from 1986 to 1988"
label var more_punitive "Increase in Marijuana Minimum Distribution Penalty from 1986 to 1988"

*********************************** Fig 5 **************************************

* Xtevent
/*
gen treatment = .
replace treatment = 1 if year >= 1987
replace treatment = 0 if year <= 1986
drop if treatment == .

xtset state year, yearly

xtevent ab pop, panelvar(state) timevar(year) policyvar(treatment) window(4)

xtevent ab if more_punitive==1, panelvar(state) timevar(year) policyvar(treatment) window(3)
xtevent ab pop if ab==0 & more_punitive==1, panelvar(state) timevar(year) policyvar(treatment) window(3)
xtevent ab pop, policyvar(treatment) window(4) 
xteventplot
*/

****** Manual event-study
forvalues yr = 1982/1992{
	cap gen t`yr' = more_punitive*(year == `yr')
}

replace t1986 = 0
label var t1982 "-4"
label var t1983 "-3"
label var t1984 "-2"
label var t1985 "-1"
label var t1986 "0"
label var t1987 "1"
label var t1988 "2"
label var t1989 "3"
label var t1990 "4"
label var t1991 "5"
label var t1992 "6"

* Black adults
reg ab pop t1982-t1985 t1986 t1987-t1992 i.year i.state, cluster(state)
* Joint test
test t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("Black adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test): `pval'") label ylabel(, format(%8.0g))
graph export "$outdir/eventstudy/eventstudy_black.png", replace

* White adults
reg aw t1982-t1985 t1986 t1987-t1992 i.year i.state, cluster(state)
* Joint test
test t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("White adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test):  `pval'")
graph export "$outdir/eventstudy/eventstudy_white.png", replace




