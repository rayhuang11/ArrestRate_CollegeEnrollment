*===============================================================================
* CPS & UCR Merge 18 (total violations) for AB Extended
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off

global outdir "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
global unemploydir "/Users/rayhuang/Documents/Thesis-git/data/state_unemployment"

***************************************************************************
******************************** Merge 1986 ************************************
********************************************************************************

use "cps_educ.dta", clear
drop if statefip == 12 | statefip == 19 | statefip == 45
use "../UCR_ICPSR/clean//dta_final/ucr_avg_ab_alloffenses_1986.dta", clear
* PICK THE OFFENSE CODE TO KEEP HERE
drop if (offense != "18") 
tab year

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
merge 1:m statefip year using "cps_educ_1986_extended_years.dta"
drop if _merge == 1 | _merge == 2 
drop _merge

******************************* Indicator vars *********************************

g after1986 = 0
replace after1986 = 1 if year > 1986
g post_black_interact = after1986*black
g male = 0
replace male = 1 if sex == 1
g sex_interact = after1986*male
g age2 = age^2

* Normalize arrest rate
gen norm_ab = 0
replace norm_ab = ab / pop
g norm_ab_100000 = 0
replace norm_ab_100000 = norm_ab * 100000

* Generate high drug indicators
qui summ norm_ab_100000 if year==1984, det
loc percentile_50 = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75)
* Get high drug arrest states pre-treatment
preserve
collapse (mean) norm_ab_100000 [pweight=edsuppwt], by(state year)
levelsof state if (norm_ab_100000 < `percentile_25' & year==1984)
loc percentile_25_states `r(levels)'
loc percentile_25_states : subinstr loc percentile_25_states " " ",", all
levelsof state if (norm_ab_100000 > `percentile_50' & year==1984)
loc percentile_50_states `r(levels)'
loc percentile_50_states : subinstr loc percentile_50_states " " ",", all 
levelsof state if (norm_ab_100000 > `percentile_75' & year==1984)
loc percentile_75_states `r(levels)'
loc percentile_75_states : subinstr loc percentile_75_states " " ",", all 
restore

*loc percentile_25_states 1, 3, 11, 15, 16, 18, 23, 25, 28, 30, 33, 40, 43, 46, 47, 49, 50
*loc percentile_50_states 4, 5, 6, 8, 12, 17, 19, 20, 21, 24, 26, 27, 31, 34, 37, 48
*loc percentile_75_states 5, 8, 12, 19, 27, 31

* Generate indicators
gen low_drug25 = inlist(state, `percentile_25_states')
gen high_drug50 = inlist(state, `percentile_50_states')
gen high_drug75 = inlist(state, `percentile_75_states')

* Merge state unemployment data 
merge m:1 state year using "$unemploydir/state_year_unemployment_clean.dta"
drop if _merge == 1 | _merge == 2 
drop _merge

* Save dta file
sort statefip years
save "$outdir/cps_ucr_18_merged_extended_1986.dta", replace
