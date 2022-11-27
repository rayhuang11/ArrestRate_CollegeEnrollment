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

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
cap drop if faminc == 995 | faminc == 996 | faminc == 999

* Gen variable for state punitive change
cap gen same_punitive = 0
cap replace same_punitive = 1 if 
cap gen less_punitive = 0
cap replace less_punitive = 1 if statefip == 02 04 55 19
cap gen more_punitive = 0
cap replace more_punitive =1 if statefip == 08 31 01 39 18 44 25 33


********************************* Save file ************************************

save "cps_educ.dta", replace
