*===============================================================================
* DDIV
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
use "cps_ucr_18E_merged_1986.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Generate an indicator for being a state with high drug arrests or low
summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

* Create indicator variables
egen stratum = group(statefip year)

g high_drug_black_interact = black*high_drug
g high_drug_post_interact = after1986*high_drug
g triple_interact = after1986*black*high_drug
g ab_post_interact = ab*after1986

*********************************** DDIV ***************************************

******* Duflo approach
*First stage

*Reduced form
reg college_enrolled after2010 drug_arrest_high interaction [pweight=edsuppwt], vce(cluster statefip)



******************************* Old attempt ************************************


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

* Using ivregress (make sure the coefficents match)
ivregress 2sls college_enrolled after1986 (c.black c.after1986#c.black = c.agdist c.after1986#c.agdist) ///
	[pweight=edsuppwt], vce(cluster statefip)
	
ivregress 2sls log_wage (education=D) post high_intensity, r

