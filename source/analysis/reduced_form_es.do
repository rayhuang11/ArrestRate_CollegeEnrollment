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
set graphics on
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

******************************** Event study 1986 ******************************
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

* Set control variables
loc controls age age2 hispan faminc unemployment

* Manual event-study
forvalues yr = 1984/1992{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t1986 = 0
cap label var t1980 "-6"
cap label var t1981 "-5"
cap label var t1982 "-4"
cap label var t1983 "-3"
label var t1984 "-2"
label var t1985 "-1"
cap label var t1986 "0"
label var t1987 "1"
label var t1988 "2"
label var t1989 "3"
label var t1990 "4"
label var t1991 "5"
label var t1992 "6"

eststo ab_college_1986: reghdfe college_enrolled t1984-t1992 `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6)  - ((t1984 + t1985)/2)
loc lincom_est = round(r(estimate), 0.00001)
loc lincom_se = round(r(se), 0.001)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.001)
loc att_se = round(r(se), 0.001)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/reducedform_ab1986.png", replace
	
* Juvenile ver
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

* Manual event-study
forvalues yr = 1984/1992{
	cap gen t`yr' = high_drug75 * (year == `yr')
}
replace t1986 = 0
cap label var t1980 "-6"
cap label var t1981 "-5"
cap label var t1982 "-4"
cap label var t1983 "-3"
label var t1984 "-2"
label var t1985 "-1"
cap label var t1986 "0"
label var t1987 "1"
label var t1988 "2"
label var t1989 "3"
label var t1990 "4"
label var t1991 "5"
label var t1992 "6"

eststo jb_college_1986: reghdfe college_enrolled t1984-t1992 `controls' [pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6)  - ((t1984 + t1985)/2)
loc lincom_est = round(r(estimate), 0.00001)
loc lincom_se = round(r(se), 0.001)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.001)
loc att_se = round(r(se), 0.001)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/reducedform_jb1986.png", replace


******************************** Event study 2010 ******************************
use "cps_ucr_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

forvalues yr = 2005/2016{
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
label var t2016 "6"

eststo ab_college_2010: reghdfe college_enrolled t2005-t2016 `controls' [pweight=edsuppwt], ///
	absorb(statefip year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6) - ((t2005 + t2006 + t2007 + t2008 + t2009)/5)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t2005 t2006 t2007 t2008 t2009
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t20*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/reducedform_ab2010.png", replace


* JB version
use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

forvalues yr = 2005/2016{
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
label var t2016 "6"

eststo jb_college_2010: reghdfe college_enrolled t2005-t2016 `controls' [pweight=edsuppwt], ///
	absorb(statefip year) vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6) - ((t2005 + t2006 + t2007 + t2008 + t2009)/5)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t2005 t2006 t2007 t2008 t2009
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t20*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/reducedform_jb2010.png", replace

******************************* Regression table  ******************************
#delimit ;
esttab ab_college_1986 jb_college_1986 ab_college_2010 jb_college_2010
	using "$table_outdir/eventstudy/eventstudy_reducedform.tex",
	replace se label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g)
	title("Impact of ADAA and FSA on College Enrollment")
	scalars("FE" "Controls")
	mtitles("1986 Adult" "1986 Juvenile" "2010 Adult" "2010 Juvenile") 
	rename(t1984 __2 t1985 __1 t1986 _0 t1987 _1 t1988 _2 t1989 _3 t1990 _4 
	t1991 _5 t1992 _6 t2005 __5 t2006 __4 t2007 __3 t2008 __2 t2009 __1 t2010 _0 
	t2011 _1 t2012 _2 t2013 _3 t2014 _4 t2015 _5 t2016 _6) 
	coeflabels(__5 "Year -5" __4 "Year -4" __3 "Year -3" __2 "Year -2" __1 "Year -1" _0 "Year 0 (Omitted)" _1 "Year 1" _2 "Year 2" _3 "Year 3" _4 "Year 4" _5 "Year 5" _6 "Year 6" pop "Population" unemployment "Unemployment") 
	order(_6 _5 _4 _3 _2 _1 _0 __1 __2 __3 __4  __5) drop(`controls')
	refcat(_6 "\emph{Event Study Model:}" t1985 "\vspace{0.1em} \\ \emph{-}", nolabel);
eststo clear;
#delimit cr
*drop(*year* *statefip*)
