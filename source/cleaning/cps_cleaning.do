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
cap gen college_enrolled = 0
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
cap drop if faminc == 995 | faminc == 996 | faminc == 999

* Gen variable for state punitive change
*loc less_punitive_states 02 04 55 19
*loc more_punitive_states = 08 31 01 39 18 23 25 33

cap gen less_punitive = 0
cap gen more_punitive = 0
cap gen same_punitive = 0

cap replace less_punitive = 1 if statefip == 02 | statefip == 04 | statefip == 55 | statefip == 19
cap replace more_punitive =1 if statefip == 08 | statefip == 31 | statefip == 01 | ///
	statefip == 39 | statefip == 18 | statefip == 23 | statefip == 25 | statefip == 33
cap replace same_punitive = 1 if less_punitive == 1 | more_punitive == 1 

label var same_punitive "No change in Marijuana Minimum Distribution Penalty from 1986 to 1988"
label var less_punitive "Decrease in Marijuana Minimum Distribution Penalty from 1986 to 1988"
label var more_punitive "Increase in Marijuana Minimum Distribution Penalty from 1986 to 1988"
label var college_enrolled "Enrolled in any college at some point (if educ > 80)"
label var black "Black"
label var white "White"

********************************* Save file ************************************

save "cps_educ.dta", replace
