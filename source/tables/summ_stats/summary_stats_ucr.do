*===============================================================================       
* Summary statistics table, UCR
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
use "cps_ucr_18_merged_1986.dta", clear
global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables/summ_stats"

*********************************** States **************************************
* Create summary table

preserve
drop if educ == 1 // removing observations missing education
drop if (age > 24) | (age<18)

collapse (mean) norm_ab_100000 pop edsuppwt, by(state year)
	
eststo test_: estpost tabstat /// 
	norm_ab_100000 if year == 1986 [aweight=edsuppwt], by(state) c(stat) stat(mean)
esttab test_ using "$outdir/ucr_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) ///
	title("UCR 1986 black adult arrests related to marijuana ") ///
	mtitle("AB") label nostar
eststo clear

restore


