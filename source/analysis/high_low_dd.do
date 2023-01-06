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
use "cps_ucr_merged.dta", clear

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"

********************************* Cleaning *************************************

* Generate an indicator for being a state with high drug arrests or low
summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

gen high_drug = 0
replace high_drug = 1 if ab >= `ab_median'

* Create indicator variables
egen stratum = group(statefip year)

g high_drug_black_interact = black*high_drug
g high_drug_post_interact = after1986*high_drug
g triple_interact = after1986*black*high_drug
g ab_post_interact = ab*after1986

*********************************** DD *****************************************
* Set control variables
loc controls age age2 hispan faminc

* check parallel trends assumption
preserve
drop if (age > 24) | (age<18)
drop if sex == 2
* high_drug high_drug_post_interact / c.ab c.ab_post
eststo simple: qui reg college_enrolled after1986 high_drug high_drug_post_interact ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "N"
eststo demographics: qui reg college_enrolled after1986 high_drug high_drug_post_interact `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local State_yr_FE  "N"
estadd local Demographic_controls  "Y"
eststo dem_fe: qui areg college_enrolled after1986 high_drug high_drug_post_interact `controls' ///
	[pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
estadd local State_yr_FE "Y"
estadd local Demographic_controls  "Y"
* Create DiD table
esttab simple demographics dem_fe using "$outdir/DiD_1986_high_low.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DiD 1986, high vs low drug arrest states") /// 
	scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Still missing some demographic controls.") ///
	drop(`controls') nomtitles
eststo clear
restore
	
*********************************** DDD ****************************************
*didregress (satis) (procedure), group(hospital) time(month)
preserve
drop if (age > 24) | (age<18)
drop if sex == 2

areg college_enrolled after1986 black high_drug ///
	post_black high_drug_black_interact high_drug_post_interact  ///
	triple_interact ///
	`controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
esttab simple demographics dem_fe using "$outdir/DiDiD_1986.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("DDD 1986") /// 
	scalars("State_yr_FE" "Demographic_controls") ///
	addnote("Weights used. SEs clustered at state level. Still missing some demographic controls.") ///
	drop(`controls') nomtitles
eststo clear
restore
	
	
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
