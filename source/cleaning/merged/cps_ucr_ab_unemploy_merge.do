*===============================================================================
* CPS & UCR & State Unemployment Merge Master
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off

global unemploydir "/Users/rayhuang/Documents/Thesis-git/data/state_unemployment"
global outdir "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"

****************************** Clean unemployment ******************************

cap import delim using "$unemploydir/state_year_unemployment_clean.csv", clear
cap save "$unemploydir/state_year_unemployment_clean.dta", replace

********************************************************************************
******************************** Merge 1986 ************************************
********************************************************************************

loc offenses 18 18f 18A 18E

foreach offense in `offenses' {
	use "../UCR_ICPSR/clean/dta_final/ucr_avg_ab_alloffenses_1986.dta", clear
	if "`offense'" != "18f"{
		drop if (offense != "`offense'") 
	}
	if "`offense'" == "18f"{
		drop if (offense != "18F") 
	}
	
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
	
	drop if statefip == 12 | statefip == 19 | statefip == 45 | statefip == 0
	
	* Merge data
	di "UCR CPS merge"
	tab year
	merge 1:m statefip year using "cps_educ.dta"
	drop if _merge == 1 | _merge == 2 
	drop _merge

	******************************* Indicator vars *****************************

	g after1986 = 0
	replace after1986 = 1 if year > 1986
	g post_black_interact = after1986*black
	g male = 0
	replace male = 1 if sex == 1
	g sex_interact = after1986*male
	g age2 = age^2

	* Normalize arrest rate to per 100000
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
	collapse (mean) norm_ab_100000 [pweight=edsuppwt], by(statefip year)
	levelsof statefip if (norm_ab_100000 < `percentile_25' & year==1984)
	loc percentile_25_states `r(levels)'
	loc percentile_25_states : subinstr loc percentile_25_states " " ",", all
	levelsof statefip if (norm_ab_100000 > `percentile_50' & year==1984)
	loc percentile_50_states `r(levels)'
	loc percentile_50_states : subinstr loc percentile_50_states " " ",", all 
	levelsof statefip if (norm_ab_100000 > `percentile_75' & year==1984)
	loc percentile_75_states `r(levels)'
	loc percentile_75_states : subinstr loc percentile_75_states " " ",", all 
	restore

	* Generate indicators
	gen low_drug25 = inlist(statefip, `percentile_25_states')
	gen high_drug50 = inlist(statefip, `percentile_50_states')
	gen high_drug75 = inlist(statefip, `percentile_75_states')
	
	* Merge state unemployment data 
	merge m:1 statefip year using "$unemploydir/state_year_unemployment_clean.dta"
	drop if _merge == 1 | _merge == 2 
	drop _merge
	
	* Avoid adding unwanted years
	drop if year == 1980 | year == 1981
	
	* Save dta file
	sort statefip year
	* Drop incorrect state var
	drop state
	save "$outdir/cps_ucr_`offense'_merged_1986.dta", replace
}

********************************************************************************
******************************** Merge 2010 ************************************
********************************************************************************

loc offenses 18 18f 18A 18E

foreach offense in `offenses' {
	use "cps_educ_2000s.dta", clear
	*drop if statefip == 12 | statefip == 19 | statefip == 45
	use "../UCR_ICPSR/clean/dta_final/ucr_avg_ab_alloffenses_2010.dta", clear
	if "`offense'" != "18f"{
		drop if (offense != "`offense'") 
	}
	if "`offense'" == "18f"{
		drop if (offense != "18F") 
	}
	
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
	merge 1:m statefip year using "cps_educ_2000s.dta"
	drop if _merge == 1 | _merge == 2 
	drop _merge
	
	******************************* Indicator vars *****************************

	g after2010 = 0
	replace after2010 = 1 if year > 2010
	g post_black_interact = after2010*black
	g male = 0
	replace male = 1 if sex == 1
	g sex_interact = after2010*male
	g age2 = age^2

	* Normalize arrest rate
	gen norm_ab = 0
	replace norm_ab = ab / pop
	g norm_ab_100000 = 0
	replace norm_ab_100000 = norm_ab * 100000
	* Get high drug arrest states pre-treatment
	qui summ norm_ab_100000 if year==2008, det
	loc percentile_50 = r(p50)
	loc percentile_25 = r(p25) 
	loc percentile_75 = r(p75)
	* Get high drug arrest states pre-treatment
	preserve
	collapse (mean) norm_ab_100000 [pweight=edsuppwt], by(statefip year)
	levelsof statefip if (norm_ab_100000 < `percentile_25' & year==2008)
	loc percentile_25_states `r(levels)'
	loc percentile_25_states : subinstr loc percentile_25_states " " ",", all
	levelsof statefip if (norm_ab_100000 > `percentile_50' & year==2008)
	loc percentile_50_states `r(levels)'
	loc percentile_50_states : subinstr loc percentile_50_states " " ",", all 
	levelsof statefip if (norm_ab_100000 > `percentile_75' & year==2008)
	loc percentile_75_states `r(levels)'
	loc percentile_75_states : subinstr loc percentile_75_states " " ",", all 
	restore

	* Generate indicators
	gen low_drug25 = inlist(statefip, `percentile_25_states')
	tab low_drug25
	gen high_drug50 = inlist(statefip, `percentile_50_states')
	tab high_drug50
	gen high_drug75 = inlist(statefip, `percentile_75_states')
	tab high_drug75
	
	* Merge state unemployment data 
	merge m:1 statefip year using "$unemploydir/state_year_unemployment_clean.dta"
	drop if _merge == 1 | _merge == 2 
	drop _merge

	* Save dta file
	sort statefip year
	* Drop incorrect state var
	drop state
	save "$outdir/cps_ucr_`offense'_merged_2010.dta", replace
}
