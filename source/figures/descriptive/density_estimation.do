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

********************************************************************************
*********************************** 1986 ***************************************

use "cps_ucr_jb_18_merged_extended_1986.dta", clear

drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
drop if black == 0
collapse (mean) norm_jb_100000 [pweight=edsuppwt], by(year statefip)
kdensity norm_jb_100000, xtitle("(Mean) Juvenile black drug-related arrest rate per 100,000")
graph export "$fig_outdir/descriptive/norm_jb_100000_density_1986.png", replace

********************************************************************************
*********************************** 2010 ***************************************

use "cps_ucr_jb_18_merged_2010.dta", clear
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010
drop if sex == 2
drop if black == 0
collapse (mean) norm_jb_100000 [pweight=edsuppwt], by(year statefip)
kdensity norm_jb_100000, xtitle("(Mean) Juvenile black drug-related arrest rate per 100,000")
graph export "$fig_outdir/descriptive/norm_jb_100000_density_2010.png", replace
