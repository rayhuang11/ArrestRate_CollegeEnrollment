*===============================================================================       
* CPS data cleaning
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off

use "cps_educ.dta", clear

********************************* Cleaning *************************************

* Gen educ dummy
cap college_enrolled = 0 // includes missing data
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

********************************* Save file ************************************

save "cps_educ.dta", replace
