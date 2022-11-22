*===============================================================================
* Fig 3, replication
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data"
}
clear all
set more off
use "cps_educ.dta", clear

********************************** Figure **************************************


mean college_enrolled if (year==1984) & (white==1) & (sex==1) [pweight=edsuppwt]
mean college_enrolled if (year==1984) & (black==1) & (sex==1) [pweight=edsuppwt]

mean college_enrolled if (year==1990) & (white==1) & (sex==1) [pweight=edsuppwt]
