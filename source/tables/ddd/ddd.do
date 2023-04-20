*===============================================================================
* Triple DiD
*===============================================================================

*********************************** Setup **************************************

version 17
if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git/data/CPS_UCR_merge"
}
clear all
set more off

global outdir "/Users/rayhuang/Documents/Thesis-git/output/tables/ddd"

******************************** DDD 1986 **************************************
*** Adult arrest rate
use "cps_ucr_18_merged_1986.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
*g ab_post_interact = norm_ab_100000*after1986

* Labels 
label var after1986 "Post-1986"
label var high_drug75 "Lived in high black adult drug arrest state"
cap label var ab_post_interact "Post-1986 X Drug arrest rate per 100000"
label var high_drug_post_interact "Post-1986 X High-drug arrest state"
label var high_drug_black_interact "Black X Lived in high AB" 
label var high_drug_post_interact "Post-1986 X Lived in high AB"
label var post_black "Post-1986 X Black"
label var triple_interact "Triple DiD Coefficient"

* Set control variables
loc controls age age2 hispan faminc unemployment
loc indepen_vars after1986 black high_drug75 post_black /// 
	high_drug_black_interact high_drug_post_interact triple_interact

preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

eststo basic: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "N"
eststo controls: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "Y"
eststo fe: qui reghdfe college_enrolled `indepen_vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
eststo fe_many: qui reghdfe college_enrolled triple_interact `controls' ///
	[pweight=edsuppwt], absorb(statefip#year black#statefip black#year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
esttab basic controls fe fe_many using "$outdir/ddd_1986_ab.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: Triple DiD Using Black Adult Drug-Related Arrest Rate") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear
restore

*** Juvenile arrest rate
use "cps_ucr_jb_18_merged_extended_1986.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after1986*high_drug75
g triple_interact = after1986*black*high_drug75
*g jb_post_interact = norm_jb_100000*after1986

* Labels 
label var after1986 "Post-1986"
label var high_drug75 "Lived in high black adult drug arrest state"
cap label var jb_post_interact "Post-1986 X Drug arrest rate per 100000"
label var high_drug_post_interact "Post-1986 X High-drug arrest state"
label var high_drug_black_interact "Black X Lived in high AB" 
label var high_drug_post_interact "Post-1986 X Lived in high AB"
label var post_black "Post-1986 X Black"
label var triple_interact "Triple DiD Coefficient"


* Set control variables
loc controls age age2 hispan faminc unemployment
loc indepen_vars after1986 black high_drug75 post_black /// 
	high_drug_black_interact high_drug_post_interact triple_interact

preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2
drop if year < 1984

eststo basic: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "N"
eststo controls: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "Y"
eststo fe: qui reghdfe college_enrolled `indepen_vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
eststo fe_many: qui reghdfe college_enrolled triple_interact `controls' ///
	[pweight=edsuppwt], absorb(statefip#year black#statefip black#year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
esttab basic controls fe fe_many using "$outdir/ddd_1986_jb.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Anti-Drug Abuse Act on College Enrollment: Triple DiD Using Black Juvenile Drug-Related Arrest Rate") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear
restore

******************************** DDD 2010 **************************************
*** Adult arrest rate
use "cps_ucr_18_merged_2010.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after2010*high_drug75
g triple_interact = after2010*black*high_drug75
*g ab_post_interact = norm_ab_100000*after1986

* Labels 
label var after2010 "Post-2010"
label var high_drug75 "Lived in high black adult drug arrest state"
cap label var ab_post_interact "Post-2010 X Drug arrest rate per 100000"
label var high_drug_post_interact "Post-2010 X High-drug arrest state"
label var high_drug_black_interact "Black X Lived in high AB" 
label var high_drug_post_interact "Post-2010 X Lived in high AB"
label var post_black "Post-2010 X Black"
label var triple_interact "Triple DiD Coefficient"

* Set control variables
loc controls age age2 hispan faminc unemployment
loc indepen_vars after2010 black high_drug75 post_black /// 
	high_drug_black_interact high_drug_post_interact triple_interact

preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

eststo basic: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "N"
eststo controls: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "Y"
eststo fe: qui reghdfe college_enrolled `indepen_vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
eststo fe_many: qui reghdfe college_enrolled triple_interact `controls' ///
	[pweight=edsuppwt], absorb(statefip#year black#statefip black#year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
esttab basic controls fe fe_many using "$outdir/ddd_2010_ab.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: Triple DiD Using Black Adult Drug-Related Arrest Rate") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear
restore

*** Juvenile arrest rate
use "cps_ucr_jb_18_merged_2010.dta", clear

* Create indicator variables
g high_drug_black_interact = black*high_drug75
g high_drug_post_interact = after2010*high_drug75
g triple_interact = after2010*black*high_drug75
*g ab_post_interact = norm_ab_100000*after1986

* Labels 
label var after2010 "Post-2010"
label var high_drug75 "Lived in high black adult drug arrest state"
cap label var ab_post_interact "Post-2010 X Drug arrest rate per 100000"
label var high_drug_post_interact "Post-2010 X High-drug arrest state"
label var high_drug_black_interact "Black X Lived in high AB" 
label var high_drug_post_interact "Post-2010 X Lived in high AB"
label var post_black "Post-2010 X Black"
label var triple_interact "Triple DiD Coefficient"

* Set control variables
loc controls age age2 hispan faminc unemployment
loc indepen_vars after2010 black high_drug75 post_black /// 
	high_drug_black_interact high_drug_post_interact triple_interact

preserve
drop if ((1986 - year + age) > 24) | ((1986 - year + age) < 18) // age in 1986
drop if sex == 2

eststo basic: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "N"
eststo controls: qui reg college_enrolled `indepen_vars' `controls' ///
	[pweight=edsuppwt], vce(cluster statefip)
estadd local FE "N"
estadd local Controls  "Y"
eststo fe: qui reghdfe college_enrolled `indepen_vars' `controls' /// 
	[pweight=edsuppwt], absorb(statefip year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
eststo fe_many: qui reghdfe college_enrolled triple_interact `controls' ///
	[pweight=edsuppwt], absorb(statefip#year black#statefip black#year) vce(cluster statefip)
estadd local FE "Y"
estadd local Controls  "Y"
esttab basic controls fe fe_many using "$outdir/ddd_2010_jb.tex", ///
	se replace label ar2 star(* 0.10 ** 0.05 *** 0.01) b(%9.4g) ///
	title("Impact of the Fair Sentencing Act on College Enrollment: Triple DiD Using Black Juvenile Drug-Related Arrest Rate") /// 
	scalars("FE" "Controls") drop(`controls') nomtitles
eststo clear
restore

	