*===============================================================================       
* CPS data cleaning
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS"
}
clear all
set more off

use "cps_educ.dta", clear

********************************* Cleaning *************************************

sort statefip year

* Gen educ dummy
cap gen college_enrolled = 0 // includes missing data
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

* Gen race dummye
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
drop if faminc == 995 | faminc == 996 | faminc == 999

********************************* Save file ************************************

save "cps_educ.dta", replace
