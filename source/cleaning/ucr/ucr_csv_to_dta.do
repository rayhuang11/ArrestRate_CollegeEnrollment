*===============================================================================
* Convert csv to dta
*===============================================================================

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off
global datadir "/Users/rayhuang/Documents/Thesis-git/data/UCR_ICPSR/clean"

loc files "ucr_avg_18f_1986" "ucr_sum_18f_1986" "ucr_avg_18f_2010" /// 
	"ucr_avg_ab_alloffenses_1986" "ucr_avg_ab_alloffenses_1986"
	
loc files ucr_avg_18f_1986 ucr_sum_18f_1986 ucr_avg_18f_2010 /// 
	ucr_avg_ab_alloffenses_1986 ucr_avg_jb_alloffenses_1986

foreach file in `files' {
	import delim using "$datadir/`file'.csv", clear
	save "$datadir/dta_final/`file'.dta", replace
}
