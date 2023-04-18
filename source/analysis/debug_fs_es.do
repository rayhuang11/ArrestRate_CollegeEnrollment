*===============================================================================       
* Debuggin first stage event study
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
set graphics on
global table_outdir "/Users/rayhuang/Documents/Thesis-git/output/tables"
global fig_outdir "/Users/rayhuang/Documents/Thesis-git/output/figures"

******************************** Event study 1986 ******************************
use "cps_ucr_18_merged_1986.dta", clear
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

collapse (mean) norm_ab_100000 high_drug75, by(statefip year)
qui summ norm_ab_100000, det
loc ninefive = r(p95)
replace norm_ab_100000 = `ninefive' if norm_ab_100000 > `ninefive'

*keep if year == 1986 | year == 1987
keep if year == 1986 | year == 1990
*keep if year == 1986 | year == 1991

reshape wide norm_ab_100000, i(statefip) j(year)
preserve
keep if high_drug75 == 1

*reg norm_ab_1000001987 norm_ab_1000001986, vce(cluster statefip)
*reg norm_ab_1000001990 norm_ab_1000001986, vce(cluster statefip)
cap reg norm_ab_1000001991 norm_ab_1000001986, vce(cluster statefip)
cap local slope = round(_b[norm_ab_1000001986], 0.0001)
cap local se_slope = round(_se[norm_ab_1000001986], 0.0001)

cap tw (scatter norm_ab_1000001987 norm_ab_1000001986) (lit norm_ab_1000001987 norm_ab_1000001986), ///
	note("Slope: `slope', SE: `se_slope'", size(small) pos(5)) title("1987 with small SE")
cap graph export "$fig_outdir/eventstudy/high_drug_use//debug/debug1987.png", replace

cap tw (scatter norm_ab_1000001991 norm_ab_1000001986) (lfit norm_ab_1000001991 norm_ab_1000001986), /// 
	note("Slope: `slope', SE: `se_slope'", size(small) pos(5)) title("1991 with large SE")
cap graph export "$fig_outdir/eventstudy/high_drug_use//debug/debug1991.png", replace
restore

cap gen diff1987 = norm_ab_1000001987 - norm_ab_1000001986
cap gen diff1990 = norm_ab_1000001990 - norm_ab_1000001986
cap gen diff1991 = norm_ab_1000001991 - norm_ab_1000001986

cap reg diff1991 high_drug75, r
*se = 6.45
reg diff1990 high_drug75, r
 reg diff1987 high_drug75, r
*-.06
*se = .9
