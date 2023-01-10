*===============================================================================
* Convert csv to dta
*===============================================================================

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off
global datadir "/Users/rayhuang/Documents/Thesis-git/data/UCR_ICPSR/clean/"

* UCR average 1986
import delim using "$datadir/ucr_avg_1986.csv", clear
save "$datadir/ucr_avg_1986.dta", replace

* UCR sum 1986
import delim using "$datadir/ucr_sum_1986.csv", clear
save "$datadir/ucr_sum_1986.dta", replace

* UCR average 2010
import delim using "$datadir/ucr_avg_2010.csv", clear
save "$datadir/ucr_avg_2010.dta", replace

* UCR sum 2010
*import delim using "$datadir/ucr_sum_2010.csv", clear
*save "$datadir/ucr_sum_2010.dta", replace
