*===============================================================================
* DDIV
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off
use "cps_educ.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************
use "../UCR_ICPSR/clean/icpsr_ucr_all_yrs.dta", clear

gen statefip = 0
replace statefip = 1 if state==
replace statefip = 2 if state==
replace statefip = 3 if state==

* Merge data
merge 1:1 statefip year using "../UCR_ICPSR/clean/icpsr_ucr_all_yrs.dta"

* Create indicator variables
g after1986 = 0
replace after1986 = 1 if year > 1986
g interaction = after1986*black
g age2 = age^2
egen stratum = group(statefip year)
g male = 0
replace male = 1 if sex == 1
g sex_interaction = after1986*male

*********************************** DDIV ***************************************

* Generate period indicator (not necesary)
forvalues yr = 1984/1992{
	gen t`yr' = year == `yr'
}

* Reduced form
g zt = z*after1986
reg college_enrolled after1986 zt [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
loc rho = e(b) // some element in the coefficient matrix

* First stage
reg s after1986 zt [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
loc pi = e(b) // some element in the coefficient matrix

* Beta, ratio of reduced / first
loc beta = `rho' / `pi'
di "Beta is " `beta'


* Using ivregress
ivregress 2sls college_enrolled after1986 (c.black c.after1986#c.black = c.agdist c.after1986#c.agdist) ///
	[pweight=edsuppwt], vce(cluster statefip)
