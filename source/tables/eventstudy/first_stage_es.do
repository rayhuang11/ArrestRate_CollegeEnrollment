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

*preserve 
collapse (mean) norm_ab_100000 after1986 pop unemployment high_drug75, by(statefip year)

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

* Winsorizing 
summ norm_ab_100000, det
loc ninefive = r(p95)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
drop if norm_ab_100000 > 1000 // should be 0 observations deleted 

*xtevent norm_ab_100000, repeatedcs panelvar(statefip) timevar(year) policyvar(high_drug75) window(2) cluster(statefip) diffavg plot
xtset statefip year
eststo ab1986: xtreg norm_ab_100000 t1984-t1992 pop unemployment i.year i.statefip, fe vce(cluster statefip)
* Export matrix as dta
preserve
clear
matrix coefficient_mat =  e(b)[., 1..9]
svmat coefficient_mat, names(colnames)
export delimited "../coefficients_1986ab.csv", replace
clear
mat var_cov = e(V)[1..9, 1..9]
svmat var_cov, names(colnames)
export delimited "../var_cov_1986ab.csv", replace
restore

estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6)  - ((t1984 + t1985)/2)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986.png", replace
* Without fixed effects
eststo ab1986_nofe: xtreg norm_ab_100000 t1984-t1992 pop unemployment, fe vce(cluster statefip)
estadd local FE  "N"
estadd local Controls "Y"
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6)  - ((t1984 + t1985)/2)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_nofe_1986.png", replace
* DiD estimate
*restore
gen interact = high_drug75 * after1986
eststo did_ab_1986: xtreg norm_ab_100000 after1986 high_drug75 interact pop unemployment i.statefip i.year, fe vce(cluster statefip)

*** Appendix version
use "cps_ucr_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

*preserve 
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
xtreg norm_ab_100000 t1980-t1992 pop unemployment i.year i.statefip, fe vce(cluster statefip)
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992)/6) - ((t1980 + t1981 + t1982 + t1983 + t1984 + t1985)/6)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t1980 t1981 t1982 t1983 t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986_extended_years.png", replace

*** JB ver
use "cps_ucr_jb_18_merged_extended_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

*preserve 
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
eststo jb1986: xtreg norm_jb_100000 t1984-t1992 pop unemployment i.year i.statefip, fe vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6) - ((t1984 + t1985) /2)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.01)
lincom (t1987 + t1988 + t1989 + t1990 + t1991 + t1992) / 6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.001)
test t1984 t1985
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t19*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time")  label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_1986_jb.png", replace

* DiD estimate
gen after1986 = 0 
replace after1986 = 1 if year > 1986
gen interact = high_drug75 * after1986
eststo did_ab_1986: xtreg norm_jb_100000 after1986 high_drug75 interact pop unemployment, fe vce(cluster statefip)


******************************** Event study 2010 ******************************
use "cps_ucr_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

*preserve 
collapse (mean) norm_ab_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

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

xtset statefip year
eststo ab2010: xtreg norm_ab_100000 t2005-t2016 i.year i.statefip pop unemployment, fe vce(cluster statefip)
estadd local FE  "Y"
estadd local Controls "Y"
lincom ((t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6) - ((t2005 + t2006 + t2007 + t2008 + t2009)/5)
loc lincom_est = round(r(estimate), 0.01)
loc lincom_se = round(r(se), 0.001)
lincom (t2011 + t2012 + t2013 + t2014 + t2015 + t2016)/6
loc att = round(r(estimate), 0.01)
loc att_se = round(r(se), 0.00001)
test t2005 t2006 t2007 t2008 t2009
loc pval = round(r(p), 0.001)
coefplot, omitted keep(t20*) vertical yline(0, lpattern(dash)) /// 
	ytitle("Coefficient") xtitle("Event time") label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_2010_ab.png", replace


*** JB ver
use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2 

collapse (mean) norm_jb_100000 pop unemployment high_drug75 [pweight=edsuppwt], by(statefip year)

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

xtset statefip year
eststo jb2010: xtreg norm_jb_100000 t2005-t2016 pop unemployment i.year i.statefip, fe vce(cluster statefip)
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
	ytitle("Coefficient") xtitle("Event time") label ylabel(, format(%8.0g)) /// 
	note("Pretrends p-value (F-test):  0`pval'" "Traditional DiD estimate (SE in parentheses): `lincom_est' (`lincom_se')" "ATT: `att' (`att_se')")
graph export "$fig_outdir/eventstudy/high_drug_use/high_drug_eventstudy_2010_jb.png", replace


******************************* Regression table  ******************************
* DiD table
/*
#delimit ;
esttab did_ab_1986 using "$table_outdir/eventstudy/ab_1986.tex", replace fragment booktabs
	prehead("\begin{table}[htbp]\centering \defsym#1{\ifmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of the Anti-Drug Abuse Act on College Enrollment: DiD Estimates Using Normalized Black Adult Drug Arrest Rate as Continuous Treatment} \begin{tabular}{l*{4}{c}} \hline \hline")
	posthead("hline \\ [-2ex] \multicolumn{1}{c}{\textbf{Panel A}} \\\\[-2ex]")
	se label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) 
	drop(after1986 high_drug75) noconstant nomtitles;
* Event study table;
esttab ab1986 jb1986 ab2010 jb2010 using "$table_outdir/eventstudy/ab_1986.tex", booktabs
	posthead("hline \\ [-2ex] \multicolumn{1}{c}{\textbf{Panel B} \\\\[2ex]")
	se label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) nomtitles
	refcat(t1984 "\emph{Event Study Model:}" t1985 "\vspace{0.1em} \\ \emph{-}", nolabel)
	drop(*year* *statefip*) 
	rename(t1984 __2 t1985 __1 t1986 _0 t1987 _1 t1988 _2 t1989 _3 t1990 _4 t1991 _5 t1992 _6 t2005 __5 t2006 __4 t2007 __3 t2008 __2 t2009 __1 t2010 _0 t2011 _1 t2012 _2 t2013 _3 t2014 _4 t2015 _5 t2016 _6)
	coeflabels(__5 "Year -5" __4 "Year -4" __3 "Year -3" __2 "Year -2" __1 "Year -1" _0 "Year 0 (Omitted)" _1 "Year 1" _2 "Year 2" _3 "Year 3" _4 "Year 4" _5 "Year 5" _6 "Year 6" pop "Population" unemployment "Unemployment")
	order(_6 _5 _4 _3 _2 _1 _0 __1 __2 __3 __4  __5 pop unemployment) append fragment
	postfoot("\end{tabular} \end{table}");
#delimit cr
	*/

esttab ab1986 jb1986 ab2010 jb2010 using "$table_outdir/eventstudy/eventstudy_firststage.tex", ///
	replace se label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) se(%9.5g) ///
	title("Impact of ADAA and FSA on Drug Related Arrest Rates") ///
	mtitles("1986 Adult" "1986 Juvenile" "2010 Adult" "2010 Juvenile") /// 
	drop(*year* *statefip* pop unemployment) /// 
	rename(t1984 __2 t1985 __1 t1986 _0 t1987 _1 t1988 _2 t1989 _3 t1990 _4 t1991 _5 t1992 _6 t2005 __5 t2006 __4 t2007 __3 t2008 __2 t2009 __1 t2010 _0 t2011 _1 t2012 _2 t2013 _3 t2014 _4 t2015 _5 t2016 _6) ///
	coeflabels(__5 "Year -5" __4 "Year -4" __3 "Year -3" __2 "Year -2" __1 "Year -1" _0 "Year 0 (Omitted)" _1 "Year 1" _2 "Year 2" _3 "Year 3" _4 "Year 4" _5 "Year 5" _6 "Year 6" pop "Population" unemployment "Unemployment") ///
	order(_6 _5 _4 _3 _2 _1 _0 __1 __2 __3 __4  __5 pop unemployment) ///
	refcat(_6 "\emph{Event Study Model:}" t1985 "\vspace{0.1em} \\ \emph{-}", nolabel) ///
	scalars("FE" "Controls") 
	*  nomtitles replace
eststo clear


set graphics on
******************************** XTEVENT VERSIONS ******************************
/*
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
*/
