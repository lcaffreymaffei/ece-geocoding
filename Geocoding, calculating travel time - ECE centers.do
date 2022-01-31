//geocoding ece center addresses to get longitude and latitude coordinates
	import excel "C:\Users\Lucy Caffrey Maffei\Documents\ece dups.xlsx", sheet("Sheet1") firstrow case(lower)
	opencagegeo, key(7b304d53e6564d55a0263ec916b437a4) fulladdress(fulladdress)
	gen id = _n
	destring g_lat, force replace
	destring g_lon, force replace
	keep accountid id name g_lat g_lon fulladdress
	tempfile file1
	save `file1'

//doing a loop to merge two different files together n times where n = the # of observations
// master file will have only one row (i), representing data for one ece center
// using file will have as many rows for ece centers as i+1 to n is
// merge the master and the using to get the distance between the coordinates from 
// the row in the master with each of the coordinates from the centers in the using data
	rename accountid accountid2
	rename name name2
	rename fulladdress fulladdress2
	rename g_lat g_lat2
	rename g_lon g_long2
	rename id id2
	tempfile file2
	save `file2'
	forvalues i=1/153{
	}
	clear
	forvalues i = 1/153{
	use `file1'
	keep if _n>`i'
	tempfile match
	save `match'
	clear
	use `file2'
	keep if id==`i'
	merge m:m match using `match'
	geodist g_lat g_lon g_lat2 g_long2, gen(distance) mi
	tempfile merge`i'
	save `merge`i''
	clear
}
//appending the 152 different tempfiles together to get a big document of all observations in each
	clear
	use `merge1'
	forvalues v=2/152{
	append using `merge`v''
	tempfile ecedistances
	save `ecedistances'
	}

