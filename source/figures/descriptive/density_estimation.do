*===============================================================================
* Density of arrest rates
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off

global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

*********************************** 1986 ***************************************

use "cps_ucr_18_merged_1986.dta", clear
collapse (mean) norm_ab_100000 [pweight=edsuppwt], by(year statefip)
summ norm_ab_100000 if year==1984, det
loc ninefive = r(p95)
loc seventyfive = r(p75)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
kdensity norm_ab_100000 if year == 1984, xtitle("(Mean) Adult Black drug-related arrest rate per 100,000") /// 
	xline(`seventyfive')
graph export "$fig_outdir/descriptive/norm_jb_100000_density_1986.png", replace

*********************************** 2010 ***************************************

use "cps_ucr_18_merged_2010.dta", clear
collapse (mean) norm_ab_100000 [pweight=edsuppwt], by(year statefip)
summ norm_ab_100000 if year==2008, det
loc ninefive = r(p95)
loc seventyfive = r(p75)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'
kdensity norm_ab_100000 if year == 2008, xtitle("(Mean) Adult Black drug-related arrest rate per 100,000") xline(`seventyfive')
graph export "$fig_outdir/descriptive/norm_jb_100000_density_2010.png", replace
