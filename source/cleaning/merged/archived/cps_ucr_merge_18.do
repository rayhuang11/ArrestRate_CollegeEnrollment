*===============================================================================
* CPS & UCR Merge 18 (total violations) for AB
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off

global outdir "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"

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
merge 1:m statefip year using "cps_educ.dta"
drop if _merge == 1 | _merge == 2 

******************************* Indicator vars *********************************

g after1986 = 0
replace after1986 = 1 if year > 1986
g post_black_interact = after1986*black
g male = 0
replace male = 1 if sex == 1
g sex_interact = after1986*male
g age2 = age^2

summ ab if year==1984, det
loc percentile_50 = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75)

preserve
collapse (mean) ab, by(state year)

levelsof state if (ab < `percentile_25' & year==1984)
loc percentile_25_states `r(levels)'
local percentile_25_states : subinstr local percentile_25_states " " ",", all 
*loc percentile_25_states subinstr(" ", `percentile_25_states', ", ", all)
levelsof state if (ab > `percentile_50' & year==1984)
loc percentile_50_states `r(levels)'
levelsof state if (ab > `percentile_75' & year==1984)
loc percentile_75_states `r(levels)'

*loc percentile_25_states 1, 3, 11, 15, 16, 18, 23, 25, 28, 30, 33, 40, 43, 46, 47, 49, 50
*loc percentile_50_states 4, 5, 6, 8, 12, 17, 19, 20, 21, 24, 26, 27, 31, 34, 37, 48
*loc percentile_75_states 5, 8, 12, 19, 27, 31


restore

* Generate indicators
gen low_drug25 = inlist(state, `percentile_25_states')
tab low_drug25
gen high_drug50 = inlist(state, `percentile_50_states')
tab high_drug50
gen high_drug75 = inlist(state, `percentile_75_states')
tab high_drug75

sort statefip year

* Save dta file
save "$outdir/cps_ucr_18_merged_1986.dta", replace

********************************************************************************
******************************** Merge 2010 ************************************
********************************************************************************

use "cps_educ_2010.dta", clear
drop if statefip == 12 | statefip == 19 | statefip == 45
use "../UCR_ICPSR/clean/dta_final/ucr_avg_ab_alloffenses_2010.dta", clear
* PICK THE OFFENSE CODE TO KEEP HERE
drop if offense != "18"

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
merge 1:m statefip year using "cps_educ_2010.dta"
drop if _merge == 1 | _merge == 2 

******************************* Indicator vars *********************************

g after2010 = 0
replace after2010 = 1 if year > 1986
g post_black_interact = after2010*black

g male = 0
replace male = 1 if sex == 1
g sex_interact = after2010*male

g age2 = age^2

summ ab, det
loc ab_median = r(p50)
loc percentile_25 = r(p25) 
loc percentile_75 = r(p75) 

g high_drug = 0
replace high_drug = 1 if ab >= `ab_median'

sort statefip year

* Save dta file
save "$outdir/cps_ucr_18_merged_2010.dta", replace
