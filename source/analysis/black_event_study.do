*===============================================================================       
* Event study 1986, treatment == black
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
use "cps_ucr_18_merged_extended_1986.dta", clear
tab year
drop if (age>24) | (age<18)
drop if sex == 2
loc controls age age2 hispan faminc unemployment

g treatment = 0
replace treatment = 1 if (black == 1)

* Note: xtevent only works on panel data
* Manual event-study
forvalues yr = 1980/1992{
	cap gen t`yr' = treatment * (year == `yr')
}

replace t1986 = 0
label var t1980 "-6"
label var t1981 "-5"
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

reg college_enrolled t1980-t1985 t1986 t1987-t1992 i.year i.state `controls' [pweight=edsuppwt], cluster(state)
test t1980 t1981 t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)

coefplot, omitted keep(t19*) vertical yline(0, lstyle(grid)) /// 
	title("College enrolled, black adults") ytitle("Coefficient") xtitle("Event time") /// 
	note("Pretrends p-value (F-test): `pval'" "Event time 0 = 1986") label ylabel(, format(%8.0g))
graph export "$outdir/eventstudy/black_college_1986.png", replace

