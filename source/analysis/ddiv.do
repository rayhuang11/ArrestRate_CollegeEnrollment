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
drop if statefip == 12 | statefip == 19 | statefip == 45

use "../UCR_ICPSR/clean/icpsr_ucr_all_yrs.dta", clear

* For UCR data, generate an indicator for being a state with high drug arrests or low
* Use the median
summ ab, det
loc ab_median = r(p50)
gen high_drug = 0
replace high_drug = 1 if ab >= `ab_median'

* Create matching state labels with CPS data
gen statefip = 0
replace statefip = 1 if state==1
replace statefip = 2 if state==50
replace statefip = 4 if state==2
replace statefip = 5 if state==3
replace statefip = 6 if state==4
replace statefip = 8 if state==5
replace statefip = 9 if state==6
replace statefip = 10 if state==7
replace statefip = 11 if state==8
replace statefip = 12 if state==9
replace statefip = 13 if state==10
replace statefip = 15 if state==51
replace statefip = 16 if state==11
replace statefip = 17 if state==12
replace statefip = 18 if state==13
replace statefip = 19 if state==14
replace statefip = 20 if state==15
replace statefip = 21 if state==16
replace statefip = 22 if state==17
replace statefip = 23 if state==18
replace statefip = 24 if state==19
replace statefip = 25 if state==20
replace statefip = 26 if state==21
replace statefip = 27 if state==22
replace statefip = 28 if state==23
replace statefip = 29 if state==24
replace statefip = 30 if state==25
replace statefip = 31 if state==26
replace statefip = 32 if state==27
replace statefip = 33 if state==28
replace statefip = 34 if state==29
replace statefip = 35 if state==30
replace statefip = 36 if state==31
replace statefip = 37 if state==32
replace statefip = 38 if state==33
replace statefip = 39 if state==34
replace statefip = 40 if state==35
replace statefip = 41 if state==36
replace statefip = 42 if state==37
replace statefip = 44 if state==38
replace statefip = 45 if state==39
replace statefip = 46 if state==40
replace statefip = 47 if state==41
replace statefip = 48 if state==42
replace statefip = 49 if state==43
replace statefip = 50 if state==44
replace statefip = 51 if state==45
replace statefip = 53 if state==46
replace statefip = 54 if state==47
replace statefip = 55 if state==48
replace statefip = 56 if state==49

drop if statefip == 12 | statefip == 19 | statefip == 45

* Merge data
merge 1:m statefip year using "cps_educ.dta"
drop if _merge == 1 | _merge == 2 

* Create indicator variables
g after1986 = 0
replace after1986 = 1 if year > 1986
g post_black = after1986*black
g age2 = age^2
egen stratum = group(statefip year)
g male = 0
replace male = 1 if sex == 1
g sex_interaction = after1986*male

g high_drug_black = black*high_drug
g high_drug_post = after1986*high_drug

g triple_interaction = after1986*black*high_drug

g ab_post = ab*after1986

*********************************** DD *****************************************

areg college_enrolled after1986 high_drug high_drug_post `controls' ///
	[pweight=edsuppwt], absorb(stratum) vce(cluster statefip)

areg college_enrolled after1986 c.ab c.ab_post `controls' ///
	[pweight=edsuppwt], absorb(stratum) vce(cluster statefip)
	
*********************************** DDD ****************************************
*didregress (satis) (procedure), group(hospital) time(month)
loc controls age age2 hispan faminc


areg college_enrolled after1986 black high_drug ///
	post_black high_drug_black high_drug_post  ///
	triple_interaction ///
	`controls' [pweight=edsuppwt], absorb(stratum) vce(cluster statefip)

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
