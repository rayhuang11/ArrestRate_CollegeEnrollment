*===============================================================================       
* Summary statistics table, Britton
*===============================================================================

*********************************** Setup **************************************

version 17

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off

use "test.dta", clear

*********************************** Table **************************************

g pre_law = 0 
replace pre_law = 1 if year < 1987
g post_law = 0 
replace post_law = 1 if year >= 1987

g Male = 0 
replace Male = 1 if sex == "Male"

tab sex if pre_law == 1
tab sex if post_law == 1


*Balance table
label var dmage "Mother's age" // relabel varaiables 
label var dmeduc "Mother's educ"
label var mblack "Mother is black"
label var mhispan "Mother is hispanic"
label var dfage "Father's age"
label var dfeduc "Father's educ"
label var dmar "Unmarried"
label var foreignb "Mother is foreign born"
label var drink "Drinks per week"
label var tripre0 "No prenatal care"
label var diabete "Diabetic mother"
label var anemia "Anemic mother"

local balance dmage dmeduc mblack dmar foreignb dfage dfeduc ///
	alcohol drink first  // list of variables
	
eststo smokers: estpost summarize /// 
	`balance' if tobacco == 1
eststo nonsmokers: estpost summarize ///
	`balance' if tobacco == 0
esttab smokers nonsmokers using 1a_balance.tex, ///
	replace main(mean %6.2f) aux(sd) ///
	title("Balance table for smokers vs nonsmokers") ///
	mtitle("Smokers" "Nonsmokers") label
eststo clear
