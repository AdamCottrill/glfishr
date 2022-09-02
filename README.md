---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->


## Installation
The most up to date version can be installed using: `devtools::install_github("AdamCottrill/glfishr")`

# glfishr

*glfishr* contains a series of R functions that are intended to make
it easy to get fisheries assessment and creel survey data from the
fn_portal and creel_portal api's and into R for subsequent analysis
and reporting.  Functions are named semantically to reflect the FN-II
table they fetch data from.  There are functions that are specific to
assessment programs such as `get_FN011()` for project meta data,
`get_FN121()` for net set/sample data and `get_FN125()` for biological
sample data.  There are analogous functions to fetch data for creels:
`get_SC011()` for creel survey meta data, `get_SC121()` for creel
survey interview records and `get_SC125()` for biological data
collected from fish sampled in creels.  Most of the functions take an
optional filter_list parameter that can be used to finely control
which records are returned.  Care has been taken to ensure that the
available filters are consistent with FN-II field names whenever
possible, and in many cases, filters can be re-used across different
tables (e.g. - if a filter is passed to the `get_FN121()` function to
find a subset of net sets, that same filter can be applied to the
`get_FN125()` function to get the all of the biological samples
collected in those net sets).

All of the filters are specified using the following convention:
`<field_name>__<expression>` - the field name, two underscores, and
the expression that is to be applied to the field to select the subset
of records.  In most cases, the field name is a lowercase fishnet-II
field (prj_cd, tlen, gon, ect.) and will be documented in the Data Dictionary.
The available expressions are dependent on the type of data in the field. In
most cases, strings (such as prj_nm, prj_cd) can be filtered with 'like',
'not_like', and 'endswith'.  Fields with a well defined number of choices
(prj_cd, spc, gon, sex, tagstat)  can be selected by passing a
comma separated list of choices to include or exclude (`gon=10,20` or
`gon__not=10,20`), as well as null or not_null.  Numeric fields (sidep,
flen, rwt etc) typically have the following filter expressions available:

+ equal: `year=2010`
+ greater than or equal to: `tlen__gte=350`
+ greater than: `tlen__gt=350`
+ less than or equal to: `flen__lte=350`
+ less than: `flen__lt=350`
+ null: `clipc__null`
+ not null: `rwt__not_null`

Many of these filters are illustrated in the following examples, more
detailed infromation can be found using the `show_filters()` function
that takes a table name, and optionally, a partial filter name to
match against.  `show_filters()` will print out all of the filters
available for that table and, if appropriate, provide additional
information on expected format (eg. "format: yyyy-mm-dd").  If no
endpoint or table name is provided, `show_filters()` will display the
names of the filterable endpoints that are currently available.

Most of the functions accept a list of filters that can be used to
select the data that is returned from the Great Lakes Stocking
Database.  The list forms a key-value pair that specified the filter
to be applied and the value of the filter.



```r

show_filters()
#> An endpoint name needs to be provided. Currently avaliable endpoint names are:
#>  [1] "fn011"                     "fn012"                    
#>  [3] "fn012_protocol"            "fn013"                    
#>  [5] "fn022"                     "fn026"                    
#>  [7] "fn028"                     "fn121"                    
#>  [9] "fn121limno"                "fn122"                    
#> [11] "fn123"                     "fn124"                    
#> [13] "fn125"                     "fn125lamprey"             
#> [15] "fn125tags"                 "fn126"                    
#> [17] "fn127"                     "gear"                     
#> [19] "gear_effort_process_types" "prj_ldr"                  
#> [21] "species_list"

show_filters("fn011")
#>                    name                                    description
#> 1                  year                                               
#> 2                prj_cd    Multiple values may be separated by commas.
#> 3                prj_nm                                               
#> 4               prj_ldr                                               
#> 5             prj_date0                             format: yyyy-mm-dd
#> 6             prj_date1                             format: yyyy-mm-dd
#> 7                  lake    Multiple values may be separated by commas.
#> 8                source                                               
#> 9                status    Multiple values may be separated by commas.
#> 10            year__gte                                               
#> 11            year__lte                                               
#> 12             year__gt                                               
#> 13             year__lt                                               
#> 14           first_year                                               
#> 15            last_year                                               
#> 16       prj_date0__gte                             format: yyyy-mm-dd
#> 17       prj_date0__lte                             format: yyyy-mm-dd
#> 18       prj_date1__gte                             format: yyyy-mm-dd
#> 19       prj_date1__lte                             format: yyyy-mm-dd
#> 20             protocol    Multiple values may be separated by commas.
#> 21        protocol__not    Multiple values may be separated by commas.
#> 22          prj_cd__not    Multiple values may be separated by commas.
#> 23         prj_cd__like                                               
#> 24     prj_cd__not_like                                               
#> 25     prj_cd__endswith                                               
#> 26 prj_cd__not_endswith                                               
#> 27         prj_nm__like                                               
#> 28     prj_nm__not_like                                               
#> 29            lake__not    Multiple values may be separated by commas.
#> 30           spc_caught    Multiple values may be separated by commas.
#> 31          status__not    Multiple values may be separated by commas.
#> 32                 page A page number within the paginated result set.
#> 33            page_size          Number of results to return per page.

show_filters("fn125", filter_like="tlen")
#>         name description
#> 4       tlen            
#> 15 tlen__gte            
#> 16 tlen__lte            
#> 17  tlen__gt            
#> 18  tlen__lt
```



## Load glfishr

All of the functions in glfishr have been bundled up into an R-package
that can be installed and then loaded as needed:


```r
library(glfishr)
```


## FN011 - Projects

Project meta data can be accessed using the `get_fn011()` function.
FN011 records contain the hi-level meta data about an
OMNR netting project.  The FN011 records contain information like
project code, project name, project leader, start and end date,
protocol, and the lake where the project was conducted.  This
function takes an optional filter list which can be used to select
records based on several attributes of the project such as
project code, or part of the project code, lake, first year (**year__gte**), last
year (**year__lte**), protocol, etc.



```r

fn011 <- get_FN011(list(lake = "ON", year__gte = 2012, year__lte = 2018))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 11
head(fn011)
#>   YEAR       PRJ_CD                                                 PRJ_NM
#> 1 2012 LOA_IA12_GL1 2012 Eastern Lake Ontario Fish Community Index Gillnet
#> 2 2013 LOA_IA13_GL1 2013 Eastern Lake Ontario Fish Community Index Gillnet
#> 3 2014 LOA_IA14_GL1                2014 E.L.O. Community Index Gillnetting
#> 4 2014 LOA_IA14_WJ2          2014 Juvenile Migrant Salmonid Index - Spring
#> 5 2015 LOA_IA15_GL1      2015 Eastern Lake Ontario Community Index Gillnet
#> 6 2015 LOA_IA15_WJ2            2014 Juvenile Salmonid Index Electrofishing
#>    PRJ_DATE0  PRJ_DATE1 PROTOCOL   SOURCE
#> 1 2012-07-02 2012-09-07     OSIA offshore
#> 2 2013-06-24 2013-09-15     OSIA offshore
#> 3 2014-06-09 2014-09-15     OSIA offshore
#> 4 2014-05-20 2014-06-05       EF offshore
#> 5 2015-06-05 2015-09-15     OSIA offshore
#> 6 2015-05-12 2015-05-25       EF offshore
#>                                                                                                                                                                                                                                                                          COMMENT0
#> 1                                                                                                                                                                                                                                                                              11
#> 2                                                                                                                                                                                                                                                                               8
#> 3                                                                                                                                                                                                                                                                               8
#> 4 See internal report #LOA 14.xx for field protocol.\r\n\r\nWaterbody includes Lake Ontario tributaries. 10th year of study.\r\n\r\nSampling site lists and utms:\r\n\r\nStream\t\t   SITE\tUTM Upstream\t\tUTM Downstream\t Site Lng  Site Wdth\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t \t(m)\t\t(m)\r\n-------
#> 5                                                                                                                                                                                                                                                                               8
#> 6 See internal report #LOA 15.xx for field protocol.\r\n\r\nWaterbody includes Lake Ontario tributaries. 11th year of study.\r\n\r\nSampling site lists and utms:\r\n\r\nStream\t\t   SITE\tUTM Upstream\t\tUTM Downstream\t Site Lng  Site Wdth\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t \t(m)\t\t(m)\r\n-------
#>   LAKE.LAKE_NAME LAKE.ABBREV
#> 1   Lake Ontario          ON
#> 2   Lake Ontario          ON
#> 3   Lake Ontario          ON
#> 4   Lake Ontario          ON
#> 5   Lake Ontario          ON
#> 6   Lake Ontario          ON

fn011 <- get_FN011(list(lake = "ER", protocol = "TWL"))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 49
head(fn011)
#>   YEAR       PRJ_CD                                                    PRJ_NM
#> 1 2018 LEA_IA18_093 Long Point Bay Juvenile Index Trawl - Nearshore Outer Bay
#> 2 2018 LEA_IA18_094  Long Point Bay Juvenile Index Trawl - Offshore Outer Bay
#> 3 2018 LEA_IA18_095           Long Point Bay Juvenile Index Trawl - Inner Bay
#> 4 2018 LEA_IA18_TOS        Long Point Bay Juvenile Index Trawl - Offshore New
#> 5 2019 LEA_IA19_093 Long Point Bay Juvenile Index Trawl - Nearshore Outer Bay
#> 6 2019 LEA_IA19_094  Long Point Bay Juvenile Index Trawl - Offshore Outer Bay
#>    PRJ_DATE0  PRJ_DATE1 PROTOCOL   SOURCE
#> 1 2018-08-27 2018-09-27      TWL offshore
#> 2 2018-09-22 2018-11-08      TWL offshore
#> 3 2018-08-27 2018-09-27      TWL offshore
#> 4 2018-09-22 2018-09-23      TWL offshore
#> 5 2019-09-03 2019-10-02      TWL offshore
#> 6 2019-09-29 2019-10-25      TWL offshore
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    COMMENT0
#> 1                                                                                           The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Nearshore Outer Bay (093) survey was initiated in 1980 to measure recruitment of Yellow Perch as well as important forage species in nearshore areas of Long Point Bay excluding the Inner Bay. The survey design involves two replicate tows of a 6.1m Otter Bottom Trawl at three fixed stations. All trawls occur for 10 minutes at a speed of 2.5 knots. The sampling period was revised in 2011 to a period of 5 weeks from August 26th - October 5th, representing a total annual trawling effort of 300 minutes for this survey. In addition, a new survey commenced in 2018 which has a two-week sampling period and a broader spatial coverage. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old surveys will be discontinued. Data presented in this section are from the original survey design.
#> 2 The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Offshore Outer Bay (094) survey was initiated in 1984 to measure recruitment of Rainbow Smelt, which could not be assessed through the existing nearshore surveys. The survey design involves two consecutive tows of a 33’ 2-Seam Biloxi Bottom Trawl for 10 minutes at a speed of 2.5 knots. The first tow starts at one of four fixed stations, while the second tow starts at the endpoint of the first tow and continues on the same heading. The sampling period was revised in 2011 to a period of 5 weeks from September 25th - November 8th, representing a total annual trawling effort of 400 minutes for this survey. In addition, a new survey commenced in 2018 which has a two-week sampling period and a broader spatial coverage. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old surveys will be discontinued. Data presented in this section are from the original survey design.
#> 3                                                                                                                                 The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Nearshore Inner Bay (095) survey was initiated in 1980 to measure recruitment of Yellow Perch as well as important forage species in Inner Long Point Bay. The survey design involves two replicate tows of a 6.1m Otter Bottom Trawl at four fixed stations. All trawls occur for 10 minutes at a speed of 2.5 knots. The sampling period was revised in 2011 to a period of 5 weeks from August 26th - October 5th, representing a total annual trawling effort of 400 minutes for this survey. In addition, a new survey commenced in 2018 which has a two-week sampling period and a broader spatial coverage. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old surveys will be discontinued. Data presented in this section are from the original survey design.
#> 4                                                                                                                                                                                                            The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Offshore Outer Bay (094) survey was initiated in 1984 to measure recruitment of Rainbow Smelt, which could not be assessed through the existing nearshore surveys. The survey design involves two consecutive tows of a 33’ 2-Seam Biloxi Bottom Trawl for 10 minutes at a speed of 2.5 knots. The sampling period for the program is 5 weeks from September 25th - November 8th. The survey design was revised in 2018 to shorten the sampling period to two weeks and increase the spatial coverage. In the Offshore New survey, a single tow occurs at one of 16 fixed stations during each sample event. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old survey will be discontinued.
#> 5                                                                                           The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Nearshore Outer Bay (093) survey was initiated in 1980 to measure recruitment of Yellow Perch as well as important forage species in nearshore areas of Long Point Bay excluding the Inner Bay. The survey design involves two replicate tows of a 6.1m Otter Bottom Trawl at three fixed stations. All trawls occur for 10 minutes at a speed of 2.5 knots. The sampling period was revised in 2011 to a period of 5 weeks from August 26th - October 5th, representing a total annual trawling effort of 300 minutes for this survey. In addition, a new survey commenced in 2018 which has a two-week sampling period and a broader spatial coverage. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old surveys will be discontinued. Data presented in this section are from the original survey design.
#> 6 The Lake Erie Management Unit monitors the abundance of juvenile fish in Long Point Bay through three independent bottom trawl surveys conducted in early fall each year. The Offshore Outer Bay (094) survey was initiated in 1984 to measure recruitment of Rainbow Smelt, which could not be assessed through the existing nearshore surveys. The survey design involves two consecutive tows of a 33’ 2-Seam Biloxi Bottom Trawl for 10 minutes at a speed of 2.5 knots. The first tow starts at one of four fixed stations, while the second tow starts at the endpoint of the first tow and continues on the same heading. The sampling period was revised in 2011 to a period of 5 weeks from September 25th - November 8th, representing a total annual trawling effort of 400 minutes for this survey. In addition, a new survey commenced in 2018 which has a two-week sampling period and a broader spatial coverage. To maintain the continuity of the data series, both the old and new surveys will be run each year until a correction factor can be established, at which point the old surveys will be discontinued. Data presented in this section are from the original survey design.
#>   LAKE.LAKE_NAME LAKE.ABBREV
#> 1      Lake Erie          ER
#> 2      Lake Erie          ER
#> 3      Lake Erie          ER
#> 4      Lake Erie          ER
#> 5      Lake Erie          ER
#> 6      Lake Erie          ER


filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
fn011 <- get_FN011(filters)
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 2
head(fn011)
#>   YEAR       PRJ_CD                             PRJ_NM  PRJ_DATE0  PRJ_DATE1
#> 1 2015 LSA_IA15_CIN Lake Superior Fish Community Index 2015-08-02 2015-08-28
#> 2 2017 LSA_IA17_CIN Lake Superior Fish Community Index 2017-06-06 2017-08-21
#>   PROTOCOL   SOURCE COMMENT0 LAKE.LAKE_NAME LAKE.ABBREV
#> 1     OSIA offshore       NA  Lake Superior          SU
#> 2     OSIA offshore       NA  Lake Superior          SU


fn011 <- get_FN011(list(lake = "HU", prj_cd__like = "_006"))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 35
head(fn011)
#>   YEAR       PRJ_CD                                                  PRJ_NM
#> 1 2000 LHA_IA00_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#> 2 2001 LHA_IA01_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#> 3 2002 LHA_IA02_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#> 4 2003 LHA_IA03_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#> 5 2004 LHA_IA04_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#> 6 2005 LHA_IA05_006 Southern Lake Huron Offshore Gill Net Index  (Area 4-5)
#>    PRJ_DATE0  PRJ_DATE1 PROTOCOL   SOURCE
#> 1 2000-06-20 2000-10-05     OSIA offshore
#> 2 2001-09-17 2001-09-28     OSIA offshore
#> 3 2002-06-24 2002-10-03     OSIA offshore
#> 4 2003-07-02 2003-10-07     OSIA offshore
#> 5 2004-06-16 2004-10-01     OSIA offshore
#> 6 2005-06-21 2005-06-22     OSIA offshore
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 COMMENT0
#> 1 Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie and Atigamayg.           \r\n\r\nIndex fishing to provide pre-recruit year class strength index data for commercially important fish species and monitor general fish community in Management Area 4-5.  Project used overnight, bottom sets of standard GL10 monofilament index gill nets.\r\n\r\nTeam:  Jim Hastie, Terry Stein, Phil Curtis, John Brookham, Scott Austin, Ed deLaplante, Terry Walmsely, Sylvia Mannonen, and others.
#> 2 Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie and Atigamayg.           \r\n\r\nIndex fishing to provide pre-recruit year class strength index data for commercially important fish species and monitor general fish community in Management Area 4-5.  Project used overnight, bottom sets of standard GL10 monofilament index gill nets.\r\n\r\nTeam:  Jim Hastie, Terry Stein, Phil Curtis, John Brookham, Scott Austin, Ed deLaplante, Terry Walmsely, Sylvia Mannonen, and others.
#> 3                                                                                                                                              Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie and Atigamayg.           \r\n\r\nIndex fishing to provide pre-recruit year class strength index data for commercially important fish species and monitor general fish community in Management Area 4-5.  Project used overnight, bottom sets of standard GL10 monofilament index gill nets.
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                         Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie.
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                         Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie.
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                         Annual index fishing in southern Lake Huron main basin, Management Area 4-5, Assessment Areas LH08 and LH09.  The project was conducted out of Grand Bend, Bayfield, and Goderich using the tugs Wonda Goldie.
#>   LAKE.LAKE_NAME LAKE.ABBREV
#> 1     Lake Huron          HU
#> 2     Lake Huron          HU
#> 3     Lake Huron          HU
#> 4     Lake Huron          HU
#> 5     Lake Huron          HU
#> 6     Lake Huron          HU
```


## FN121 - Net Sets

Net sets can be retrieved using the `get_FN121()` function.  The FN121
records contain information like set and lift date and time, effort
duration, gear, site depth and location.  This function takes an
optional filter list which can be used to return records based on
several attributes of the net set including set and lift date and
time, effort duration, gear, site depth and location as well as
attributes of the projects they are associated with such as project code
or part of the project code, lake, first year, last year, protocol,
etc.



```r

fn121 <- get_FN121(list(lake = "ON", year = 2012))
nrow(fn121)
#> [1] 178
head(fn121)
#>         PRJ_CD SAM SSN SPACE MODE     EFFDT0     EFFDT1 EFFDUR   EFFTM0
#> 1 LOA_IA12_GL1   1  00    00   01 2012-07-03 2012-07-04     22 07:15:00
#> 2 LOA_IA12_GL1  10  00    00   01 2012-07-03 2012-07-04     22 08:38:00
#> 3 LOA_IA12_GL1 100  00    00   02 2012-07-25 2012-07-26     18 10:31:00
#> 4 LOA_IA12_GL1 101  00    00   02 2012-07-25 2012-07-26     18 11:05:00
#> 5 LOA_IA12_GL1 102  00    00   02 2012-07-25 2012-07-26     18 11:05:00
#> 6 LOA_IA12_GL1 103  00    00   01 2012-07-30 2012-08-01     24 06:20:00
#>     EFFTM1 EFFST SIDEP GRDEPMAX GRDEPMIN SITE SITP GRID5   DD_LAT    DD_LON
#> 1 05:50:00    NA   7.5       NA       NA GI08   NA  9999 44.10111 -76.79611
#> 2 07:15:00    NA  27.5       NA       NA GI28   NA  9999 44.07250 -76.78861
#> 3 04:52:00    NA   7.5       NA       NA HB08   NA  9999 44.11222 -77.03972
#> 4 05:11:00    NA  12.5       NA       NA HB13   NA  9999 44.09778 -77.08028
#> 5 05:11:00    NA  12.5       NA       NA HB13   NA  9999 44.09778 -77.08028
#> 6 06:50:00    NA   7.5       NA       NA RP08   NA  9999 43.92667 -76.87944
#>   DD_LAT1 DD_LON1 SITEM SITEM0 SITEM1 SECCHI XSLIME CREW COMMENT1
#> 1      NA      NA    NA     NA     NA    7.5     NA   NA       NA
#> 2      NA      NA    NA     NA     NA    9.0     NA   NA       NA
#> 3      NA      NA    NA     NA     NA    1.5     NA   NA       NA
#> 4      NA      NA    NA     NA     NA    1.5     NA   NA       NA
#> 5      NA      NA    NA     NA     NA    1.5     NA   NA       NA
#> 6      NA      NA    NA     NA     NA    7.0     NA   NA       NA
#>   MANAGEMENT_UNIT
#> 1              NA
#> 2              NA
#> 3              NA
#> 4              NA
#> 5              NA
#> 6              NA


fn121 <- get_FN121(list(lake = "ER", protocol = "TWL", year__gte = 2010, sidep__lte = 20))
nrow(fn121)
#> [1] 875
head(fn121)
#>         PRJ_CD   SAM SSN SPACE MODE     EFFDT0     EFFDT1 EFFDUR   EFFTM0
#> 1 LEA_IA18_093 4201A  03    93   01 2018-08-27 2018-08-27   0.17 09:55:00
#> 2 LEA_IA18_093 4201B  03    93   01 2018-08-27 2018-08-27   0.17 10:10:00
#> 3 LEA_IA18_093 4202A  03    93   01 2018-08-27 2018-08-27   0.17 10:55:00
#> 4 LEA_IA18_093 4202B  03    93   01 2018-08-27 2018-08-27   0.17 11:10:00
#> 5 LEA_IA18_093 4203A  03    93   01 2018-08-27 2018-08-27   0.17 08:20:00
#> 6 LEA_IA18_093 4203B  03    93   01 2018-08-27 2018-08-27   0.17 08:55:00
#>     EFFTM1 EFFST SIDEP GRDEPMAX GRDEPMIN SITE SITP GRID5   DD_LAT    DD_LON
#> 1 10:05:00     1   2.4      2.4      2.3   60   NA  9999 42.67065 -80.32690
#> 2 10:20:00     1   2.4      2.4      2.3   60   NA  9999 42.67075 -80.32687
#> 3 11:05:00     1   3.5      3.6      3.5   64   NA  9999 42.60052 -80.27525
#> 4 11:20:00     1   3.5      3.6      3.5   64   NA  9999 42.60047 -80.27553
#> 5 08:30:00     1   3.1      3.1      1.5   70   NA  9999 42.78145 -80.20518
#> 6 09:05:00     1   3.1      3.1      1.5   70   NA  9999 42.78147 -80.20565
#>    DD_LAT1   DD_LON1 SITEM SITEM0 SITEM1 SECCHI XSLIME CREW COMMENT1
#> 1 42.67767 -80.32722    NA   21.7     NA    2.3     NA   NA     <NA>
#> 2 42.67785 -80.32703    NA   21.7     NA    2.3     NA   NA     <NA>
#> 3 42.60682 -80.27973    NA   21.1     NA    2.5     NA   NA     <NA>
#> 4 42.60687 -80.28013    NA   21.1     NA    2.5     NA   NA     <NA>
#> 5 42.78247 -80.21490    NA   22.9     NA    1.3     NA   NA     <NA>
#> 6 42.78253 -80.21450    NA   22.9     NA    1.3     NA   NA     <NA>
#>   MANAGEMENT_UNIT
#> 1              NA
#> 2              NA
#> 3              NA
#> 4              NA
#> 5              NA
#> 6              NA


filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN")
)

fn121 <- get_FN121(filters)

nrow(fn121)
#> [1] 171
head(fn121)
#>         PRJ_CD   SAM SSN SPACE MODE     EFFDT0     EFFDT1   EFFDUR   EFFTM0
#> 1 LSA_IA15_CIN 01001  00    00   01 2015-08-02 2015-08-03 23.10000 09:41:00
#> 2 LSA_IA15_CIN 01002  00    00   01 2015-08-03 2015-08-04 25.15000 08:13:00
#> 3 LSA_IA15_CIN 01003  00    00   01 2015-08-04 2015-08-05 25.05000 08:27:00
#> 4 LSA_IA15_CIN 01004  00    00   01 2015-08-04 2015-08-05 25.21667 08:47:00
#> 5 LSA_IA15_CIN 01005  00    00   01 2015-08-05 2015-08-06 24.35000 08:19:00
#> 6 LSA_IA15_CIN 01006  00    00   01 2015-08-05 2015-08-06 24.55000 08:52:00
#>     EFFTM1 EFFST SIDEP GRDEPMAX GRDEPMIN SITE SITP GRID5   DD_LAT    DD_LON
#> 1 08:47:00     1     6       NA       NA    S   NA   350 48.83595 -88.15790
#> 2 09:22:00     1     5       NA       NA    S   NA   350 48.89383 -88.13980
#> 3 09:30:00     1     6       NA       NA    S   NA   351 48.87872 -88.03753
#> 4 10:00:00     1     5       NA       NA    S   NA   451 48.82693 -88.07353
#> 5 08:40:00     1     5       NA       NA    S   NA   249 48.95565 -88.21633
#> 6 09:25:00     1    33       NA       NA    M   NA   251 48.94135 -88.01323
#>   DD_LAT1 DD_LON1 SITEM SITEM0 SITEM1 SECCHI XSLIME CREW        COMMENT1
#> 1      NA      NA    NA     NA     NA     NA     NA   NA 0.2m waveheight
#> 2      NA      NA    NA     NA     NA      2     NA   NA 0.3m waveheight
#> 3      NA      NA    NA     NA     NA     NA     NA   NA 0.2m waveheight
#> 4      NA      NA    NA     NA     NA     NA     NA   NA 0.3m waveheight
#> 5      NA      NA    NA     NA     NA     NA     NA   NA   0m waveheight
#> 6      NA      NA    NA     NA     NA     NA     NA   NA 0.1m waveheight
#>   MANAGEMENT_UNIT
#> 1              NA
#> 2              NA
#> 3              NA
#> 4              NA
#> 5              NA
#> 6              NA


fn121 <- get_FN121(list(lake = "HU", prj_cd__endswith = "_003"))
nrow(fn121)
#> [1] 160
head(fn121)
#>         PRJ_CD SAM SSN SPACE MODE     EFFDT0     EFFDT1   EFFDUR   EFFTM0
#> 1 LHA_CC11_003   1  00    00   02 2011-06-21 2011-06-22 24.00500 10:22:31
#> 2 LHA_CC11_003   2  00    00   02 2011-06-21 2011-06-22 23.88750 10:34:16
#> 3 LHA_CC11_003   3  00    00   02 2011-06-21 2011-06-22 23.94500 10:49:23
#> 4 LHA_CC11_003   4  00    00   01 2011-06-21 2011-06-22 25.41222 11:27:04
#> 5 LHA_CC11_003   5  00    00   02 2011-06-22 2011-06-23 20.02555 14:05:16
#> 6 LHA_CC11_003   6  00    00   02 2011-06-22 2011-06-23 20.02056 14:10:48
#>     EFFTM1 EFFST SIDEP GRDEPMAX GRDEPMIN SITE SITP GRID5  DD_LAT   DD_LON
#> 1 10:22:49     0    NA       NA       NA   Co   NA  2248 44.5161 -80.2236
#> 2 10:27:31     0    NA       NA       NA   Co   NA  2248 44.5123 -80.2291
#> 3 10:46:05     1    NA       NA       NA   Co   NA  2248 44.5068 -80.2185
#> 4 12:51:48     1    NA       NA       NA   Co   NA  2248 44.5123 -80.2323
#> 5 10:06:48     1    NA       NA       NA   Co   NA  2248 44.5074 -80.2203
#> 6 10:12:02     1    NA       NA       NA   Co   NA  2248 44.5066 -80.2180
#>   DD_LAT1 DD_LON1 SITEM SITEM0 SITEM1 SECCHI XSLIME CREW
#> 1      NA      NA    NA     NA     NA     NA     NA   NA
#> 2      NA      NA    NA     NA     NA     NA     NA   NA
#> 3      NA      NA    NA     NA     NA     NA     NA   NA
#> 4      NA      NA    NA     NA     NA     NA     NA   NA
#> 5      NA      NA    NA     NA     NA     NA     NA   NA
#> 6      NA      NA    NA     NA     NA     NA     NA   NA
#>                             COMMENT1 MANAGEMENT_UNIT
#> 1                       NORDIC SLIME              NA
#> 2                       NORDIC SLIME              NA
#> 3                         NORDIC NET              NA
#> 4 TNTC- estimated counts in 123table              NA
#> 5                             NORDIC              NA
#> 6                         NORDIC NET              NA
```


## FN122 - Sample Efforts


Sample Efforts can be retrieved using the `get_fn122()` function. FN122
records contain information about efforts within a sample.  For most
gill netting project an effort corresponds to a single panel of a
particular mesh size within a net set (gang). For trap netting and
trawling projects, there is usually just a single effort. The FN122
table contains information about that particular effort such as gear
depth, gear temperature at set and lift, and effort distance.  This
function takes an optional filter list which can be used to return
records based on several attributes of the effort including effort
distance and depth but also attributes of the projects or nets set
they are associated with such as project code, lake, first year, last
year, protocol, gear etc.



```r


fn122 <- get_FN122(list(lake = "ON", year = 2012, gear = "GL", sidep__lte = 15))
#> Warning in check_filters("fn122", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn122)
#> [1] 619
head(fn122)
#>         PRJ_CD SAM EFF EFFDST GRDEP GRTEM0 GRTEM1 COMMENT2
#> 1 LOA_IA12_GL1   1 038    4.6   6.7   19.2     NA       NA
#> 2 LOA_IA12_GL1   1 051   15.2   6.7   19.2     NA       NA
#> 3 LOA_IA12_GL1   1 064   15.2   6.7   19.2     NA       NA
#> 4 LOA_IA12_GL1   1 076   15.2   6.7   19.2     NA       NA
#> 5 LOA_IA12_GL1   1 089   15.2   6.7   19.2     NA       NA
#> 6 LOA_IA12_GL1   1 102   15.2   6.7   19.2     NA       NA


filters <- list(
  lake = "ER",
  protocol = "TWL",
  year__gte = 2010,
  sidep__lte = 20
)
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 875
head(fn122)
#>         PRJ_CD   SAM EFF EFFDST GRDEP GRTEM0 GRTEM1 COMMENT2
#> 1 LEA_IA18_093 4201A 001 781.03   2.4   21.7     NA       NA
#> 2 LEA_IA18_093 4201B 001 789.59   2.4   21.7     NA       NA
#> 3 LEA_IA18_093 4202A 001 790.69   3.5   21.0     NA       NA
#> 4 LEA_IA18_093 4202B 001 805.10   3.5   21.0     NA       NA
#> 5 LEA_IA18_093 4203A 001 801.32   3.1   22.7     NA       NA
#> 6 LEA_IA18_093 4203B 001 731.81   3.1   22.7     NA       NA


filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"), eff = "051"
)
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 171
head(fn122)
#>         PRJ_CD   SAM EFF EFFDST GRDEP GRTEM0 GRTEM1 COMMENT2
#> 1 LSA_IA15_CIN 01001 051  30.48     5     NA     NA       NA
#> 2 LSA_IA15_CIN 01002 051  30.48     5     NA     NA       NA
#> 3 LSA_IA15_CIN 01003 051  30.48     7     NA     NA       NA
#> 4 LSA_IA15_CIN 01004 051  30.48     6     NA     NA       NA
#> 5 LSA_IA15_CIN 01005 051  30.48     6     NA     NA       NA
#> 6 LSA_IA15_CIN 01006 051  30.48    33     NA     NA       NA



filters <- list(lake = "HU", prj_cd__like = "_007", eff = c("127", "140"))
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 758
head(fn122)
#>         PRJ_CD   SAM EFF EFFDST GRDEP GRTEM0 GRTEM1 COMMENT2
#> 1 LHA_IA00_007 00701 127     50   9.2   16.6   17.5       NA
#> 2 LHA_IA00_007 00702 127     50   8.6   16.9   17.8       NA
#> 3 LHA_IA00_007 00703 127     50   5.2   18.4   18.5       NA
#> 4 LHA_IA00_007 00704 127     50   9.1   17.5   17.6       NA
#> 5 LHA_IA00_007 00705 127     50  10.4   17.2   19.2       NA
#> 6 LHA_IA00_007 00706 127     50   6.0   18.2   19.8       NA
```



## FN123 - Catch Counts


Catch counts by effort, species, and group are available using the
`get_FN123()` function.  FN123 records contain information about catch
counts by species for each effort in a sample.  For most gill netting
projects this corresponds to catches within a single panel of a
particular mesh size within a net set (gang). Group (GRP) is
occasionally included to further sub-divide the catch into user defined
groups that are usually specific to the project, but will always be
included and will be '00' by default. This function takes an optional
filter list which can be used to return records based on several
attributes of the catch including species or group code, but also
attributes of the effort, the sample or the project(s) that the
catches were made in.



```r


fn123 <- get_FN123(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#> Warning in check_filters("fn123", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn123)
#> [1] 101
head(fn123)
#>         PRJ_CD SAM EFF SPC GRP CATCNT CATWT BIOCNT SUBCNT SUBWT COMMENT3
#> 1 LOA_IA12_GL1   1 114 334  00      2    NA      2     NA    NA       NA
#> 2 LOA_IA12_GL1   1 127 334  00      1    NA      1     NA    NA       NA
#> 3 LOA_IA12_GL1   1 140 334  00      1    NA      1     NA    NA       NA
#> 4 LOA_IA12_GL1  10 140 334  00      1    NA      1     NA    NA       NA
#> 5 LOA_IA12_GL1 102 127 334  00      1    NA      1     NA    NA       NA
#> 6 LOA_IA12_GL1 103 140 334  00      1    NA      1     NA    NA       NA

filters <- list(
  lake = "ER",
  protocol = "TWL",
  year = 2010,
  spc = c("331", "334"),
  sidep__lte = 20
)
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 107
head(fn123)
#>         PRJ_CD SAM EFF SPC GRP CATCNT CATWT BIOCNT SUBCNT SUBWT COMMENT3
#> 1 LEA_IF10_001 250 001 331  01      4    NA      4     NA    NA         
#> 2 LEA_IF10_001 250 001 331  03     22    NA     22     NA    NA         
#> 3 LEA_IF10_001 250 001 334  01      1    NA      1     NA    NA         
#> 4 LEA_IF10_001 251 001 331  01      2    NA      2     NA    NA         
#> 5 LEA_IF10_001 251 001 331  03     25    NA     25     NA    NA         
#> 6 LEA_IF10_001 251 001 334  01      1    NA      1     NA    NA


filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
  eff = "051",
  spc = "091"
)
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 34
head(fn123)
#>         PRJ_CD   SAM EFF SPC GRP CATCNT CATWT BIOCNT SUBCNT SUBWT COMMENT3
#> 1 LSA_IA15_CIN 01003 051 091  00      3    NA      3     NA    NA       NA
#> 2 LSA_IA15_CIN 01005 051 091  00      4    NA      4     NA    NA       NA
#> 3 LSA_IA15_CIN 01006 051 091  00      2    NA      2     NA    NA       NA
#> 4 LSA_IA15_CIN 01011 051 091  00      4    NA      4     NA    NA       NA
#> 5 LSA_IA15_CIN 01012 051 091  00      3    NA      0     NA    NA       NA
#> 6 LSA_IA15_CIN 01019 051 091  00      2    NA      2     NA    NA       NA


filters <- list(lake = "HU", spc = "076", grp = "55")
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 230
head(fn123)
#>         PRJ_CD SAM EFF SPC GRP CATCNT CATWT BIOCNT SUBCNT SUBWT COMMENT3
#> 1 LHA_IA03_002 219 064 076  55      2 5.937      2     NA    NA         
#> 2 LHA_IA03_002 219 089 076  55      2 3.633      2     NA    NA         
#> 3 LHA_IA03_002 219 114 076  55      1 3.729      1     NA    NA         
#> 4 LHA_IA03_007 706 064 076  55      1 0.325      1     NA    NA         
#> 5 LHA_IA03_007 708 089 076  55      1 0.440      1     NA    NA         
#> 6 LHA_IA03_007 711 064 076  55      1 0.315      1     NA    NA
```



## FN124 - Length Tallies

An api endpoint and associated function for FN124 records has not been created yet, but will be coming soon.



## FN125 - Biological Data

Biological data is maintained in the FN125 table and can be accessed
using the `get_FN125` function. FN125 records contain the biological
data collected from individual fish sampled in assessment projects
such as length, weight, sex, and maturity. For convenience this end point
also returns data from child tables such as the 'preferred' age, and
lamprey wounds.  This function takes an optional filter list which can
be used to return records based on several different biological
attributes (such as size, sex, or maturity), but also of the species,
or group code, or attributes of the effort, the sample, or the
project(s) that the samples were collected in.


```r
fn125 <- get_FN125(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#> Warning in check_filters("fn125", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn125)
#> [1] 230
head(fn125)
#>         PRJ_CD SAM EFF SPC GRP FISH FLEN TLEN  RWT GIRTH CLIPC CLIPA SEX MAT
#> 1 LOA_IA12_GL1   1 114 334  00    1  540   NA 1846    NA    NA    NA   2  NA
#> 2 LOA_IA12_GL1   1 114 334  00    2  496   NA 1585    NA    NA    NA   1  NA
#> 3 LOA_IA12_GL1   1 127 334  00    3  665   NA 4474    NA    NA    NA   2  NA
#> 4 LOA_IA12_GL1   1 140 334  00    4  621   NA 3112    NA    NA    NA   2  NA
#> 5 LOA_IA12_GL1  10 140 334  00    1  708   NA 5539    NA    NA    NA   2  NA
#> 6 LOA_IA12_GL1 102 127 334  00    1  576   NA 2483    NA    NA    NA   1  NA
#>   GON NODA NODC AGEST FATE AGE TISSUE COMMENT5
#> 1  NA   NA   NA    2A   NA   5     NA       NA
#> 2  NA   NA   NA    2A   NA   7     NA       NA
#> 3  NA   NA   NA    2A   NA   7     NA       NA
#> 4  NA   NA   NA    2A   NA   8     NA       NA
#> 5  NA   NA   NA    2A   NA  NA     NA       NA
#> 6  NA   NA   NA    2A   NA  11     NA       NA

filters <- list(
  lake = "ER",
  year = "2019",
  protocol = "TWL",
  spc_in = c("331", "334"),
  sidep__lte = 10
)
fn125 <- get_FN125(filters)
#> Warning in check_filters("fn125", filter_list): Unknown filters provided. These will be ignored:
#>  + spc_in
nrow(fn125)
#> [1] 1853
head(fn125)
#>         PRJ_CD   SAM EFF SPC GRP  FISH FLEN TLEN RWT GIRTH CLIPC CLIPA  SEX
#> 1 LEA_IA19_093 4201A 001 331  01 10001   45   47 1.1    NA    NA    NA <NA>
#> 2 LEA_IA19_093 4201A 001 331  01 10002   46   50 1.3    NA    NA    NA <NA>
#> 3 LEA_IA19_093 4201A 001 331  01 10003   51   55 1.6    NA    NA    NA <NA>
#> 4 LEA_IA19_093 4201A 001 331  01 10004   45   48 1.2    NA    NA    NA <NA>
#> 5 LEA_IA19_093 4201A 001 331  01 10005   49   53 1.2    NA    NA    NA <NA>
#> 6 LEA_IA19_093 4201A 001 331  01 10006   42   44 0.9    NA    NA    NA <NA>
#>    MAT  GON NODA NODC AGEST FATE AGE TISSUE COMMENT5
#> 1 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>
#> 2 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>
#> 3 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>
#> 4 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>
#> 5 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>
#> 6 <NA> <NA>   NA   NA     0    K  NA     NA     <NA>

filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
  eff = "051",
  spc = "091"
)
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 72
head(fn125)
#>         PRJ_CD   SAM EFF SPC GRP  FISH FLEN TLEN RWT GIRTH CLIPC CLIPA SEX MAT
#> 1 LSA_IA15_CIN 01003 051 091  00 10217  220  240 100     0     0    NA   9   9
#> 2 LSA_IA15_CIN 01003 051 091  00 10218  270  305 205     0     0    NA   1   1
#> 3 LSA_IA15_CIN 01003 051 091  00 10219  260  290 185     0     0    NA   9   9
#> 4 LSA_IA15_CIN 01005 051 091  00 10403  293  348 285     0     0    NA   1   2
#> 5 LSA_IA15_CIN 01005 051 091  00 10404  286  320 235     0     0    NA   9   9
#> 6 LSA_IA15_CIN 01005 051 091  00 10405  290  327 265     0     0    NA   1   1
#>   GON NODA NODC AGEST FATE AGE TISSUE COMMENT5
#> 1  99   NA   NA    NA    K   2     NA       NA
#> 2  10   NA   NA    NA    K   6     NA       NA
#> 3  99   NA   NA    NA    K   4     NA       NA
#> 4  22   NA   NA    NA    K   6     NA       NA
#> 5  99   NA   NA    NA    K   5     NA       NA
#> 6  10   NA   NA    NA    K   5     NA       NA



filters <- list(lake = "HU", spc = "076", grp = "55")
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 441
head(fn125)
#>         PRJ_CD SAM EFF SPC GRP  FISH FLEN TLEN  RWT GIRTH CLIPC CLIPA SEX MAT
#> 1 LHA_IA03_002 219 064 076  55 00001  555  583 2640    NA  <NA>    NA   1   2
#> 2 LHA_IA03_002 219 064 076  55 00002  643  665 3297    NA  <NA>    NA   2   2
#> 3 LHA_IA03_002 219 089 076  55 00001  508  523 1953    NA  <NA>    NA   1   2
#> 4 LHA_IA03_002 219 089 076  55 00002  487  500 1680    NA  <NA>    NA   1   1
#> 5 LHA_IA03_002 219 114 076  55 00001  632  655 3729    NA  <NA>    NA   2   2
#> 6 LHA_IA03_007 706 064 076  55 00001  305  315  325    NA  <NA>    NA   1   1
#>   GON NODA NODC AGEST FATE AGE TISSUE COMMENT5
#> 1  20   NA <NA>     1    K   2     NA     <NA>
#> 2  20   NA <NA>     1    K   2     NA     <NA>
#> 3  20   NA <NA>     1    K   2     NA     <NA>
#> 4  10   NA <NA>     1    K   2     NA     <NA>
#> 5  20   NA <NA>     1    K   2     NA     <NA>
#> 6  10   NA <NA>     1    K   3     NA     <NA>
```


## FN125Tags - Tags Recovered or Applied

FN125Tags records contain information about the individual tags
applied to or recovered from on a sampled fish and can be fetched from
the api using `get_FN125Tags()` function.  Historically, tag data was
stored in three related fields - TAGDOC, TAGSTAT and TAGID.  This
convention is fine as long a single biological sample only has a one
tag. In recent years, it has been come increasingly common for fish to
have multiple tags, or tag types associated with individual sampling
events. FN125Tag accommodates those events.  This function takes an
optional filter list which can be used to return records based on
several different attributes of the tag (tag type, colour, placement,
agency, tag stat, and tag number) as well as, attributes of the
sampled fish such as the species, or group code, or attributes of the
effort, the sample, or the project(s) that the samples were collected
in.



```r


fn125_tags <- get_FN125Tags(list(
  lake = "ON",
  year = 2019,
  spc = "081",
  gear = "GL"
))
#> Warning in check_filters("fn125tags", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn125_tags)
#> [1] 186
head(fn125_tags)
#>         PRJ_CD SAM EFF SPC GRP FISH FISH_TAG_ID TAGSTAT  TAGID TAGDOC XCWTSEQ
#> 1 LOA_IA19_GL1  11 127 081  00   14           1      NA 600214  67026      NA
#> 2 LOA_IA19_GL1 115 089 081  00    1           1      NA 600134  67026      NA
#> 3 LOA_IA19_GL1 118 140 081  00    1           1      NA 640584  67026      NA
#> 4 LOA_IA19_GL1 119 102 081  00    1           1      NA 640445  67026      NA
#> 5 LOA_IA19_GL1 119 140 081  00    2           1      NA 600236  67026      NA
#> 6 LOA_IA19_GL1 120 102 081  00    1           1      NA 640716  67026      NA
#>   XTAGINCKD XTAG_CHK COMMENT_TAG
#> 1        NA       NA          NA
#> 2        NA       NA          NA
#> 3        NA       NA          NA
#> 4        NA       NA          NA
#> 5        NA       NA          NA
#> 6        NA       NA          NA


fn125_tags <- get_FN125Tags(list(lake = "SU"))
nrow(fn125_tags)
#> [1] 73
head(fn125_tags)
#>         PRJ_CD   SAM EFF SPC GRP  FISH FISH_TAG_ID TAGSTAT           TAGID
#> 1 LSA_IA13_CIN 01105 140 031  00 13876           1       C 982000088052225
#> 2 LSA_IA13_CIN 01105 153 031  00 13868           1       C            8588
#> 3 LSA_IA13_CIN 01105 153 031  00 13868           2       C      0137908309
#> 4 LSA_IA13_CIN 01105 153 031  00 13869           1       C            8363
#> 5 LSA_IA13_CIN 01105 153 031  00 13869           2       C      0137908644
#> 6 LSA_IA14_CIN 01096 153 031  00 12899           1       A           25529
#>   TAGDOC XCWTSEQ XTAGINCKD XTAG_CHK COMMENT_TAG
#> 1  P7999      NA      <NA>       NA        <NA>
#> 2  23262      NA      <NA>       NA        <NA>
#> 3  P4261      NA      <NA>       NA        <NA>
#> 4  23262      NA      <NA>       NA        <NA>
#> 5  P4261      NA      <NA>       NA        <NA>
#> 6  23019      NA      <NA>       NA        <NA>


filters <- list(lake = "HU", spc = "076", grp = "55")
fn125_tags <- get_FN125Tags(filters)
nrow(fn125_tags)
#> [1] 172
head(fn125_tags)
#>         PRJ_CD SAM EFF SPC GRP FISH FISH_TAG_ID TAGSTAT TAGID TAGDOC XCWTSEQ
#> 1 LHA_IA15_F14  10 001 076  55    1           1       A 28816  25012      NA
#> 2 LHA_IA15_F14  26 001 076  55    1           1       A 28839  25012      NA
#> 3 LHA_IA15_F14   8 001 076  55    1           1       A 28813  25012      NA
#> 4 LHA_IA15_F14   9 001 076  55    1           1       A 28814  25012      NA
#> 5 LHA_IS02_014   1   1 076  55    1           1       A 12631  25012      NA
#> 6 LHA_IS02_014   1   1 076  55    3           1       A 12636  25012      NA
#>   XTAGINCKD XTAG_CHK COMMENT_TAG
#> 1        NA       NA          NA
#> 2        NA       NA          NA
#> 3        NA       NA          NA
#> 4        NA       NA          NA
#> 5        NA       NA          NA
#> 6        NA       NA          NA
```


## FN125Lamprey - Observed Lamprey Wounds


FN125Lam records contain information about the individual lamprey
wounds observed on a sampled fish and can be fetched using the
`get_Fn125Lamprey()` function.  Historically, lamprey wounds were
reported as a single field (XLAM) in the FN125 table.  In the early
2000 the Great Lakes fishery community agreed to capture lamprey
wounding data in a more consistent fashion across the basin using the
conventions described in Ebener et al 2006.  The FN125Lam table
captures data from individual lamprey wounds collected using those
conventions.  A sampled fish with no observed wound will have a single
record in this table (with lamijc value of 0), while fish with lamprey
wounds, will have one record for every observed wound.  This function
takes an optional filter list which can be used to return records
based on several different attributes of the wound (wound type, degree
of healing, and wound size) as well as, attributes of the sampled fish
such as the species, or group code, or attributes of the effort, the
sample, or the project(s) that the samples were collected in.



```r

fn125_lam <- get_FN125Lam(list(
  lake = "ON",
  spc = "081",
  year = "2015",
  gear = "GL"
))
#> Warning in check_filters("fn125lamprey", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn125_lam)
#> [1] 48
head(fn125_lam)
#>         PRJ_CD SAM EFF SPC GRP FISH LAMID XLAM LAMIJC_TYPE LAMIJC_SIZE
#> 1 LOA_IA15_GL1 102 038 081  00    1     1   NA           0          NA
#> 2 LOA_IA15_GL1 102 102 081  00    5     1   NA           0          NA
#> 3 LOA_IA15_GL1 102 114 081  00    7     1   NA           0          NA
#> 4 LOA_IA15_GL1 103 114 081  00    2     1   NA           0          NA
#> 5 LOA_IA15_GL1 116 114 081  00    2     1   NA           0          NA
#> 6 LOA_IA15_GL1 119 089 081  00    1     1   NA           0          NA
#>   COMMENT_LAM
#> 1          NA
#> 2          NA
#> 3          NA
#> 4          NA
#> 5          NA
#> 6          NA


fn125_lam <- get_FN125Lam(list(
  lake = "SU", spc = "081", year__gte = 2015,
  lamijc_type = c("A1", "A2", "A3")
))
nrow(fn125_lam)
#> [1] 357
head(fn125_lam)
#>         PRJ_CD   SAM EFF SPC GRP  FISH LAMID XLAM LAMIJC_TYPE LAMIJC_SIZE
#> 1 LSA_IA15_CIN 01009 076 081  01 10639     1   NA          A3          NA
#> 2 LSA_IA15_CIN 01014 064 081  01 10784     1   NA          A1          NA
#> 3 LSA_IA15_CIN 01014 102 081  01 10771     1   NA          A1          NA
#> 4 LSA_IA15_CIN 01017 089 081  01 10916     1   NA          A1          NA
#> 5 LSA_IA15_CIN 01017 089 081  01 10916     2   NA          A2          NA
#> 6 LSA_IA15_CIN 01017 089 081  01 10916     3   NA          A3          NA
#>   COMMENT_LAM
#> 1        <NA>
#> 2        <NA>
#> 3        <NA>
#> 4        <NA>
#> 5        <NA>
#> 6        <NA>



filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
  eff = "051",
  spc = "091"
)
fn125_lam <- get_FN125Lam(filters)
nrow(fn125_lam)
#> [1] 75
head(fn125_lam)
#>         PRJ_CD   SAM EFF SPC GRP  FISH LAMID XLAM LAMIJC_TYPE LAMIJC_SIZE
#> 1 LSA_IA15_CIN 01003 051 091  00 10217     1   NA           0          NA
#> 2 LSA_IA15_CIN 01003 051 091  00 10218     1   NA           0          NA
#> 3 LSA_IA15_CIN 01003 051 091  00 10219     1   NA           0          NA
#> 4 LSA_IA15_CIN 01005 051 091  00 10403     1   NA           0          NA
#> 5 LSA_IA15_CIN 01005 051 091  00 10404     1   NA           0          NA
#> 6 LSA_IA15_CIN 01005 051 091  00 10405     1   NA           0          NA
#>   COMMENT_LAM
#> 1          NA
#> 2          NA
#> 3          NA
#> 4          NA
#> 5          NA
#> 6          NA


filters <- list(lake = "HU", spc = "076", grp = "55")
fn125_lam <- get_FN125Lam(filters)
nrow(fn125_lam)
#> [1] 361
head(fn125_lam)
#>         PRJ_CD SAM EFF SPC GRP  FISH LAMID XLAM LAMIJC_TYPE LAMIJC_SIZE
#> 1 LHA_IA03_002 219 064 076  55 00001     1 <NA>           0          NA
#> 2 LHA_IA03_002 219 064 076  55 00002     1 <NA>           0          NA
#> 3 LHA_IA03_002 219 089 076  55 00001     1 <NA>           0          NA
#> 4 LHA_IA03_002 219 089 076  55 00002     1 <NA>           0          NA
#> 5 LHA_IA03_002 219 114 076  55 00001     1 <NA>           0          NA
#> 6 LHA_IA03_007 706 064 076  55 00001     1 <NA>           0          NA
#>   COMMENT_LAM
#> 1        <NA>
#> 2        <NA>
#> 3        <NA>
#> 4        <NA>
#> 5        <NA>
#> 6        <NA>
```


## Fn126 - Diet Data

The `get_Fn126()` function can be used to access the api endpoint to
for FN126 records. FN126 records contain the counts of identifiable
items in found in the stomachs of fish sampled and processed in the
field (the FN126 table does include more detailed analysis that is
often conducted in the laboratory).  The `get_FN126()` function takes
an optional filter list which can be used to return records based on
several different attributes of the diet item (taxon, taxon__like), as
well as, attributes of the sampled fish such as the species, or group
code, or attributes of the effort, the sample, or the project(s) that
the samples were collected in.


```r

fn126 <- get_FN126(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#> Warning in check_filters("fn126", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn126)
#> [1] 97
head(fn126)
#>         PRJ_CD SAM EFF SPC GRP FISH FOOD TAXON FDCNT COMMENT6
#> 1 LOA_IA12_GL1   1 114 334  00    1    1  7999     1       NA
#> 2 LOA_IA12_GL1   1 127 334  00    3    1  7999     3       NA
#> 3 LOA_IA12_GL1   1 140 334  00    4    1  7999     3       NA
#> 4 LOA_IA12_GL1 102 127 334  00    1    1  7999     2       NA
#> 5 LOA_IA12_GL1 103 140 334  00    1    1  7999     1       NA
#> 6 LOA_IA12_GL1 113 038 334  00    1    1  7999     2       NA



filters <- list(lake = "SU", prj_cd = c("LSA_IA12_CIN", "LSA_IA17_CIN"))
fn126 <- get_FN126(filters)
nrow(fn126)
#> [1] 331
head(fn126)
#>         PRJ_CD   SAM EFF SPC GRP  FISH FOOD TAXON FDCNT COMMENT6
#> 1 LSA_IA12_CIN 01002 064 081  01 10040    1  F121    NA     <NA>
#> 2 LSA_IA12_CIN 01002 076 081  01 10049    1  F121    NA     <NA>
#> 3 LSA_IA12_CIN 01002 102 081  01 10059    1  F093    NA     <NA>
#> 4 LSA_IA12_CIN 01002 102 081  01 10060    1  F121    NA     <NA>
#> 5 LSA_IA12_CIN 01010 038 081  01 10421    1     0    NA    empty
#> 6 LSA_IA12_CIN 01010 064 081  01 10440    1  F121    NA     <NA>

filters <- list(lake = "HU", spc = "076", grp = "55")
fn126 <- get_FN126(filters)
nrow(fn126)
#> [1] 15
head(fn126)
#>         PRJ_CD SAM EFF SPC GRP  FISH FOOD TAXON FDCNT COMMENT6
#> 1 LHA_IA03_002 219 064 076  55 00002    1  F999    NA       NA
#> 2 LHA_IA03_002 219 089 076  55 00002    1  F999     6       NA
#> 3 LHA_IA03_002 219 089 076  55 00002    2  F291     1       NA
#> 4 LHA_IA03_002 219 089 076  55 00002    3  F280    14       NA
#> 5 LHA_IA03_002 219 114 076  55 00001    1  F999     9       NA
#> 6 LHA_IA03_002 219 114 076  55 00001    2  F280     1       NA
```


## Fn127 - Age Estimates

The `get_fn127()` function can be used to access the api endpoint to
for FN127 records which contain age estimate/interpretations.  This
function takes an optional filter list which can be used to return
records based on several different attributes of the age estimate such
as the assigned age, the aging structure, confidence, number of
complete annuli and edge code, or whether or not it was identified as
the 'preferred' age for this fish. Additionally, filters can be
applied to select age estimates based on attributes of the sampled
fish such as the species, or group code, or attributes of the effort,
the sample, or the project(s) that the samples were collected in.


```r

fn127 <- get_FN127(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#> Warning in check_filters("fn127", filter_list): Unknown filters provided. These will be ignored:
#>  + gear
nrow(fn127)
#> [1] 229
head(fn127)
#>         PRJ_CD SAM EFF SPC GRP FISH AGEID AGEMT XAGEM AGEA PREFERRED CONF NCA
#> 1 LOA_IA12_GL1   1 114 334  00    1     7 A61SM    NA    5      TRUE    9   5
#> 2 LOA_IA12_GL1   1 114 334  00    2     8 A61SM    NA    7      TRUE    9   7
#> 3 LOA_IA12_GL1   1 127 334  00    3     9 A61SM    NA    7      TRUE    9   7
#> 4 LOA_IA12_GL1   1 140 334  00    4    10 A61SM    NA    8      TRUE    9   8
#> 5 LOA_IA12_GL1 102 127 334  00    1   362 A61SM    NA   11      TRUE    9  11
#> 6 LOA_IA12_GL1 103 140 334  00    1   364 A61SM    NA    9      TRUE    9   9
#>   EDGE AGEST COMMENT7
#> 1   NA    NA       NA
#> 2   NA    NA       NA
#> 3   NA    NA       NA
#> 4   NA    NA       NA
#> 5   NA    NA       NA
#> 6   NA    NA       NA

filters <- list(
  lake = "ER",
  protocol = "TWL",
  spc = c("331", "334"),
  year = 2010,
  sidep__lte = 20
)
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 790
head(fn127)
#>         PRJ_CD SAM EFF SPC GRP FISH AGEID AGEMT XAGEM AGEA PREFERRED CONF NCA
#> 1 LEA_IF10_001 250 001 331  03 5824   125    99    99    3      TRUE   NA  NA
#> 2 LEA_IF10_001 250 001 331  03 5825   125    99    99    2      TRUE   NA  NA
#> 3 LEA_IF10_001 250 001 331  03 5826   125    99    99    3      TRUE   NA  NA
#> 4 LEA_IF10_001 250 001 331  03 5827   125    99    99    3      TRUE   NA  NA
#> 5 LEA_IF10_001 250 001 331  03 5828   125    99    99    3      TRUE   NA  NA
#> 6 LEA_IF10_001 250 001 331  03 5830   125    99    99    3      TRUE   NA  NA
#>   EDGE AGEST COMMENT7
#> 1   NA    NA         
#> 2   NA    NA         
#> 3   NA    NA         
#> 4   NA    NA         
#> 5   NA    NA         
#> 6   NA    NA

filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
  eff = "051",
  spc = "091"
)
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 58
head(fn127)
#>         PRJ_CD   SAM EFF SPC GRP  FISH AGEID AGEMT XAGEM AGEA PREFERRED CONF
#> 1 LSA_IA15_CIN 01003 051 091  00 10217     1 A34PD    86    2      TRUE    6
#> 2 LSA_IA15_CIN 01003 051 091  00 10218     1 A34PD    86    6      TRUE    5
#> 3 LSA_IA15_CIN 01003 051 091  00 10219     1 A34PD    86    4      TRUE    5
#> 4 LSA_IA15_CIN 01005 051 091  00 10403     1 A34PD    86    6      TRUE    6
#> 5 LSA_IA15_CIN 01005 051 091  00 10404     1 A34PD    86    5      TRUE    6
#> 6 LSA_IA15_CIN 01005 051 091  00 10405     1 A34PD    86    5      TRUE    6
#>   NCA EDGE AGEST       COMMENT7
#> 1   2   ++    NA Paul Drombolis
#> 2   6   ++    NA Paul Drombolis
#> 3   4   ++    NA Paul Drombolis
#> 4   6   ++    NA Paul Drombolis
#> 5   5   ++    NA Paul Drombolis
#> 6   5   ++    NA Paul Drombolis



filters <- list(lake = "HU", spc = "076", grp = "55")
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 201
head(fn127)
#>         PRJ_CD SAM EFF SPC GRP  FISH AGEID AGEMT XAGEM AGEA PREFERRED CONF NCA
#> 1 LHA_IA03_002 219 064 076  55 00001   125 111WI    21    2      TRUE   NA  NA
#> 2 LHA_IA03_002 219 064 076  55 00002   125 111WI    21    2      TRUE   NA  NA
#> 3 LHA_IA03_002 219 089 076  55 00001   125 111WI    21    2      TRUE   NA  NA
#> 4 LHA_IA03_002 219 089 076  55 00002   125 111WI    21    2      TRUE   NA  NA
#> 5 LHA_IA03_002 219 114 076  55 00001   125 111WI    21    2      TRUE   NA  NA
#> 6 LHA_IA03_007 706 064 076  55 00001   125 111WI    21    3      TRUE   NA  NA
#>   EDGE AGEST COMMENT7
#> 1 <NA>    NA         
#> 2 <NA>    NA         
#> 3 <NA>    NA         
#> 4 <NA>    NA         
#> 5 <NA>    NA         
#> 6 <NA>    NA
```


# Creel Data

The creel portal houses data from creel surveys that where collected
using the FN-II data model and exposes an api that make that data
available in a format that is very similar (if not identical to FN-II
tables).  The glfishr contains a number of function to fetch creel
data that are direct analoges to their fisheries assessment
counterparts.  Most of examples above will work by just changing the
function name from get_FN* to get_SC* and ensureing that any project
codes reference existing creel surveys.

As a simple example, here are several blocks of code that fetch the
data for a single creel and prints out the first few rows of each
table.  (Note that the filter is composed once, and used for all
subsequent functions).


##  SC011 - Creel Meta-data


```r
creel_filter <- list(prj_cd="LHA_SC08_033")
dat <- get_SC011(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc011' endpoint
#> Warning in check_filters("sc011", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- anonymize(dat)
nrow(dat)
#> [1] 1
head(dat)
#>           SLUG LAKE  PRJ_DATE0  PRJ_DATE1       PRJ_CD YEAR
#> 1 lha_sc08_033   HU 2008-06-24 2008-08-31 LHA_SC08_033 2008
#>                                 PRJ_NM COMMENT0 CONTMETH
#> 1 PARRY SOUND ROVING BOAT CREEL - 2008       NA       A2
```

##  SC022 - Season Strata


```r
dat <- get_SC022(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc022' endpoint
#> Warning in check_filters("sc022", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- dat[with(dat, order(PRJ_CD, SSN)),]
nrow(dat)
#> [1] 2
head(dat)
#>         PRJ_CD SSN   SSN_DES  SSN_DATE0  SSN_DATE1
#> 1 LHA_SC08_033  12 JUNE/JULY 2008-06-24 2008-07-31
#> 2 LHA_SC08_033  13    AUGUST 2008-08-01 2008-08-31
```


##  SC023 - Day Type Strata


```r
dat <- get_SC023(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc023' endpoint
#> Warning in check_filters("sc023", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- dat[with(dat, order(PRJ_CD, SSN, DTP)),]
nrow(dat)
#> [1] 4
head(dat)
#>         PRJ_CD SSN DTP   DTP_NM DOW_LST
#> 1 LHA_SC08_033  12   1 WEEKDAYS   23456
#> 3 LHA_SC08_033  12   2 WEEKENDS      17
#> 2 LHA_SC08_033  13   1 WEEKDAYS   23456
#> 4 LHA_SC08_033  13   2 WEEKENDS      17
```

##  SC024 - Period Strata


```r
dat <- get_SC024(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc024' endpoint
#> Warning in check_filters("sc024", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- dat[with(dat, order(PRJ_CD, SSN, DTP, PRD)),]
nrow(dat)
#> [1] 8
head(dat)
#>         PRJ_CD SSN DTP PRD   PRDTM0   PRDTM1 PRD_DUR
#> 1 LHA_SC08_033  12   1   1 07:00:00 14:00:00       7
#> 6 LHA_SC08_033  12   1   2 14:00:00 21:00:00       7
#> 2 LHA_SC08_033  12   2   1 07:00:00 14:00:00       7
#> 8 LHA_SC08_033  12   2   2 14:00:00 21:00:00       7
#> 3 LHA_SC08_033  13   1   1 07:00:00 14:00:00       7
#> 7 LHA_SC08_033  13   1   2 14:00:00 21:00:00       7
```

##  SC025 - Exception Dates


```r
dat <- get_SC025(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc025' endpoint
#> Warning in check_filters("sc025", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> NULL
head(dat)
#> named list()
```

##  SC026 - Spatial Strata


```r
dat <- get_SC026(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc026' endpoint
#> Warning in check_filters("sc026", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- dat[with(dat, order(PRJ_CD, SPACE)),]
nrow(dat)
#> [1] 8
head(dat)
#>         PRJ_CD SPACE               SPACE_DES SPACE_SIZ AREA_CNT AREA_LST
#> 1 LHA_SC08_033    01             SMALL SOUND        NA        1       01
#> 2 LHA_SC08_033    02                 HAY BAY        NA        1       02
#> 3 LHA_SC08_033    03   SE HUCKLEBERRY ISLAND        NA        1       03
#> 4 LHA_SC08_033    04           DEPOT HARBOUR        NA        1       04
#> 5 LHA_SC08_033    05   SOUTH OF MOWAT ISLAND        NA        1       05
#> 6 LHA_SC08_033    07 BLIND,COLLINS,LOON BAYS        NA        1       07
#>   AREA_WT DD_LAT DD_LON
#> 1       0     NA     NA
#> 2       0     NA     NA
#> 3       0     NA     NA
#> 4       0     NA     NA
#> 5       0     NA     NA
#> 6       0     NA     NA
```

##  SC028 - Fishing Modes


```r
dat <- get_SC028(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc028' endpoint
#> Warning in check_filters("sc028", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
dat <- dat[with(dat, order(PRJ_CD, MODE)),]
nrow(dat)
#> [1] 1
head(dat)
#>         PRJ_CD MODE     MODE_DES ATYUNIT ITVUNIT CHKFLAG
#> 1 LHA_SC08_033   S1 BOAT ANGLING       1       2       0
```


##  SC111 - Creel Logs


```r
dat <- get_SC111(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc111' endpoint
#> Warning in check_filters("sc111", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> [1] 348
head(dat)
#>         PRJ_CD SAMA SSN DTP PRD SPACE MODE       DATE   SAMTM0 WEATHER
#> 1 LHA_SC08_033 1001  12   1   2    05   S1 2008-06-24 14:00:00       1
#> 2 LHA_SC08_033 1002  12   1   2    07   S1 2008-06-24 14:00:00       0
#> 3 LHA_SC08_033 1003  12   1   2    08   S1 2008-06-24 14:00:00       0
#> 4 LHA_SC08_033 1004  12   1   2    09   S1 2008-06-24 14:00:00       0
#> 5 LHA_SC08_033 1005  12   1   2    03   S1 2008-06-24 14:00:00       1
#> 6 LHA_SC08_033 1006  12   1   2    01   S1 2008-06-24 14:00:00       0
#>           COMMENT1
#> 1 A FEW WHITE CAPS
#> 2             <NA>
#> 3             <NA>
#> 4             <NA>
#> 5             <NA>
#> 6             <NA>
```

##  SC112 - Activity Counts



```r
dat <- get_SC112(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc112' endpoint
#> Warning in check_filters("sc112", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> [1] 348
head(dat)
#>         PRJ_CD SAMA   ATYTM0   ATYTM1 ATYCNT CHKCNT ITVCNT ATYDUR
#> 1 LHA_SC08_033 1001 15:39:00 16:10:00      0      0      0      0
#> 2 LHA_SC08_033 1002 16:12:00 16:36:00      0      0      0      0
#> 3 LHA_SC08_033 1003 16:37:00 17:01:00      1      0      1      0
#> 4 LHA_SC08_033 1004 17:19:00 17:27:00      0      0      0      0
#> 5 LHA_SC08_033 1005 17:29:00 17:42:00      0      0      0      0
#> 6 LHA_SC08_033 1006 17:43:00 17:54:00      0      0      0      0
```

##  SC121 - Creel Interviews


```r
dat <- get_SC121(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc121' endpoint
#> Warning in check_filters("sc121", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> [1] 510
head(dat)
#>         PRJ_CD SAMA SSN DTP PRD SPACE MODE   SAM ITVSEQ   ITVTM0       DATE
#> 1 LHA_SC08_033 1003  12   1   2    08   S1 10001      1 16:39:00 2008-06-24
#> 2 LHA_SC08_033 1008  12   1   2    04   S1 10002      1 18:40:00 2008-06-24
#> 3 LHA_SC08_033 1009  12   1   1    08   S1 10003      1 07:15:00 2008-06-25
#> 4 LHA_SC08_033 1010  12   1   1    09   S1 10004      1 08:07:00 2008-06-25
#> 5 LHA_SC08_033 1010  12   1   1    09   S1 10005      2 08:15:00 2008-06-25
#> 6 LHA_SC08_033 1011  12   1   1    03   S1 10006      1 09:02:00 2008-06-25
#>     EFFTM0   EFFTM1 EFFCMP EFFDUR PERSONS ANGLERS RODS ANGMETH ANGVIS ANGORIG
#> 1 15:00:00     <NA>  FALSE   1.65       3       2    2       5      1       1
#> 2 10:00:00 18:45:00   TRUE   8.75       1       1    1       1      3       2
#> 3 06:00:00     <NA>  FALSE   1.25       2       1    1       5      7       5
#> 4 08:00:00     <NA>  FALSE   0.12       3       2    2       5      1       1
#> 5 08:05:00     <NA>  FALSE   0.17       1       1    1       4      1       1
#> 6 08:32:00     <NA>  FALSE   0.50       3       3    3       5      1       1
#>   ANGOP1 ANGOP2 ANGOP3
#> 1   <NA>     NA     NA
#> 2   <NA>     NA     NA
#> 3   <NA>     NA     NA
#> 4   <NA>     NA     NA
#> 5   <NA>     NA     NA
#> 6      5     NA     NA
#>                                                                                                    COMMENT1
#> 1                                                                                                      <NA>
#> 2                                                                                                      <NA>
#> 3                                                                                          GERMANY, COTTAGE
#> 4                                                                                                      <NA>
#> 5                                                                                                      <NA>
#> 6 ONE LOCAL (PARRY SOUND), 2 ONTARIO RESIDENTS (STURGEON FALLS)  RELEASED 1 TOO LARGE, RELEASED 2 TOO SMALL
```

##  SC123 - Catch Counts


```r
dat <- get_SC123(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc123' endpoint
#> Warning in check_filters("sc123", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> [1] 647
head(dat)
#>         PRJ_CD   SAM SPC GRP  SEK HVSCNT RLSCNT MESCNT MESWT
#> 1 LHA_SC08_033 10001 081  00 TRUE      0      0      0    NA
#> 2 LHA_SC08_033 10002 093  00 TRUE     30      5      0    NA
#> 3 LHA_SC08_033 10003 081  00 TRUE      0      0      0    NA
#> 4 LHA_SC08_033 10004 081  00 TRUE      0      0      0    NA
#> 5 LHA_SC08_033 10005 131  00 TRUE      0      0      0    NA
#> 6 LHA_SC08_033 10006 081  00 TRUE      0      2      0    NA
```

##  SC125 - Bioligical Samples


```r
dat <- get_SC125(creel_filter)
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc125' endpoint
#> Warning in check_filters("sc125", filter_list): Unknown filters provided. These will be ignored:
#>  + prj_cd
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/api/v1/sc125/?prj_cd=LHA_SC08_033"
nrow(dat)
#> NULL
head(dat)
#> $PATHS
#> list()
```


##  SC125 Lamprey - Observed Lamprey Wounds


```r
dat <- get_SC125Lam(creel_filter)
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc125lamprey' endpoint
#> Warning in check_filters("sc125lamprey", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + prj_cd
nrow(dat)
#> [1] 49
head(dat)
#>         PRJ_CD   SAM SPC GRP FISH LAMID XLAM LAMIJC LAMIJC_TYPE LAMIJC_SIZE
#> 1 LHA_SC08_033 10008 081  00    1     1          NA           0          NA
#> 2 LHA_SC08_033 10027 081  00    1     1          NA           0          NA
#> 3 LHA_SC08_033 10034 081  00    1     1          NA           0          NA
#> 4 LHA_SC08_033 10035 081  00    1     1          NA           0          NA
#> 5 LHA_SC08_033 10052 081  00    1     1          NA           0          NA
#> 6 LHA_SC08_033 10052 081  00    2     1          NA           0          NA
#>   COMMENT_LAM
#> 1          NA
#> 2          NA
#> 3          NA
#> 4          NA
#> 5          NA
#> 6          NA
```

##  SC125 Tags - Applied or Recovered Tags


```r
#note the filter has changed
dat <- get_SC125Tags(list(year=2000, lake='HU'))
#> [1] "unable able to parse the json response from:"
#> [1] "http://10.167.37.157/creels/swagger.json"
#> Warning in refresh_filters(endpoint, api_app = api_app): Filters could not be
#> found for the 'sc125tags' endpoint
#> Warning in check_filters("sc125tags", filter_list, api_app = "creels"): Unknown filters provided. These will be ignored:
#>  + year
#>  + lake
nrow(dat)
#> [1] 11
head(dat)
#>         PRJ_CD   SAM SPC GRP FISH FISH_TAG_ID TAGSTAT  TAGID TAGDOC XCWTSEQ
#> 1 LHA_SC00_100 10026 075  00    4           1       C 175953  99999      NA
#> 2 LHA_SC00_100 10037 081  00    1           1       C 204315  99999      NA
#> 3 LHA_SC00_100 10101 081  00    2           1       C 204311  99999      NA
#> 4 LHA_SC00_100 10107 081  00    2           1       C 204335  99999      NA
#> 5 LHA_SC00_100 10113 081  00    2           1       C 204351  99999      NA
#> 6 LHA_SC00_100 10209 076  00    2           1       C 175961  99999      NA
#>   XTAGINCKD XTAG_CHK
#> 1        NA       NA
#> 2        NA       NA
#> 3        NA       NA
#> 4        NA       NA
#> 5        NA       NA
#> 6        NA       NA
```
