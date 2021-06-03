---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# glfishr

glfishr contains a series of R functions that are intended to make it
easy to get fisheries assessment data from the fn_portal api and into
R for subsequent analysis and reporting.  Functions are named
semantically to reflect the FN-II table they fetch data from
(e.g. `get_FN011()` for project meta data, `get_FN121()` for net
set/sample data and `get_FN125()` for biological sample data).  Most
of the functions take an optional filter_list parameter that can be
used to finely control which records are returned.  Care has been
taken to ensure that the available filters are consistent with FN-II
field names whenever possible, and in many cases, filters can be
re-used across different tables (e.g. - if a filter is passed to the
`get_FN121()` function to find a subset of net sets, that same filter
can be applied to the `get_FN125()` function to get the all of the
biological samples collected in those net sets).


## FN011 - Projects

Project meta data can be accessed using the `get_fn011()` function
FN011 records contiain the hi-level meta data about an
OMNR netting project.  The FN011 record contain information like
project code, project name, projet leader, start and end date,
protocol, and the lake where the project was conducted.  This
function takes an optional filter list which can be used to select
record based on several attributes of the project such as
project code, or part of the project code, lake, first year, last
year, protocol, ect.



```r

fn011 <- get_FN011(list(lake='ON', first_year=2012, last_year=2018))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 7
head(fn011)
#>     id year       prj_cd         slug
#> 1 1129 2018 LOA_IA18_GL1 loa_ia18_gl1
#> 2 1128 2017 LOA_IA17_GL1 loa_ia17_gl1
#> 3 1127 2016 LOA_IA16_GL1 loa_ia16_gl1
#> 4 1126 2015 LOA_IA15_GL1 loa_ia15_gl1
#> 5 1125 2014 LOA_IA14_GL1 loa_ia14_gl1
#> 6 1124 2013 LOA_IA13_GL1 loa_ia13_gl1
#>                                                   prj_nm  prj_date0  prj_date1
#> 1         2018 Lake Ontario Fish Community Index Gillnet 2018-06-18 2018-10-31
#> 2         2017 Lake Ontario Fish Community Index Gillnet 2017-06-19 2017-11-02
#> 3         2016 Lake Ontario Fish Community Index Gillnet 2016-06-20 2016-09-09
#> 4      2015 Eastern Lake Ontario Community Index Gillnet 2015-06-05 2015-09-15
#> 5                2014 E.L.O. Community Index Gillnetting 2014-06-09 2014-09-15
#> 6 2013 Eastern Lake Ontario Fish Community Index Gillnet 2013-06-24 2013-09-15
#>   protocol   source comment0 lake.lake_name lake.abbrev
#> 1     OSIA offshore        8   Lake Ontario          ON
#> 2     OSIA offshore        8   Lake Ontario          ON
#> 3     OSIA offshore        8   Lake Ontario          ON
#> 4     OSIA offshore        8   Lake Ontario          ON
#> 5     OSIA offshore        8   Lake Ontario          ON
#> 6     OSIA offshore        8   Lake Ontario          ON

fn011 <- get_FN011(list(lake='ER', protocol='TWL'))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 33
head(fn011)
#>     id year       prj_cd         slug                   prj_nm  prj_date0
#> 1 1377 2019 LEA_IF19_001 lea_if19_001 Lake Erie Index Trawling 2019-08-12
#> 2 1376 2018 LEA_IF18_001 lea_if18_001 Lake Erie Index Trawling 2018-08-13
#> 3 1375 2017 LEA_IF17_001 lea_if17_001 Lake Erie Index Trawling 2017-08-14
#> 4 1374 2016 LEA_IF16_001 lea_if16_001 Lake Erie Index Trawling 2016-08-15
#> 5 1373 2015 LEA_IF15_001 lea_if15_001 Lake Erie Index Trawling 2015-08-10
#> 6 1372 2014 LEA_IF14_001 lea_if14_001 Lake Erie Index Trawling 2014-08-11
#>    prj_date1 protocol      source comment0 lake.lake_name lake.abbrev
#> 1 2019-08-29      TWL le_trawl_db               Lake Erie          ER
#> 2 2018-08-23      TWL le_trawl_db               Lake Erie          ER
#> 3 2017-08-24      TWL le_trawl_db               Lake Erie          ER
#> 4 2016-08-24      TWL le_trawl_db               Lake Erie          ER
#> 5 2015-08-19      TWL le_trawl_db               Lake Erie          ER
#> 6 2014-08-20      TWL le_trawl_db               Lake Erie          ER


filters <- list(lake='SU', prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'))
fn011 <- get_FN011(filters)
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 2
head(fn011)
#>     id year       prj_cd         slug                             prj_nm
#> 1 1099 2017 LSA_IA17_CIN lsa_ia17_cin Lake Superior Fish Community Index
#> 2 1097 2015 LSA_IA15_CIN lsa_ia15_cin Lake Superior Fish Community Index
#>    prj_date0  prj_date1 protocol   source comment0 lake.lake_name lake.abbrev
#> 1 2017-06-06 2017-08-21     OSIA offshore       NA  Lake Superior          SU
#> 2 2015-08-02 2015-08-28     OSIA offshore       NA  Lake Superior          SU


fn011 <- get_FN011(list(lake='HU', prj_cd_like='_006'))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 35
head(fn011)
#>    id year       prj_cd         slug
#> 1 469 2019 LHA_IA19_006 lha_ia19_006
#> 2 465 2018 LHA_IA18_006 lha_ia18_006
#> 3 458 2017 LHA_IA17_006 lha_ia17_006
#> 4 451 2016 LHA_IA16_006 lha_ia16_006
#> 5 446 2015 LHA_IA15_006 lha_ia15_006
#> 6 441 2014 LHA_IA14_006 lha_ia14_006
#>                                          prj_nm  prj_date0  prj_date1 protocol
#> 1 Southern Main Basin Offshore Index Assessment 2019-06-17 2019-10-10     OSIA
#> 2        Offshore Index Assessment - Grand Bend 2018-06-25 2018-10-03     OSIA
#> 3        Offshore Index Assessment - Grand Bend 2017-06-21 2017-10-03     OSIA
#> 4                   Offshore Index - Grand Bend 2016-06-13 2016-10-06     OSIA
#> 5                   Offshore Index - Grand Bend 2015-06-18 2015-10-07     OSIA
#> 6        Offshore Index Assessment - Grand Bend 2014-06-19 2014-10-02     OSIA
#>     source comment0 lake.lake_name lake.abbrev
#> 1 offshore     <NA>     Lake Huron          HU
#> 2 offshore     <NA>     Lake Huron          HU
#> 3 offshore     <NA>     Lake Huron          HU
#> 4 offshore     <NA>     Lake Huron          HU
#> 5 offshore     <NA>     Lake Huron          HU
#> 6 offshore     <NA>     Lake Huron          HU
```


## FN121 - Net Sets

Net sets can be retrieved using the `get_FN121()` function.  The FN121
records contain information like set and lift date and time, effort
duration, gear, site depth and location.  This function takes an
optional filter list which can be used to return record based on
several attributes of the net set including set and lift date and
time, effort duration, gear, site depth and location as well as
attributes of the projects they are associated with such project code,
or part of the project code, lake, first year, last year, protocol,
etc.



```r

fn121 <- get_FN121(list(lake='ON', year=2012))
nrow(fn121)
#> [1] 178
head(fn121)
#>      id       prj_cd sam     effdt0     effdt1 effdur   efftm0   efftm1 effst
#> 1 44140 LOA_IA12_GL1   1 2012-07-03 2012-07-04     22 07:15:00 05:50:00    NA
#> 2 44149 LOA_IA12_GL1  10 2012-07-03 2012-07-04     22 08:38:00 07:15:00    NA
#> 3 44239 LOA_IA12_GL1 100 2012-07-25 2012-07-26     18 10:31:00 04:52:00    NA
#> 4 44240 LOA_IA12_GL1 101 2012-07-25 2012-07-26     18 11:05:00 05:11:00    NA
#> 5 44241 LOA_IA12_GL1 102 2012-07-25 2012-07-26     18 11:05:00 05:11:00    NA
#> 6 44242 LOA_IA12_GL1 103 2012-07-30 2012-08-01     24 06:20:00 06:50:00    NA
#>   grtp   gr orient sidep site   dd_lat    dd_lon sitem comment1 secchi
#> 1   NA GL6B     NA   7.5 GI08 44.10111 -76.79611    NA       NA    7.5
#> 2   NA GL6B     NA  27.5 GI28 44.07250 -76.78861    NA       NA    9.0
#> 3   NA GL6C     NA   7.5 HB08 44.11222 -77.03972    NA       NA    1.5
#> 4   NA GL6C     NA  12.5 HB13 44.09778 -77.08028    NA       NA    1.5
#> 5   NA GL6C     NA  12.5 HB13 44.09778 -77.08028    NA       NA    1.5
#> 6   NA GL6B     NA   7.5 RP08 43.92667 -76.87944    NA       NA    7.0
#>               slug grid.slug grid.grid
#> 1   loa_ia12_gl1-1   on_9999      9999
#> 2  loa_ia12_gl1-10   on_9999      9999
#> 3 loa_ia12_gl1-100   on_9999      9999
#> 4 loa_ia12_gl1-101   on_9999      9999
#> 5 loa_ia12_gl1-102   on_9999      9999
#> 6 loa_ia12_gl1-103   on_9999      9999


fn121 <- get_FN121(list(lake='ER', protocol='TWL', sidep_lte=20))
nrow(fn121)
#> [1] 1000
head(fn121)
#>      id       prj_cd sam     effdt0     effdt1    effdur   efftm0   efftm1
#> 1 57985 LEA_IF19_001 250 2019-08-12 2019-08-12 0.1666667 11:11:00 01:21:00
#> 2 57986 LEA_IF19_001 251 2019-08-12 2019-08-12 0.1666667 11:49:00 01:59:00
#> 3 57987 LEA_IF19_001 252 2019-08-12 2019-08-12 0.1666667 12:44:00 01:54:00
#> 4 57988 LEA_IF19_001 253 2019-08-12 2019-08-12 0.1666667 14:02:00 01:12:00
#> 5 57989 LEA_IF19_001 254 2019-08-12 2019-08-12 0.1666667 14:44:00 01:54:00
#> 6 57990 LEA_IF19_001 255 2019-08-13 2019-08-13 0.1666667 08:42:00 00:52:00
#>   effst grtp gr orient sidep site   dd_lat    dd_lon sitem             comment1
#> 1     1   TW BT      9  13.4   18 41.70383 -82.54633    NA    thermo 11.5 - 12m
#> 2     1   TW BT      9  12.4   17 41.73167 -82.56300    NA                 <NA>
#> 3     1   TW BT      9  10.6   16 41.80533 -82.58550    NA                 <NA>
#> 4     1   TW BT      9   7.8    2 41.93450 -82.52167    NA                 <NA>
#> 5     1   TW BT      9   8.5    7 41.97200 -82.54517    NA                 <NA>
#> 6     1   TW BT      9  11.2   15 41.98133 -82.63583    NA EXO touched sediment
#>   secchi             slug grid.slug grid.grid
#> 1     NA lea_if19_001-250   er-9999      9999
#> 2     NA lea_if19_001-251   er-9999      9999
#> 3     NA lea_if19_001-252   er-9999      9999
#> 4     NA lea_if19_001-253   er-9999      9999
#> 5     NA lea_if19_001-254   er-9999      9999
#> 6     NA lea_if19_001-255   er-9999      9999


filters <- list(lake='SU',
           prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'))

fn121 <- get_FN121(filters)

nrow(fn121)
#> [1] 171
head(fn121)
#>      id       prj_cd   sam     effdt0     effdt1   effdur   efftm0   efftm1
#> 1 39082 LSA_IA17_CIN 01001 2017-06-06 2017-06-07 28.78333 07:55:00 12:42:00
#> 2 39083 LSA_IA17_CIN 01002 2017-06-06 2017-06-07 26.75000 09:15:00 12:00:00
#> 3 39084 LSA_IA17_CIN 01003 2017-06-06 2017-06-07 26.43333 08:38:00 11:04:00
#> 4 39085 LSA_IA17_CIN 01004 2017-06-07 2017-06-08 27.96667 08:18:00 12:16:00
#> 5 39086 LSA_IA17_CIN 01005 2017-06-07 2017-06-08 27.03333 08:37:00 11:39:00
#> 6 39087 LSA_IA17_CIN 01006 2017-06-07 2017-06-08 25.93333 08:59:00 10:55:00
#>   effst grtp   gr orient sidep site   dd_lat    dd_lon sitem      comment1
#> 1     1   GL GL10      1    22    S 48.34583 -89.13167    NA 0m waveheight
#> 2     1   GL GL10      1    36    M 48.30217 -89.17050    NA 0m waveheight
#> 3     1   GL GL10      1    14    S 48.27883 -89.06400    NA 0m waveheight
#> 4     1   GL GL10      1    13    S 48.24067 -89.23667    NA 0m waveheight
#> 5     1   GL GL10      1    19    S 48.25650 -89.21450    NA 0m waveheight
#> 6     1   GL GL10      1    33    M 48.24533 -89.17283    NA 0m waveheight
#>   secchi               slug grid.slug grid.grid
#> 1     NA lsa_ia17_cin-01001   su-0938       938
#> 2     NA lsa_ia17_cin-01002   su-0938       938
#> 3     NA lsa_ia17_cin-01003   su-1039      1039
#> 4     NA lsa_ia17_cin-01004   su-1137      1137
#> 5     NA lsa_ia17_cin-01005   su-1037      1037
#> 6     NA lsa_ia17_cin-01006   su-1137      1137


fn121 <- get_FN121(list(lake='HU', prj_cd_like='_006'))
nrow(fn121)
#> [1] 1000
head(fn121)
#>     id       prj_cd sam     effdt0     effdt1 effdur   efftm0   efftm1 effst
#> 1 7546 LHA_IA19_006 601 2019-06-17 2019-06-18  15.43 18:23:00 09:49:00     1
#> 2 7547 LHA_IA19_006 602 2019-06-17 2019-06-18  14.21 18:50:00 09:03:00     1
#> 3 7548 LHA_IA19_006 603 2019-06-17 2019-06-18  13.23 19:11:00 08:25:00     1
#> 4 7549 LHA_IA19_006 604 2019-06-18 2019-06-19  25.00 10:48:00 11:48:00     1
#> 5 7550 LHA_IA19_006 605 2019-06-18 2019-06-19  24.20 11:03:00 11:15:00     1
#> 6 7551 LHA_IA19_006 606 2019-06-18 2019-06-19  23.28 11:30:00 10:47:00     1
#>   grtp   gr orient sidep site   dd_lat    dd_lon sitem    comment1 secchi
#> 1   GL GL21      1  30.1 3627 43.39013 -81.93372    NA    CJ MM TW     NA
#> 2   GL GL21      1  24.2 3628 43.34737 -81.91447    NA    CJ MM TW     NA
#> 3   GL GL21      1  20.4 3728 43.31910 -81.89620    NA    CJ MM TW     NA
#> 4   GL GL21      1  37.2 3626 43.36205 -82.03072    NA CJ RD MM TW     NA
#> 5   GL GL21      1  34.9 3626 43.34585 -82.01992    NA CJ RD MM TW     NA
#> 6   GL GL21      1  27.5 3727 43.32137 -81.96190    NA CJ RD MM TW     NA
#>               slug grid.slug grid.grid
#> 1 lha_ia19_006-601   hu-3627      3627
#> 2 lha_ia19_006-602   hu-3628      3628
#> 3 lha_ia19_006-603   hu-3728      3728
#> 4 lha_ia19_006-604   hu-3626      3626
#> 5 lha_ia19_006-605   hu-3626      3626
#> 6 lha_ia19_006-606   hu-3727      3727
```


## FN122 - Sample Efforts


Sample Efforts can be retieved using the `get_fn122()` function. FN122
records contain information about efforts within a sample.  For most
gill netting project an effort corresponds to a single panel of a
particular mesh size within a net set (gang). For trap netting and
trawling projects, there is usually just a single effort. The FN122
table contains information about that particular effort such as gear
depth, gear temperature at set and lift, and effort distance.  This
function takes an optional filter list which can be used to return
records based on several attributes of the effort including effort
distance and depth but also attributes of the projects or nets set
they are associated with such project code, lake, first year, last
year, protocol, gear etc.



```r


fn122 <- get_FN122(list(lake='ON', year=2012, gear="GL"))
nrow(fn122)
#> [1] 1000
head(fn122)
#>       id effdst grdep grtem0 grtem1               slug
#> 1 212459    4.6   6.7   19.2     NA loa_ia12_gl1-1-038
#> 2 212460   15.2   6.7   19.2     NA loa_ia12_gl1-1-051
#> 3 212461   15.2   6.7   19.2     NA loa_ia12_gl1-1-064
#> 4 212462   15.2   6.7   19.2     NA loa_ia12_gl1-1-076
#> 5 212463   15.2   6.7   19.2     NA loa_ia12_gl1-1-089
#> 6 212464   15.2   6.7   19.2     NA loa_ia12_gl1-1-102


fn122 <- get_FN122(list(lake='ER', protocol='TWL', sidep_lte=20))
nrow(fn122)
#> [1] 1000
head(fn122)
#>       id effdst grdep grtem0 grtem1                 slug
#> 1 306437     NA   7.4   25.5     NA lea_if87_001-012-001
#> 2 306438     NA   7.3   24.5     NA lea_if87_001-023-001
#> 3 306439     NA   8.8   25.5     NA lea_if87_001-022-001
#> 4 306440     NA   2.5   26.0     NA lea_if87_001-021-001
#> 5 306441     NA   4.9   25.5     NA lea_if87_001-020-001
#> 6 306442     NA   8.2   25.0     NA lea_if87_001-019-001


filters <- list(lake='SU',
           prj_cd__in=c('LSA_IA15_CIN','LSA_IA17_CIN', eff='051'))
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 1000
head(fn122)
#>       id effdst    grdep grtem0 grtem1                   slug
#> 1 157338  30.48 35.36585     NA     NA lsa_ia09_cin-01001-038
#> 2 157339  30.48 35.36585     NA     NA lsa_ia09_cin-01001-051
#> 3 157340  30.48 34.75610     NA     NA lsa_ia09_cin-01001-064
#> 4 157341  30.48 35.67073     NA     NA lsa_ia09_cin-01001-076
#> 5 157342  30.48 35.67073     NA     NA lsa_ia09_cin-01001-089
#> 6 157343  30.48 34.75610     NA     NA lsa_ia09_cin-01001-102



filters <- list(lake='HU', prj_cd_like='_006', eff_in=c('127','140'))
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 1000
head(fn122)
#>     id effdst grdep grtem0 grtem1                 slug
#> 1 8288     46    18     NA     NA lha_ia84_006-101-038
#> 2 8289     91    18     NA     NA lha_ia84_006-101-051
#> 3 8290     91    18     NA     NA lha_ia84_006-101-064
#> 4 8291     91    18     NA     NA lha_ia84_006-101-076
#> 5 8292     91    18     NA     NA lha_ia84_006-101-089
#> 6 8293     91    18     NA     NA lha_ia84_006-101-102
```



## FN123 - Catch Counts


Catch counts by effort, species, and group are available using the
`get_FN123()` function.  FN123 records contain information about catch
counts by species for each effort in a sample.  For most gill netting
projects this corresponds to catches within a single panel of a
particular mesh size within a net set (gang). Group (GRP) is
occationally included to futher sub-devide the catch into user defined
groups that are usually specific to the project, but will alway be
included and will be '00' by default. This function takes an optional
filter list which can be used to return record based on several
attributes of the catch including species, or group code but also
attributes of the effort, the sample or the project(s) that the
catches were made in.



```r


fn123 <- get_FN123(list(lake='ON', year=2012, spc='334',gear="GL"))
nrow(fn123)
#> [1] 101
head(fn123)
#>       id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 477903 LOA_IA12_GL1   1 114 334  00      2    NA      2      NA
#> 2 477904 LOA_IA12_GL1   1 127 334  00      1    NA      1      NA
#> 3 477905 LOA_IA12_GL1   1 140 334  00      1    NA      1      NA
#> 4 477911 LOA_IA12_GL1   2 114 334  00      1    NA      1      NA
#> 5 477912 LOA_IA12_GL1   2 127 334  00      6    NA      6      NA
#> 6 477913 LOA_IA12_GL1   2 140 334  00      3    NA      3      NA
#>                        slug
#> 1 loa_ia12_gl1-1-114-334-00
#> 2 loa_ia12_gl1-1-127-334-00
#> 3 loa_ia12_gl1-1-140-334-00
#> 4 loa_ia12_gl1-2-114-334-00
#> 5 loa_ia12_gl1-2-127-334-00
#> 6 loa_ia12_gl1-2-140-334-00

filters <- list(lake='ER',
                protocol='TWL',
                year=2010,
                spc=c('331', '334'),
                sidep_lte=20)
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 107
head(fn123)
#>       id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 737998 LEA_IF10_001 265 001 331  03     45    NA     28        
#> 2 738009 LEA_IF10_001 264 001 331  03     33    NA     30        
#> 3 738012 LEA_IF10_001 265 001 331  01     79    NA     30        
#> 4 738019 LEA_IF10_001 265 001 334  01      1    NA      1        
#> 5 738024 LEA_IF10_001 263 001 334  02      2    NA      2        
#> 6 738025 LEA_IF10_001 250 001 334  01      1    NA      1        
#>                          slug
#> 1 lea_if10_001-265-001-331-03
#> 2 lea_if10_001-264-001-331-03
#> 3 lea_if10_001-265-001-331-01
#> 4 lea_if10_001-265-001-334-01
#> 5 lea_if10_001-263-001-334-02
#> 6 lea_if10_001-250-001-334-01


filters <- list(lake='SU',
           prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 34
head(fn123)
#>       id       prj_cd   sam eff spc grp catcnt catwt biocnt comment
#> 1 412502 LSA_IA15_CIN 01003 051 091  00      3    NA      3      NA
#> 2 412557 LSA_IA15_CIN 01005 051 091  00      4    NA      4      NA
#> 3 412582 LSA_IA15_CIN 01006 051 091  00      2    NA      2      NA
#> 4 412678 LSA_IA15_CIN 01011 051 091  00      4    NA      4      NA
#> 5 412698 LSA_IA15_CIN 01012 051 091  00      3    NA      0      NA
#> 6 412838 LSA_IA15_CIN 01019 051 091  00      2    NA      2      NA
#>                            slug
#> 1 lsa_ia15_cin-01003-051-091-00
#> 2 lsa_ia15_cin-01005-051-091-00
#> 3 lsa_ia15_cin-01006-051-091-00
#> 4 lsa_ia15_cin-01011-051-091-00
#> 5 lsa_ia15_cin-01012-051-091-00
#> 6 lsa_ia15_cin-01019-051-091-00


filters <- list(lake='HU', spc='076', grp='55')
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 220
head(fn123)
#>      id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 97167 LHA_IA03_002 219 064 076  55      2 5.937      2        
#> 2 97175 LHA_IA03_002 219 089 076  55      2 3.633      2        
#> 3 97184 LHA_IA03_002 219 114 076  55      1 3.729      1        
#> 4 98217 LHA_IA03_007 706 064 076  55      1 0.325      1        
#> 5 98238 LHA_IA03_007 708 089 076  55      1 0.440      1        
#> 6 98276 LHA_IA03_007 711 064 076  55      1 0.315      1        
#>                          slug
#> 1 lha_ia03_002-219-064-076-55
#> 2 lha_ia03_002-219-089-076-55
#> 3 lha_ia03_002-219-114-076-55
#> 4 lha_ia03_007-706-064-076-55
#> 5 lha_ia03_007-708-089-076-55
#> 6 lha_ia03_007-711-064-076-55
```



## FN124 - Length Tallies

An api endpoint and  associated function for FN124 records has not been created yet, but will be coming soon.



## FN125 - Biological Data

Bioligical data is maintained in the FN125 table and can be accessed
using the `get_FN125` fucntion. FN125 records contain the biological
data collected from individual fish sampled in assessment projects
such as length, weight, sex, and maturity. For convience this end point
also returns data from child tables such as the 'preferred' age, and
lamprey wounds.  This function takes an optional filter list which can
be used to return records based on several different biologial
attributes (such as size, sex, or maturity), but also of the species,
or group code, or attributes of the effort, the sample, or the
project(s) that the samples were collected in.


```r



fn125 <- get_FN125(list(lake='ON', year=2012, spc='334',gear='GL'))
nrow(fn125)
#> [1] 230
head(fn125)
#>       id       prj_cd sam eff species grp fish flen tlen  rwt girth clipc sex
#> 1 903170 LOA_IA12_GL1   1 114     334  00    1  540   NA 1846    NA    NA   2
#> 2 903171 LOA_IA12_GL1   1 114     334  00    2  496   NA 1585    NA    NA   1
#> 3 903172 LOA_IA12_GL1   1 127     334  00    3  665   NA 4474    NA    NA   2
#> 4 903173 LOA_IA12_GL1   1 140     334  00    4  621   NA 3112    NA    NA   2
#> 5 903178 LOA_IA12_GL1   2 114     334  00    1  601   NA 2874    NA    NA   1
#> 6 903179 LOA_IA12_GL1   2 127     334  00    2  635   NA 3454    NA    NA   1
#>   mat gon noda nodc agest fate fishtags lamprey_marks
#> 1  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 2  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 3  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 4  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 5  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 6  NA  NA   NA   NA    2A   NA     NULL          NULL
#>                                        age_estimates             diet_data
#> 1    442129, 7, A61SM, NA, 5, TRUE, 9, 5, NA, NA, NA 50938, 1, 7999, 1, NA
#> 2    442128, 8, A61SM, NA, 7, TRUE, 9, 7, NA, NA, NA                  NULL
#> 3    442118, 9, A61SM, NA, 7, TRUE, 9, 7, NA, NA, NA 50939, 1, 7999, 3, NA
#> 4   442126, 10, A61SM, NA, 8, TRUE, 9, 8, NA, NA, NA 50940, 1, 7999, 3, NA
#> 5 442121, 15, A61SM, NA, 18, TRUE, 8, 18, NA, NA, NA                  NULL
#> 6 442120, 16, A61SM, NA, 18, TRUE, 8, 18, NA, NA, NA                  NULL
#>   comment5                        slug
#> 1       NA loa_ia12_gl1-1-114-334-00-1
#> 2       NA loa_ia12_gl1-1-114-334-00-2
#> 3       NA loa_ia12_gl1-1-127-334-00-3
#> 4       NA loa_ia12_gl1-1-140-334-00-4
#> 5       NA loa_ia12_gl1-2-114-334-00-1
#> 6       NA loa_ia12_gl1-2-127-334-00-2

filters <- list(lake='ER',
                protocol='TWL',
                spc_in=c('331', '334'),
                sidep_lte=20)
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 1000
head(fn125)
#>        id       prj_cd sam eff species grp fish flen tlen rwt girth clipc  sex
#> 1 1387792 LEA_IF98_001 250 001     331  01    1   58   62   2    NA    NA <NA>
#> 2 1387793 LEA_IF98_001 250 001     331  01   10   60   65   3    NA    NA <NA>
#> 3 1387794 LEA_IF98_001 250 001     331  01   11   49   51   1    NA    NA <NA>
#> 4 1387795 LEA_IF98_001 250 001     331  01   12   54   58   2    NA    NA <NA>
#> 5 1387796 LEA_IF98_001 250 001     331  01   13   46   48   1    NA    NA <NA>
#> 6 1387797 LEA_IF98_001 250 001     331  01   14   57   60   2    NA    NA <NA>
#>    mat  gon noda nodc agest fate fishtags lamprey_marks age_estimates diet_data
#> 1 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 2 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 3 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 4 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 5 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 6 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#>   comment5                           slug
#> 1           lea_if98_001-250-001-331-01-1
#> 2          lea_if98_001-250-001-331-01-10
#> 3          lea_if98_001-250-001-331-01-11
#> 4          lea_if98_001-250-001-331-01-12
#> 5          lea_if98_001-250-001-331-01-13
#> 6          lea_if98_001-250-001-331-01-14



filters <- list(lake='SU',
           prj_cd__in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 1000
head(fn125)
#>       id       prj_cd   sam eff species grp fish flen tlen rwt girth clipc sex
#> 1 813647 LSA_IA09_CIN 01002 051     091  00  128  235  259 132     0     0   1
#> 2 813913 LSA_IA09_CIN 01006 051     091  00  332  276  309 233     0     0   1
#> 3 814094 LSA_IA09_CIN 01008 051     091  00  574  215  241  96     0     0   9
#> 4 814095 LSA_IA09_CIN 01008 051     091  00  575  232  259 128     0     0   2
#> 5 814374 LSA_IA09_CIN 01012 051     091  00 2856  194  217  86     0     0   9
#> 6 814375 LSA_IA09_CIN 01012 051     091  00 2857  200  221  90     0     0   9
#>   mat gon noda nodc agest fate fishtags                lamprey_marks
#> 1   2  22   NA   NA    NA    K     NULL 502301, 1, NA, NA, 0, NA, NA
#> 2   1  10   NA   NA    NA    K     NULL 502132, 1, NA, NA, 0, NA, NA
#> 3   1  10   NA   NA    NA    K     NULL 502555, 1, NA, NA, 0, NA, NA
#> 4   1  10   NA   NA    NA    K     NULL 502556, 1, NA, NA, 0, NA, NA
#> 5   1  10   NA   NA    NA    K     NULL 502855, 1, NA, NA, 0, NA, NA
#> 6   1  10   NA   NA    NA    K     NULL 502856, 1, NA, NA, 0, NA, NA
#>                                                     age_estimates diet_data
#> 1                                                            NULL      NULL
#> 2                                                            NULL      NULL
#> 3                                                            NULL      NULL
#> 4 406077, 1, 211AT, O1, 3, TRUE, 9, 3, *, NA, Aquatech Consulting      NULL
#> 5 406176, 1, 211AT, O1, 2, TRUE, 9, 2, *, NA, Aquatech Consulting      NULL
#> 6 406177, 1, 211AT, O1, 2, TRUE, 9, 2, *, NA, Aquatech Consulting      NULL
#>   comment5                               slug
#> 1           lsa_ia09_cin-01002-051-091-00-128
#> 2           lsa_ia09_cin-01006-051-091-00-332
#> 3           lsa_ia09_cin-01008-051-091-00-574
#> 4           lsa_ia09_cin-01008-051-091-00-575
#> 5          lsa_ia09_cin-01012-051-091-00-2856
#> 6          lsa_ia09_cin-01012-051-091-00-2857



filters <- list(lake='HU', spc='076', grp='55')
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 428
head(fn125)
#>       id       prj_cd sam eff species grp  fish flen tlen  rwt girth clipc sex
#> 1 236576 LHA_IA03_002 219 064     076  55 00001  555  583 2640    NA  <NA>   1
#> 2 236577 LHA_IA03_002 219 064     076  55 00002  643  665 3297    NA  <NA>   2
#> 3 236535 LHA_IA03_002 219 089     076  55 00001  508  523 1953    NA  <NA>   1
#> 4 236536 LHA_IA03_002 219 089     076  55 00002  487  500 1680    NA  <NA>   1
#> 5 236541 LHA_IA03_002 219 114     076  55 00001  632  655 3729    NA  <NA>   2
#> 6 236990 LHA_IA03_007 706 064     076  55 00001  305  315  325    NA  <NA>   1
#>   mat gon noda nodc agest fate fishtags               lamprey_marks
#> 1   2  20   NA <NA>     1    K     NULL 172081, 1, NA, 0, 0, NA, NA
#> 2   2  20   NA <NA>     1    K     NULL 172082, 1, NA, 0, 0, NA, NA
#> 3   2  20   NA <NA>     1    K     NULL 172050, 1, NA, 0, 0, NA, NA
#> 4   1  10   NA <NA>     1    K     NULL 172051, 1, NA, 0, 0, NA, NA
#> 5   2  20   NA <NA>     1    K     NULL 172053, 1, NA, 0, 0, NA, NA
#> 6   1  10   NA <NA>     1    K     NULL 172329, 1, NA, 0, 0, NA, NA
#>                                       age_estimates
#> 1 186426, 125, 111WI, 21, 2, TRUE, NA, NA, NA, NA, 
#> 2 186427, 125, 111WI, 21, 2, TRUE, NA, NA, NA, NA, 
#> 3 186388, 125, 111WI, 21, 2, TRUE, NA, NA, NA, NA, 
#> 4 186389, 125, 111WI, 21, 2, TRUE, NA, NA, NA, NA, 
#> 5 186393, 125, 111WI, 21, 2, TRUE, NA, NA, NA, NA, 
#> 6 186797, 125, 111WI, 21, 3, TRUE, NA, NA, NA, NA, 
#>                                                              diet_data comment5
#> 1                                                                 NULL     <NA>
#> 2                                               42368, 1, F999, NA, NA     <NA>
#> 3                                                                 NULL     <NA>
#> 4 42369, 42370, 42371, 1, 2, 3, F999, F291, F280, 6, 1, 14, NA, NA, NA     <NA>
#> 5                         42372, 42373, 1, 2, F999, F280, 9, 1, NA, NA     <NA>
#> 6                                               42655, 1, 3000, 99, NA     <NA>
#>                                slug
#> 1 lha_ia03_002-219-064-076-55-00001
#> 2 lha_ia03_002-219-064-076-55-00002
#> 3 lha_ia03_002-219-089-076-55-00001
#> 4 lha_ia03_002-219-089-076-55-00002
#> 5 lha_ia03_002-219-114-076-55-00001
#> 6 lha_ia03_007-706-064-076-55-00001
```


## FN125Tags - Tags Recovered or Applied

FN125Tags records contain information about the individual tags
applied to or recovered from on a sampled fish and can be fetched from
the api using `get_FN125Tags()` function.  Historically, tag data was
stored in three related fields - TAGDOC, TAGSTAT and TAGID.  This
convention is fine as long a single biological sample only has a one
tag. In recent years, it has been come increasingly common for fish to
have multiple tags, or tag types associated with indiviudal sampling
events. FN125Tag accomodates those events.  This function takes an
optional filter list which can be used to return records based on
several different attributes of the tag (tag type, colour, placement,
agency, tag stat, and tag number) as well as, attributes of the
sampled fish such as the species, or group code, or attributes of the
effort, the sample, or the project(s) that the samples were collected
in.



```r

fn125Tags <- get_FN125Tags(list(lake='ON', year=2012, spc='334',gear='GL'))
nrow(fn125Tags)
#> NULL
head(fn125Tags)
#> list()

filters <- list(lake='ER',
                protocol='TWL',
                spc_in=c('331', '334'),
                sidep_lte=20)
fn125Tags <- get_FN125Tags(filters)
nrow(fn125Tags)
#> NULL
head(fn125Tags)
#> list()

filters <- list(lake='SU',
           prj_cd__in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn125Tags <- get_FN125Tags(filters)
nrow(fn125Tags)
#> NULL
head(fn125Tags)
#> list()


filters <- list(lake='HU', spc='076', grp='55')
fn125Tags <- get_FN125Tags(filters)
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1
```


## FN125Lamprey - Observed Lamprey Wounds


FN125Lam records contain information about the individual lamprey
wounds observed on a sampled fish and can be fetched using the
`get_Fn125Lamprey()` function.  Historically, lamprey wounds were
reported as a single field (XLAM) in the FN125 table.  In the early
2000 the Great Lakes fishery community agreed to capture lamprey
wounding data in a more consistent fashion across the basin using the
conventions described in Ebener etal 2006.  The FN125Lam table
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

fn125Lam <- get_FN125Lam(list(lake='ON', spc='081', gear='GL'))
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1



fn125Lam <- get_FN125Lam(list(lake='HU', spc='081', year=2012, gear='GL',
   lamijc_type=c('A1', 'A2', 'A3')))
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1


filters <- list(lake='ER',
                protocol='TWL',
                spc=c('331', '334'),
                year=2010,
                sidep_lte=20)
fn125Lam <- get_FN125Lam(filters)
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1


filters <- list(lake='SU',
           prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn125Lam <- get_FN125Lam(filters)
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1


filters <- list(lake='HU', spc='076', grp='55')
fn125Lam <- get_FN125Lam(filters)
nrow(fn125Tags)
#> [1] 161
head(fn125Tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 23894 LHA_IS02_014   1   1     076  55   55           1       A 12631  25012
#> 2 23895 LHA_IS02_014   1   1     076  55   55           1       A 12636  25012
#> 3 24184 LHA_IS02_014  10   1     076  55   55           1       A 14085  25012
#> 4 24185 LHA_IS02_014  10   1     076  55   55           1       A 14086  25012
#> 5 24186 LHA_IS02_014  10   1     076  55   55           1       A 14092  25012
#> 6 24187 LHA_IS02_014  10   1     076  55   55           1       A 14094  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                         slug
#> 1      NA        NA       NA          NA  lha_is02_014-1-1-076-55-1-1
#> 2      NA        NA       NA          NA  lha_is02_014-1-1-076-55-3-1
#> 3      NA        NA       NA          NA lha_is02_014-10-1-076-55-1-1
#> 4      NA        NA       NA          NA lha_is02_014-10-1-076-55-2-1
#> 5      NA        NA       NA          NA lha_is02_014-10-1-076-55-3-1
#> 6      NA        NA       NA          NA lha_is02_014-10-1-076-55-4-1
```


## Fn126 - Diet Data

The `get_Fn126()` function can be used to access the api endpoint to
for FN126 records. FN126 records contain the counts of identifiable
items in found in the stomachs of fish sampled and processed in the
field (the FN126 table does include more detailed analaysis that is
often conducted in the labratory).  The `get_FN126()` function takes
an optional filter list which can be used to return records based on
several different attributes of the diet item (taxon, taxon_like), as
well as, attributes of the sampled fish such as the species, or group
code, or attributes of the effort, the sample, or the project(s) that
the samples were collected in.


```r

fn126 <- get_FN126(list(lake='ON', year=2012, spc='334',gear='GL'))
nrow(fn126)
#> [1] 97
head(fn126)
#>      id       prj_cd sam eff species grp fish food taxon foodcnt comment6
#> 1 50938 LOA_IA12_GL1   1 114     334  00   00    1  7999       1       NA
#> 2 50939 LOA_IA12_GL1   1 127     334  00   00    1  7999       3       NA
#> 3 50940 LOA_IA12_GL1   1 140     334  00   00    1  7999       3       NA
#> 4 50941 LOA_IA12_GL1   2 127     334  00   00    1  7061       1       NA
#> 5 50942 LOA_IA12_GL1   2 127     334  00   00    2  7061       1       NA
#> 6 50943 LOA_IA12_GL1   2 127     334  00   00    1  7061       1       NA
#>                            slug
#> 1 loa_ia12_gl1-1-114-334-00-1-1
#> 2 loa_ia12_gl1-1-127-334-00-3-1
#> 3 loa_ia12_gl1-1-140-334-00-4-1
#> 4 loa_ia12_gl1-2-127-334-00-3-1
#> 5 loa_ia12_gl1-2-127-334-00-3-2
#> 6 loa_ia12_gl1-2-127-334-00-4-1

filters <- list(lake='ER',
                protocol='TWL',
                spc=c('331', '334'),
                sidep_lte=20)
fn126 <- get_FN126(filters)
nrow(fn126)
#> NULL
head(fn126)
#> list()

filters <- list(lake='SU',
           prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn126 <- get_FN126(filters)
nrow(fn126)
#> NULL
head(fn126)
#> list()

filters <- list(lake='HU', spc='076', grp='55')
fn126 <- get_FN126(filters)
nrow(fn126)
#> [1] 15
head(fn126)
#>      id       prj_cd sam eff species grp fish food taxon foodcnt comment6
#> 1 42369 LHA_IA03_002 219 089     076  55   55    1  F999       6       NA
#> 2 42370 LHA_IA03_002 219 089     076  55   55    2  F291       1       NA
#> 3 42371 LHA_IA03_002 219 089     076  55   55    3  F280      14       NA
#> 4 42372 LHA_IA03_002 219 114     076  55   55    1  F999       9       NA
#> 5 42373 LHA_IA03_002 219 114     076  55   55    2  F280       1       NA
#> 6 42368 LHA_IA03_002 219 064     076  55   55    1  F999      NA       NA
#>                                  slug
#> 1 lha_ia03_002-219-089-076-55-00002-1
#> 2 lha_ia03_002-219-089-076-55-00002-2
#> 3 lha_ia03_002-219-089-076-55-00002-3
#> 4 lha_ia03_002-219-114-076-55-00001-1
#> 5 lha_ia03_002-219-114-076-55-00001-2
#> 6 lha_ia03_002-219-064-076-55-00002-1
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

fn127 <- get_FN127(list(lake='ON', year=2012, spc='334', gear='GL'))
nrow(fn127)
#> [1] 229
head(fn127)
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 442129 LOA_IA12_GL1   1 114     334  00   00     7 A61SM    NA    5      TRUE
#> 2 442128 LOA_IA12_GL1   1 114     334  00   00     8 A61SM    NA    7      TRUE
#> 3 442118 LOA_IA12_GL1   1 127     334  00   00     9 A61SM    NA    7      TRUE
#> 4 442126 LOA_IA12_GL1   1 140     334  00   00    10 A61SM    NA    8      TRUE
#> 5 442121 LOA_IA12_GL1   2 114     334  00   00    15 A61SM    NA   18      TRUE
#> 6 442120 LOA_IA12_GL1   2 127     334  00   00    16 A61SM    NA   18      TRUE
#>   conf nca edge agest comment7                           slug
#> 1    9   5   NA    NA       NA  loa_ia12_gl1-1-114-334-00-1-7
#> 2    9   7   NA    NA       NA  loa_ia12_gl1-1-114-334-00-2-8
#> 3    9   7   NA    NA       NA  loa_ia12_gl1-1-127-334-00-3-9
#> 4    9   8   NA    NA       NA loa_ia12_gl1-1-140-334-00-4-10
#> 5    8  18   NA    NA       NA loa_ia12_gl1-2-114-334-00-1-15
#> 6    8  18   NA    NA       NA loa_ia12_gl1-2-127-334-00-2-16



filters <- list(lake='ER',
                protocol='TWL',
                spc=c('331', '334'),
                year=2010,
                sidep_lte=20)
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 790
head(fn127)
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 531977 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 2 531978 LEA_IF10_001 250 001     331  03   03   125    99    99    2      TRUE
#> 3 531979 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 4 531980 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 5 531981 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 6 531982 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#>   conf nca edge agest comment7                                 slug
#> 1   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5824-125
#> 2   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5825-125
#> 3   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5826-125
#> 4   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5827-125
#> 5   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5828-125
#> 6   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5830-125

filters <- list(lake='SU',
           prj_cd_in=c('LSA_IA15_CIN','LSA_IA17_CIN'),
           eff='051',
           spc='091')
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 58
head(fn127)
#>       id       prj_cd   sam eff species grp fish ageid agemt xagem agea
#> 1 423604 LSA_IA15_CIN 01003 051     091  00   00     1 A34PD    86    2
#> 2 423605 LSA_IA15_CIN 01003 051     091  00   00     1 A34PD    86    6
#> 3 423606 LSA_IA15_CIN 01003 051     091  00   00     1 A34PD    86    4
#> 4 423729 LSA_IA15_CIN 01005 051     091  00   00     1 A34PD    86    6
#> 5 423730 LSA_IA15_CIN 01005 051     091  00   00     1 A34PD    86    5
#> 6 423731 LSA_IA15_CIN 01005 051     091  00   00     1 A34PD    86    5
#>   preferred conf nca edge agest       comment7
#> 1      TRUE    6   2   ++    NA Paul Drombolis
#> 2      TRUE    5   6   ++    NA Paul Drombolis
#> 3      TRUE    5   4   ++    NA Paul Drombolis
#> 4      TRUE    6   6   ++    NA Paul Drombolis
#> 5      TRUE    6   5   ++    NA Paul Drombolis
#> 6      TRUE    6   5   ++    NA Paul Drombolis
#>                                    slug
#> 1 lsa_ia15_cin-01003-051-091-00-10217-1
#> 2 lsa_ia15_cin-01003-051-091-00-10218-1
#> 3 lsa_ia15_cin-01003-051-091-00-10219-1
#> 4 lsa_ia15_cin-01005-051-091-00-10403-1
#> 5 lsa_ia15_cin-01005-051-091-00-10404-1
#> 6 lsa_ia15_cin-01005-051-091-00-10405-1



filters <- list(lake='HU', spc='076', grp='55')
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 201
head(fn127)
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 186388 LHA_IA03_002 219 089     076  55   55   125 111WI    21    2      TRUE
#> 2 186389 LHA_IA03_002 219 089     076  55   55   125 111WI    21    2      TRUE
#> 3 186393 LHA_IA03_002 219 114     076  55   55   125 111WI    21    2      TRUE
#> 4 186426 LHA_IA03_002 219 064     076  55   55   125 111WI    21    2      TRUE
#> 5 186427 LHA_IA03_002 219 064     076  55   55   125 111WI    21    2      TRUE
#> 6 186797 LHA_IA03_007 706 064     076  55   55   125 111WI    21    3      TRUE
#>   conf nca edge agest comment7                                  slug
#> 1   NA  NA <NA>    NA          lha_ia03_002-219-089-076-55-00001-125
#> 2   NA  NA <NA>    NA          lha_ia03_002-219-089-076-55-00002-125
#> 3   NA  NA <NA>    NA          lha_ia03_002-219-114-076-55-00001-125
#> 4   NA  NA <NA>    NA          lha_ia03_002-219-064-076-55-00001-125
#> 5   NA  NA <NA>    NA          lha_ia03_002-219-064-076-55-00002-125
#> 6   NA  NA <NA>    NA          lha_ia03_007-706-064-076-55-00001-125
```
