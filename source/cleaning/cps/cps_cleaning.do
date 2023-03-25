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

******************************* Cleaning 1986 **********************************
use "cps_educ.dta", clear
sort statefip year

* Gen educ dummy
cap gen college_enrolled = 0
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

cap gen college_enrolled_edtype = 0
cap replace college_enrolled_edtype = 1 if edtype == 02 | edtype == 01

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
drop if educ == 999 | educ == 001
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

* Fix family inc var
cap g faminc_adj = 0
replace faminc_adj = 2500 if faminc == 100
replace faminc_adj = 500 if faminc == 110
replace faminc_adj = 250 if faminc == 111
replace faminc_adj = 750 if faminc == 112
replace faminc_adj = 1500 if faminc == 120
replace faminc_adj = 1250 if faminc == 121
replace faminc_adj = 1750 if faminc == 122
replace faminc_adj = 2500 if faminc == 130
replace faminc_adj = 2250 if faminc == 131
replace faminc_adj = 2750 if faminc == 132
replace faminc_adj = 3500 if faminc == 140
replace faminc_adj = 3250 if faminc == 141
replace faminc_adj = 3750 if faminc == 142
replace faminc_adj = 4250 if faminc == 150
replace faminc_adj = 6500 if faminc == 200
replace faminc_adj = 6250 if faminc == 210
replace faminc_adj = 5500 if faminc == 220
replace faminc_adj = 7000 if faminc == 230
replace faminc_adj = 6750 if faminc == 231
replace faminc_adj = 6500 if faminc == 232
replace faminc_adj = 7250 if faminc == 233
replace faminc_adj = 7500 if faminc == 234
replace faminc_adj = 8250 if faminc == 300
replace faminc_adj = 7750 if faminc == 310
replace faminc_adj = 8250 if faminc == 320
replace faminc_adj = 8750 if faminc == 330
replace faminc_adj = 8500 if faminc == 340
replace faminc_adj = 9500 if faminc == 350
replace faminc_adj = 12500 if faminc == 400
replace faminc_adj = 10500 if faminc == 410
replace faminc_adj = 11500 if faminc == 420
replace faminc_adj = 12250 if faminc == 430
replace faminc_adj = 11000 if faminc == 440
replace faminc_adj = 12500 if faminc == 450
replace faminc_adj = 13500 if faminc == 460
replace faminc_adj = 13750 if faminc == 470
replace faminc_adj = 13500 if faminc == 480
replace faminc_adj = 14500 if faminc == 490
replace faminc_adj = 17500 if faminc == 500
replace faminc_adj = 15500 if faminc == 510
replace faminc_adj = 16500 if faminc == 520
replace faminc_adj = 17500 if faminc == 530
replace faminc_adj = 16250 if faminc == 540
replace faminc_adj = 18750 if faminc == 550
replace faminc_adj = 19000 if faminc == 560
replace faminc_adj = 22500 if faminc == 600
replace faminc_adj = 37500 if faminc == 700
replace faminc_adj = 27500 if faminc == 710
replace faminc_adj = 32500 if faminc == 720
replace faminc_adj = 37500 if faminc == 730
replace faminc_adj = 45000 if faminc == 740
replace faminc_adj = 50000 if faminc == 800
replace faminc_adj = 62500 if faminc == 810
replace faminc_adj = 55000 if faminc == 820
replace faminc_adj = 67500 if faminc == 830
replace faminc_adj = 75000 if faminc == 840
replace faminc_adj = 87500 if faminc == 841
replace faminc_adj = 125000 if faminc == 842
replace faminc_adj = 150000 if faminc == 843

* Rename faminc 
cap rename faminc faminc_code
cap rename faminc_adj faminc

* Add yrs of educ
cap gen educ_yrs = 0 
replace educ_yrs = 0 if educ == 000
replace educ_yrs = 0 if educ == 001
replace educ_yrs = 0 if educ == 002
replace educ_yrs = 2 if educ == 010
replace educ_yrs = 2 if educ == 011
replace educ_yrs = 3 if educ == 012
replace educ_yrs = 4 if educ == 013
replace educ_yrs = 5 if educ == 014
replace educ_yrs = 5.5 if educ == 020
replace educ_yrs = 6 if educ == 021
replace educ_yrs = 7 if educ == 022
replace educ_yrs = 7.5 if educ == 030
replace educ_yrs = 8 if educ == 031
replace educ_yrs = 9 if educ == 032 
replace educ_yrs = 10 if educ == 040
replace educ_yrs = 11 if educ  == 050
replace educ_yrs = 12 if educ == 060
replace educ_yrs = 13 if educ == 070
replace educ_yrs = 12 if educ == 071
replace educ_yrs = 12 if educ == 072
replace educ_yrs = 13 if educ == 073
replace educ_yrs = 14 if educ == 080
replace educ_yrs = 14 if educ == 081
replace educ_yrs = 15 if educ == 090
replace educ_yrs = 15 if educ == 091
replace educ_yrs = 15 if educ == 092
replace educ_yrs = 16 if educ == 100
replace educ_yrs = 17 if educ == 110
replace educ_yrs = 17 if educ == 111
replace educ_yrs = 18 if educ == 120
replace educ_yrs = 18 if educ == 121
replace educ_yrs = 19 if educ == 123
replace educ_yrs = 19 if educ == 124
replace educ_yrs = 21 if educ == 125

save "cps_educ.dta", replace

******************************* Cleaning 1986 extended **********************************
use "cps_educ_1986_extended_years.dta", clear
sort statefip year

* Gen educ dummy
cap gen college_enrolled = 0
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

cap gen college_enrolled_edtype = 0
cap replace college_enrolled_edtype = 1 if edtype == 02 | edtype == 01

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
drop if educ == 999 | educ == 001
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

* Add yrs of educ
cap gen educ_yrs = 0 
replace educ_yrs = 0 if educ == 000
replace educ_yrs = 0 if educ == 001
replace educ_yrs = 0 if educ == 002
replace educ_yrs = 2 if educ == 010
replace educ_yrs = 2 if educ == 011
replace educ_yrs = 3 if educ == 012
replace educ_yrs = 4 if educ == 013
replace educ_yrs = 5 if educ == 014
replace educ_yrs = 5.5 if educ == 020
replace educ_yrs = 6 if educ == 021
replace educ_yrs = 7 if educ == 022
replace educ_yrs = 7.5 if educ == 030
replace educ_yrs = 8 if educ == 031
replace educ_yrs = 9 if educ == 032 
replace educ_yrs = 10 if educ == 040
replace educ_yrs = 11 if educ  == 050
replace educ_yrs = 12 if educ == 060
replace educ_yrs = 13 if educ == 070
replace educ_yrs = 12 if educ == 071
replace educ_yrs = 12 if educ == 072
replace educ_yrs = 13 if educ == 073
replace educ_yrs = 14 if educ == 080
replace educ_yrs = 14 if educ == 081
replace educ_yrs = 15 if educ == 090
replace educ_yrs = 15 if educ == 091
replace educ_yrs = 15 if educ == 092
replace educ_yrs = 16 if educ == 100
replace educ_yrs = 17 if educ == 110
replace educ_yrs = 17 if educ == 111
replace educ_yrs = 18 if educ == 120
replace educ_yrs = 18 if educ == 121
replace educ_yrs = 19 if educ == 123
replace educ_yrs = 19 if educ == 124
replace educ_yrs = 21 if educ == 125

save "cps_educ_1986_extended_years.dta", replace

******************************* Cleaning 2010 ***********************************
clear
use "cps_educ_2010.dta", clear

sort statefip year

* Gen educ dummy
cap gen college_enrolled = 0
cap replace college_enrolled = 1 if educ > 80 // includes associate's degree

gen college_enrolled_edtype = 0
replace college_enrolled_edtype = 1 if edtype == 02 | edtype == 01

* Gen race dummy
cap g black = 0
cap replace black = 1 if race == 200
cap g white = 0
cap replace white = 1 if race == 100

* Drop observations with missing data
cap drop if faminc == 995 | faminc == 996 | faminc == 999

* Relabel variablefs
label var college_enrolled "Enrolled in any college at some point (if educ > 80)"
label var black "Black"
label var white "White"

cap g faminc_adj = 0
replace faminc_adj = 2500 if faminc == 100
replace faminc_adj = 500 if faminc == 110
replace faminc_adj = 250 if faminc == 111
replace faminc_adj = 750 if faminc == 112
replace faminc_adj = 1500 if faminc == 120
replace faminc_adj = 1250 if faminc == 121
replace faminc_adj = 1750 if faminc == 122
replace faminc_adj = 2500 if faminc == 130
replace faminc_adj = 2250 if faminc == 131
replace faminc_adj = 2750 if faminc == 132
replace faminc_adj = 3500 if faminc == 140
replace faminc_adj = 3250 if faminc == 141
replace faminc_adj = 3750 if faminc == 142
replace faminc_adj = 4250 if faminc == 150
replace faminc_adj = 6500 if faminc == 200
replace faminc_adj = 6250 if faminc == 210
replace faminc_adj = 5500 if faminc == 220
replace faminc_adj = 7000 if faminc == 230
replace faminc_adj = 6750 if faminc == 231
replace faminc_adj = 6500 if faminc == 232
replace faminc_adj = 7250 if faminc == 233
replace faminc_adj = 7500 if faminc == 234
replace faminc_adj = 8250 if faminc == 300
replace faminc_adj = 7750 if faminc == 310
replace faminc_adj = 8250 if faminc == 320
replace faminc_adj = 8750 if faminc == 330
replace faminc_adj = 8500 if faminc == 340
replace faminc_adj = 9500 if faminc == 350
replace faminc_adj = 12500 if faminc == 400
replace faminc_adj = 10500 if faminc == 410
replace faminc_adj = 11500 if faminc == 420
replace faminc_adj = 12250 if faminc == 430
replace faminc_adj = 11000 if faminc == 440
replace faminc_adj = 12500 if faminc == 450
replace faminc_adj = 13500 if faminc == 460
replace faminc_adj = 13750 if faminc == 470
replace faminc_adj = 13500 if faminc == 480
replace faminc_adj = 14500 if faminc == 490
replace faminc_adj = 17500 if faminc == 500
replace faminc_adj = 15500 if faminc == 510
replace faminc_adj = 16500 if faminc == 520
replace faminc_adj = 17500 if faminc == 530
replace faminc_adj = 16250 if faminc == 540
replace faminc_adj = 18750 if faminc == 550
replace faminc_adj = 19000 if faminc == 560
replace faminc_adj = 22500 if faminc == 600
replace faminc_adj = 37500 if faminc == 700
replace faminc_adj = 27500 if faminc == 710
replace faminc_adj = 32500 if faminc == 720
replace faminc_adj = 37500 if faminc == 730
replace faminc_adj = 45000 if faminc == 740
replace faminc_adj = 50000 if faminc == 800
replace faminc_adj = 62500 if faminc == 810
replace faminc_adj = 55000 if faminc == 820
replace faminc_adj = 67500 if faminc == 830
replace faminc_adj = 75000 if faminc == 840
replace faminc_adj = 87500 if faminc == 841
replace faminc_adj = 125000 if faminc == 842
replace faminc_adj = 150000 if faminc == 843

* Rename faminc 
cap rename faminc faminc_code
cap rename faminc_adj faminc

* Add yrs of educ
cap gen educ_yrs = 0 
replace educ_yrs = 0 if educ == 000
replace educ_yrs = 0 if educ == 001
replace educ_yrs = 0 if educ == 002
replace educ_yrs = 2 if educ == 010
replace educ_yrs = 2 if educ == 011
replace educ_yrs = 3 if educ == 012
replace educ_yrs = 4 if educ == 013
replace educ_yrs = 5 if educ == 014
replace educ_yrs = 5.5 if educ == 020
replace educ_yrs = 6 if educ == 021
replace educ_yrs = 7 if educ == 022
replace educ_yrs = 7.5 if educ == 030
replace educ_yrs = 8 if educ == 031
replace educ_yrs = 9 if educ == 032
replace educ_yrs = 10 if educ == 040
replace educ_yrs = 11 if educ  == 050
replace educ_yrs = 12 if educ == 060
replace educ_yrs = 13 if educ == 070
replace educ_yrs = 12 if educ == 071
replace educ_yrs = 12 if educ == 072
replace educ_yrs = 13 if educ == 073
replace educ_yrs = 14 if educ == 080
replace educ_yrs = 14 if educ == 081
replace educ_yrs = 15 if educ == 090
replace educ_yrs = 15 if educ == 091
replace educ_yrs = 15 if educ == 092
replace educ_yrs = 16 if educ == 100
replace educ_yrs = 17 if educ == 110
replace educ_yrs = 17 if educ == 111
replace educ_yrs = 18 if educ == 120
replace educ_yrs = 18 if educ == 121
replace educ_yrs = 19 if educ == 123
replace educ_yrs = 19 if educ == 124
replace educ_yrs = 21 if educ == 125

save "cps_educ_2000s.dta", replace

