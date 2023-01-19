*===============================================================================
* Convert csv files to dta
*===============================================================================

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off
global datadir "/Users/rayhuang/Documents/Thesis-git/data/UCR_ICPSR/clean"
	
loc files ucr_avg_ab_18f_1986 ucr_sum_ab_18f_1986 ucr_avg_ab_18f_2010 /// 
	ucr_avg_ab_alloffenses_1986 ucr_avg_jb_alloffenses_1986 ///
	ucr_avg_ab_alloffenses_2010 ucr_avg_jb_alloffenses_2010

foreach file in `files' {
	import delim using "$datadir/`file'.csv", clear
	save "$datadir/dta_final/`file'.dta", replace
}
