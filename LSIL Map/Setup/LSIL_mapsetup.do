

use "/Users/scottmiller/Dropbox (UFL)/Dissertation/Analysis/Data/CO_Final.dta", clear


keep idx treat region district MAN3 CO_SER15 LS3 totrev_member goatrev_member CO_GPS_longitude CO_GPS_latitude CO_GPS_altitude

rename CO_GPS_longitude longitude
rename CO_GPS_latitude latitude

replace MAN3 = round(MAN3)
replace totrev_member = round(totrev_member,0.01)
replace goatrev_member = round(goatrev_member,0.01)
replace LS3 = round(LS3,0.01)


export excel using "LSIL_map", firstrow(variables)
