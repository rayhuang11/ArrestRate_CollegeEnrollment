*===============================================================================       
* Summary statistics table, Britton (CPS)
*===============================================================================

*********************************** Setup **************************************

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off
global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables/summ_stats"

********************************* 1986 Table ***********************************
* MERGED
use "cps_ucr_18_merged_1986.dta", clear
* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if college_enrolled==1 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if college_enrolled==1 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if educ == 091 | educ == 092 | educ == 090
g four_yr_college = 0
replace four_yr_college = 1 if (educ > 80) & (educ != 091) & (educ != 090) & (educ != 092) & (educ <123)

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS graduate"
label var college_enrolled "Enrolled in college"
label var college_enrolled_edtype "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-Black males)"
label var two_yr_college "Enrolled in 2-year college"
label var four_yr_college "Enrolled in 4-year college"

preserve
drop if educ == 1 // removing observations missing education
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986

loc summ_vars male black hs_grad college_enrolled college_enrolled_black /// 
	college_enrolled_notblack 
	
eststo pre_period1986: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period1986: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
	
restore

********************************* 2010 Table ***********************************
use "cps_ucr_18_merged_2010.dta", clear
drop if year < 2005
* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 2010
g post_law = 0
replace post_law = 1 if year >= 2010

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if college_enrolled==1 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if college_enrolled==1 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if educ == 091 | educ == 092 | educ == 090
g four_yr_college = 0
replace four_yr_college = 1 if (educ > 80) & (educ != 091) & (educ != 090) & (educ != 092) & (educ <123)

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"
label var college_enrolled_edtype "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-black males)"
label var two_yr_college "Enrolled in 2-year college"
label var four_yr_college "Enrolled in 4-year college"

preserve
drop if educ == 1 // removing observations missing education
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010

loc summ_vars male black hs_grad college_enrolled /// 
	college_enrolled_black college_enrolled_notblack 
	
eststo pre_period2010: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period2010: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
esttab pre_period1986 post_period1986 pre_period2010 post_period2010 using "$outdir/cps_ucr_summ_stats.tex", ///
	replace main(mean %6.2f) aux(sd) title("CPS-UCR Merged Summary Statistics") ///
	mtitle("1984-86" "1987-92" "2005-09" "2010-16") label nostar 
eststo clear

restore

********************************* Unmerged *************************************
cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
* UNMERGED
use "cps_educ.dta", clear
* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if college_enrolled==1 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if college_enrolled==1 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if edtype == 01
g four_yr_college = 0
replace four_yr_college = 1 if edtype == 02

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS graduate"
label var college_enrolled "Enrolled in college"
cap label var college_enrolled_edtype "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-Black males)"
label var two_yr_college "Enrolled in 2-year college"
label var four_yr_college "Enrolled in 4-year college"

preserve
drop if educ == 1 // removing observations missing education
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986

loc summ_vars male black hs_grad college_enrolled college_enrolled_black /// 
	college_enrolled_notblack 
	
eststo pre_period1986: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period1986: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
	
restore

********************************* 2010 Table 
use "cps_educ_2010.dta", clear
drop if year < 2005

* Generate variables for summary table
g pre_law = 0 
replace pre_law = 1 if year < 2010
g post_law = 0
replace post_law = 1 if year >= 2010

cap g male = 0
cap replace male = 1 if sex == 1
g hs_grad = 0
replace hs_grad = 1 if educ >= 072
g college_enrolled_black = 0
replace college_enrolled_black = 1 if college_enrolled==1 & black==1
g college_enrolled_notblack = 0
replace college_enrolled_notblack = 1 if college_enrolled==1 & black==0
g two_yr_college = 0
replace two_yr_college = 1 if edtype == 01 
g four_yr_college = 0
replace four_yr_college = 1 if edtype == 02

* Create summary table
label var male "Male"  
label var black "Black"
label var hs_grad "HS Graduate"
label var college_enrolled "Enrolled in college"
cap label var college_enrolled_edtype "Enrolled in college"
label var college_enrolled_black "Enrolled in college (Black males)"
label var college_enrolled_notblack "Enrolled in college (Non-black males)"
label var two_yr_college "Enrolled in 2-year college"
label var four_yr_college "Enrolled in 4-year college"

preserve
drop if educ == 1 // removing observations missing education
drop if ((2010 - year + age) > 24) | ((2010 - year + age) < 18) // age in 2010

loc summ_vars male black hs_grad college_enrolled /// 
	college_enrolled_black college_enrolled_notblack 

eststo pre_period2010: estpost summarize /// 
	`summ_vars' if pre_law == 1 [aweight=edsuppwt]
eststo post_period2010: estpost summarize ///
	`summ_vars' if post_law == 1 [aweight=edsuppwt]
esttab pre_period1986 post_period1986 pre_period2010 post_period2010 /// 
	using "$outdir/cps_only_summ_stats.tex", replace main(mean %6.2f) aux(sd) /// 
	title("CPS Summary Statistics ") mtitle("1984-86" "1987-92" "2005-09" "2010-16") label nostar 
eststo clear

restore

