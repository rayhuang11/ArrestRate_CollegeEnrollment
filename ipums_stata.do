* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

if "`c(username)'" == "rayhuang" {
	cd "/Users/rayhuang/Documents/Thesis-git"
}

set more off

clear
quietly infix                ///
  int     year      1-4      ///
  long    serial    5-9      ///
  byte    month     10-11    ///
  double  hwtfinl   12-21    ///
  double  cpsid     22-35    ///
  byte    asecflag  36-36    ///
  double  asecwth   37-47    ///
  byte    pernum    48-49    ///
  double  wtfinl    50-63    ///
  double  cpsidp    64-77    ///
  double  asecwt    78-88    ///
  int     relate    89-92    ///
  byte    age       93-94    ///
  byte    sex       95-95    ///
  int     race      96-98    ///
  byte    marst     99-99    ///
  byte    popstat   100-100  ///
  byte    vetstat   101-101  ///
  byte    edyratt   102-103  ///
  byte    edyrdip   104-105  ///
  byte    edged     106-107  ///
  byte    edatt     108-109  ///
  byte    edattly   110-111  ///
  int     edgrade   112-115  ///
  int     edgrdly   116-119  ///
  int     edpupr    120-122  ///
  byte    edfull    123-124  ///
  byte    edtype    125-126  ///
  byte    edvoca    127-128  ///
  double  edsuppwt  129-138  ///
  using `"cps_00002.dat"'

replace hwtfinl  = hwtfinl  / 10000
replace asecwth  = asecwth  / 10000
replace wtfinl   = wtfinl   / 10000
replace asecwt   = asecwt   / 10000
replace edsuppwt = edsuppwt / 10000

format hwtfinl  %10.4f
format cpsid    %14.0f
format asecwth  %11.4f
format wtfinl   %14.4f
format cpsidp   %14.0f
format asecwt   %11.4f
format edsuppwt %10.4f

label var year     `"Survey year"'
label var serial   `"Household serial number"'
label var month    `"Month"'
label var hwtfinl  `"Household weight, Basic Monthly"'
label var cpsid    `"CPSID, household record"'
label var asecflag `"Flag for ASEC"'
label var asecwth  `"Annual Social and Economic Supplement Household weight"'
label var pernum   `"Person number in sample unit"'
label var wtfinl   `"Final Basic Weight"'
label var cpsidp   `"CPSID, person record"'
label var asecwt   `"Annual Social and Economic Supplement Weight"'
label var relate   `"Relationship to household head"'
label var age      `"Age"'
label var sex      `"Sex"'
label var race     `"Race"'
label var marst    `"Marital status"'
label var popstat  `"Adult civilian, armed forces, or child"'
label var vetstat  `"Veteran status"'
label var edyratt  `"Year most recently attended regular school"'
label var edyrdip  `"Year completed high school"'
label var edged    `"Earned high school diploma through GED"'
label var edatt    `"Currently attending/enrolled in regular school"'
label var edattly  `"Enrolled in school in the previous October"'
label var edgrade  `"Current level of school enrollment"'
label var edgrdly  `"Level of school enrollment previous October"'
label var edpupr   `"Enrolled in public or private school"'
label var edfull   `"Attending college full- or part-time"'
label var edtype   `"Enrolled in a 2-year or 4-year college or university"'
label var edvoca   `"Vocational training enrollment"'
label var edsuppwt `"Education Supplement Weight"'

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define asecflag_lbl 1 `"ASEC"'
label define asecflag_lbl 2 `"March Basic"', add
label values asecflag asecflag_lbl

label define relate_lbl 0101 `"Head/householder"'
label define relate_lbl 0201 `"Spouse"', add
label define relate_lbl 0202 `"Opposite sex spouse"', add
label define relate_lbl 0203 `"Same sex spouse"', add
label define relate_lbl 0301 `"Child"', add
label define relate_lbl 0303 `"Stepchild"', add
label define relate_lbl 0501 `"Parent"', add
label define relate_lbl 0701 `"Sibling"', add
label define relate_lbl 0901 `"Grandchild"', add
label define relate_lbl 1001 `"Other relatives, n.s."', add
label define relate_lbl 1113 `"Partner/roommate"', add
label define relate_lbl 1114 `"Unmarried partner"', add
label define relate_lbl 1116 `"Opposite sex unmarried partner"', add
label define relate_lbl 1117 `"Same sex unmarried partner"', add
label define relate_lbl 1115 `"Housemate/roomate"', add
label define relate_lbl 1241 `"Roomer/boarder/lodger"', add
label define relate_lbl 1242 `"Foster children"', add
label define relate_lbl 1260 `"Other nonrelatives"', add
label define relate_lbl 9100 `"Armed Forces, relationship unknown"', add
label define relate_lbl 9200 `"Age under 14, relationship unknown"', add
label define relate_lbl 9900 `"Relationship unknown"', add
label define relate_lbl 9999 `"NIU"', add
label values relate relate_lbl

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"NIU"', add
label values sex sex_lbl

label define race_lbl 100 `"White"'
label define race_lbl 200 `"Black"', add
label define race_lbl 300 `"American Indian/Aleut/Eskimo"', add
label define race_lbl 650 `"Asian or Pacific Islander"', add
label define race_lbl 651 `"Asian only"', add
label define race_lbl 652 `"Hawaiian/Pacific Islander only"', add
label define race_lbl 700 `"Other (single) race, n.e.c."', add
label define race_lbl 801 `"White-Black"', add
label define race_lbl 802 `"White-American Indian"', add
label define race_lbl 803 `"White-Asian"', add
label define race_lbl 804 `"White-Hawaiian/Pacific Islander"', add
label define race_lbl 805 `"Black-American Indian"', add
label define race_lbl 806 `"Black-Asian"', add
label define race_lbl 807 `"Black-Hawaiian/Pacific Islander"', add
label define race_lbl 808 `"American Indian-Asian"', add
label define race_lbl 809 `"Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 810 `"White-Black-American Indian"', add
label define race_lbl 811 `"White-Black-Asian"', add
label define race_lbl 812 `"White-American Indian-Asian"', add
label define race_lbl 813 `"White-Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 814 `"White-Black-American Indian-Asian"', add
label define race_lbl 815 `"American Indian-Hawaiian/Pacific Islander"', add
label define race_lbl 816 `"White-Black--Hawaiian/Pacific Islander"', add
label define race_lbl 817 `"White-American Indian-Hawaiian/Pacific Islander"', add
label define race_lbl 818 `"Black-American Indian-Asian"', add
label define race_lbl 819 `"White-American Indian-Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 820 `"Two or three races, unspecified"', add
label define race_lbl 830 `"Four or five races, unspecified"', add
label define race_lbl 999 `"Blank"', add
label values race race_lbl

label define marst_lbl 1 `"Married, spouse present"'
label define marst_lbl 2 `"Married, spouse absent"', add
label define marst_lbl 3 `"Separated"', add
label define marst_lbl 4 `"Divorced"', add
label define marst_lbl 5 `"Widowed"', add
label define marst_lbl 6 `"Never married/single"', add
label define marst_lbl 7 `"Widowed or Divorced"', add
label define marst_lbl 9 `"NIU"', add
label values marst marst_lbl

label define popstat_lbl 1 `"Adult civilian"'
label define popstat_lbl 2 `"Armed Forces"', add
label define popstat_lbl 3 `"Child"', add
label values popstat popstat_lbl

label define vetstat_lbl 0 `"NIU"'
label define vetstat_lbl 1 `"No service"', add
label define vetstat_lbl 2 `"Yes"', add
label define vetstat_lbl 9 `"Unknown"', add
label values vetstat vetstat_lbl

label define edyratt_lbl 01 `"Current year"'
label define edyratt_lbl 02 `"Some previous year"', add
label define edyratt_lbl 03 `"Never attended"', add
label define edyratt_lbl 99 `"NIU"', add
label values edyratt edyratt_lbl

label define edyrdip_lbl 01 `"Current year"'
label define edyrdip_lbl 02 `"Some previous year"', add
label define edyrdip_lbl 99 `"NIU"', add
label values edyrdip edyrdip_lbl

label define edged_lbl 01 `"Yes"'
label define edged_lbl 02 `"No"', add
label define edged_lbl 96 `"Refusal"', add
label define edged_lbl 97 `"Don't know"', add
label define edged_lbl 98 `"No response"', add
label define edged_lbl 99 `"NIU"', add
label values edged edged_lbl

label define edatt_lbl 01 `"Enrolled"'
label define edatt_lbl 02 `"Not enrolled"', add
label define edatt_lbl 99 `"NIU"', add
label values edatt edatt_lbl

label define edattly_lbl 01 `"Enrolled"'
label define edattly_lbl 02 `"Not enrolled"', add
label define edattly_lbl 09 `"No response"', add
label define edattly_lbl 99 `"NIU"', add
label values edattly edattly_lbl

label define edgrade_lbl 0011 `"Nursery (pre-school, pre-K) part-day"'
label define edgrade_lbl 0012 `"Nursery (pre-school, pre-K) full-day"', add
label define edgrade_lbl 0021 `"Kindergarten part-day"', add
label define edgrade_lbl 0022 `"Kindergarten full-day"', add
label define edgrade_lbl 0101 `"1st grade"', add
label define edgrade_lbl 0102 `"2nd grade"', add
label define edgrade_lbl 0103 `"3rd grade"', add
label define edgrade_lbl 0104 `"4th grade"', add
label define edgrade_lbl 0105 `"5th grade"', add
label define edgrade_lbl 0106 `"6th grade"', add
label define edgrade_lbl 0107 `"7th grade"', add
label define edgrade_lbl 0108 `"8th grade"', add
label define edgrade_lbl 0201 `"9th grade"', add
label define edgrade_lbl 0202 `"10th grade"', add
label define edgrade_lbl 0203 `"11th grade"', add
label define edgrade_lbl 0204 `"12th grade"', add
label define edgrade_lbl 0301 `"College year 1 (freshman)"', add
label define edgrade_lbl 0302 `"College year 2 (sophomore)"', add
label define edgrade_lbl 0303 `"College year 3 (junior)"', add
label define edgrade_lbl 0304 `"College year 4 (senior)"', add
label define edgrade_lbl 0401 `"Graduate school year 1"', add
label define edgrade_lbl 0402 `"Graduate school year 2+"', add
label define edgrade_lbl 0501 `"Special School"', add
label define edgrade_lbl 9998 `"Not Avaliable"', add
label define edgrade_lbl 9999 `"NIU"', add
label values edgrade edgrade_lbl

label define edgrdly_lbl 0010 `"Nursery (pre-school, pre-kindergarten)"'
label define edgrdly_lbl 0020 `"Kindergarten"', add
label define edgrdly_lbl 0101 `"1st grade"', add
label define edgrdly_lbl 0102 `"2nd grade"', add
label define edgrdly_lbl 0103 `"3rd grade"', add
label define edgrdly_lbl 0104 `"4th grade"', add
label define edgrdly_lbl 0105 `"5th grade"', add
label define edgrdly_lbl 0106 `"6th grade"', add
label define edgrdly_lbl 0107 `"7th grade"', add
label define edgrdly_lbl 0108 `"8th grade"', add
label define edgrdly_lbl 0201 `"9th grade"', add
label define edgrdly_lbl 0202 `"10th grade"', add
label define edgrdly_lbl 0203 `"11th grade"', add
label define edgrdly_lbl 0204 `"12th grade"', add
label define edgrdly_lbl 0301 `"1st year of college (freshman)"', add
label define edgrdly_lbl 0302 `"2nd year of college (sophomore)"', add
label define edgrdly_lbl 0303 `"3rd year of college (junior)"', add
label define edgrdly_lbl 0304 `"4th year of college (senior)"', add
label define edgrdly_lbl 0401 `"1st year of graduate school"', add
label define edgrdly_lbl 0402 `"2nd year or higher of graduate school"', add
label define edgrdly_lbl 9998 `"No response"', add
label define edgrdly_lbl 9999 `"NIU"', add
label values edgrdly edgrdly_lbl

label define edpupr_lbl 010 `"Public"'
label define edpupr_lbl 011 `"Private"', add
label define edpupr_lbl 998 `"Not available/No response"', add
label define edpupr_lbl 999 `"NIU"', add
label values edpupr edpupr_lbl

label define edfull_lbl 01 `"Full-time"'
label define edfull_lbl 02 `"Part-time"', add
label define edfull_lbl 99 `"NIU"', add
label values edfull edfull_lbl

label define edtype_lbl 01 `"2-year college"'
label define edtype_lbl 02 `"4-year college or university"', add
label define edtype_lbl 99 `"NIU"', add
label values edtype edtype_lbl

label define edvoca_lbl 01 `"No"'
label define edvoca_lbl 02 `"Yes"', add
label define edvoca_lbl 99 `"NIU"', add
label values edvoca edvoca_lbl

save "test.dta", replace

