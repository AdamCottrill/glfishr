
<!-- README.md is generated from README.Rmd. Please edit that file -->

# glfishr

*glfishr* contains a series of R functions that are intended to make it
easy to get fisheries assessment data from the fn\_portal api and into R
for subsequent analysis and reporting. Functions are named semantically
to reflect the FN-II table they fetch data from (e.g. `get_FN011()` for
project meta data, `get_FN121()` for net set/sample data and
`get_FN125()` for biological sample data). Most of the functions take an
optional filter\_list parameter that can be used to finely control which
records are returned. Care has been taken to ensure that the available
filters are consistent with FN-II field names whenever possible, and in
many cases, filters can be re-used across different tables (e.g. - if a
filter is passed to the `get_FN121()` function to find a subset of net
sets, that same filter can be applied to the `get_FN125()` function to
get the all of the biological samples collected in those net sets).

All of the filters are specified using the following convention:
`<field_name>__<expression>` - the field name, two underscores, and the
expression that is to be applied to the field to select the subset of
records. In most cases, the field name is a lowercase fishnet-II field
(prj\_cd, tlen, gon, ect.) and will be documented in the Data
Dictionary. The avaialble expressions are dependent on the type of data
in the field. In most cases, strings (such as prj\_nm, prj\_cd) can be
filtered with ‘like’, ‘not\_like’, and ‘endswith’. Fields with a well
defined number of choices (prj\_cd, spc, gon, sex, tagstat) can be
selected by passing a comma seperated list of choices to include or
exclude (`gon=10,20` or `gon__not=10,20`), as well as null or not\_null.
Numeric fields (sidep, flen, rwt etc) typically have the following
filter expressions available:

-   equal: `year=2010`
-   greater than or equal to: `tlen__gte=350`
-   greater than: `tlen__gt=350`
-   less than or equal to: `flen__lte=350`
-   less than: `flen__lt=350`
-   null: `clipc__null`
-   not null: `rwt__not_null`

Many of these filters are illustrated in the following examples. More
detailed information can be found in the technical documentation for the
fn\_portal API.

## Load glfishr

All of the functions in glfishr have been bundled up into an R-package
that can be installed and then loaded as needed:

``` r
library(glfishr)
```

## FN011 - Projects

Project meta data can be accessed using the `get_fn011()` function FN011
records contain the hi-level meta data about an OMNR netting project.
The FN011 records contain information like project code, project name,
project leader, start and end date, protocol, and the lake where the
project was conducted. This function takes an optional filter list which
can be used to select record based on several attributes of the project
such as project code, or part of the project code, lake, first year
(\*\*year\_\_gte**), last year (**year\_\_lte\*\*), protocol, etc.

``` r
fn011 <- get_FN011(list(lake = "ON", year__gte = 2012, year__lte = 2018))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 7
head(fn011)
#>     id year       prj_cd         slug
#> 1 1467 2018 LOA_IA18_GL1 loa_ia18_gl1
#> 2 1466 2017 LOA_IA17_GL1 loa_ia17_gl1
#> 3 1465 2016 LOA_IA16_GL1 loa_ia16_gl1
#> 4 1464 2015 LOA_IA15_GL1 loa_ia15_gl1
#> 5 1463 2014 LOA_IA14_GL1 loa_ia14_gl1
#> 6 1462 2013 LOA_IA13_GL1 loa_ia13_gl1
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

fn011 <- get_FN011(list(lake = "ER", protocol = "TWL"))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 33
head(fn011)
#>     id year       prj_cd         slug                   prj_nm  prj_date0
#> 1 1501 2019 LEA_IF19_001 lea_if19_001 Lake Erie Index Trawling 2019-08-12
#> 2 1500 2018 LEA_IF18_001 lea_if18_001 Lake Erie Index Trawling 2018-08-13
#> 3 1499 2017 LEA_IF17_001 lea_if17_001 Lake Erie Index Trawling 2017-08-14
#> 4 1498 2016 LEA_IF16_001 lea_if16_001 Lake Erie Index Trawling 2016-08-15
#> 5 1497 2015 LEA_IF15_001 lea_if15_001 Lake Erie Index Trawling 2015-08-10
#> 6 1496 2014 LEA_IF14_001 lea_if14_001 Lake Erie Index Trawling 2014-08-11
#>    prj_date1 protocol      source comment0 lake.lake_name lake.abbrev
#> 1 2019-08-29      TWL le_trawl_db               Lake Erie          ER
#> 2 2018-08-23      TWL le_trawl_db               Lake Erie          ER
#> 3 2017-08-24      TWL le_trawl_db               Lake Erie          ER
#> 4 2016-08-24      TWL le_trawl_db               Lake Erie          ER
#> 5 2015-08-19      TWL le_trawl_db               Lake Erie          ER
#> 6 2014-08-20      TWL le_trawl_db               Lake Erie          ER


filters <- list(lake = "SU", prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"))
fn011 <- get_FN011(filters)
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 2
head(fn011)
#>   id year       prj_cd         slug                             prj_nm
#> 1 79 2017 LSA_IA17_CIN lsa_ia17_cin Lake Superior Fish Community Index
#> 2 77 2015 LSA_IA15_CIN lsa_ia15_cin Lake Superior Fish Community Index
#>    prj_date0  prj_date1 protocol   source comment0 lake.lake_name lake.abbrev
#> 1 2017-06-06 2017-08-21     OSIA offshore       NA  Lake Superior          SU
#> 2 2015-08-02 2015-08-28     OSIA offshore       NA  Lake Superior          SU


fn011 <- get_FN011(list(lake = "HU", prj_cd__like = "_006"))
fn011 <- anonymize(fn011)
nrow(fn011)
#> [1] 35
head(fn011)
#>     id year       prj_cd         slug
#> 1 1340 2019 LHA_IA19_006 lha_ia19_006
#> 2 1336 2018 LHA_IA18_006 lha_ia18_006
#> 3 1329 2017 LHA_IA17_006 lha_ia17_006
#> 4 1322 2016 LHA_IA16_006 lha_ia16_006
#> 5 1317 2015 LHA_IA15_006 lha_ia15_006
#> 6 1312 2014 LHA_IA14_006 lha_ia14_006
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

Net sets can be retrieved using the `get_FN121()` function. The FN121
records contain information like set and lift date and time, effort
duration, gear, site depth and location. This function takes an optional
filter list which can be used to return record based on several
attributes of the net set including set and lift date and time, effort
duration, gear, site depth and location as well as attributes of the
projects they are associated with such project code, or part of the
project code, lake, first year, last year, protocol, etc.

``` r
fn121 <- get_FN121(list(lake = "ON", year = 2012))
nrow(fn121)
#> [1] 178
head(fn121)
#>      id       prj_cd sam     effdt0     effdt1 effdur   efftm0   efftm1 effst
#> 1 56106 LOA_IA12_GL1   1 2012-07-03 2012-07-04     22 07:15:00 05:50:00    NA
#> 2 56115 LOA_IA12_GL1  10 2012-07-03 2012-07-04     22 08:38:00 07:15:00    NA
#> 3 56205 LOA_IA12_GL1 100 2012-07-25 2012-07-26     18 10:31:00 04:52:00    NA
#> 4 56206 LOA_IA12_GL1 101 2012-07-25 2012-07-26     18 11:05:00 05:11:00    NA
#> 5 56207 LOA_IA12_GL1 102 2012-07-25 2012-07-26     18 11:05:00 05:11:00    NA
#> 6 56208 LOA_IA12_GL1 103 2012-07-30 2012-08-01     24 06:20:00 06:50:00    NA
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


fn121 <- get_FN121(list(lake = "ER", protocol = "TWL", year__gte = 2010, sidep__lte = 20))
nrow(fn121)
#> [1] 384
head(fn121)
#>      id       prj_cd sam     effdt0     effdt1    effdur   efftm0   efftm1
#> 1 59708 LEA_IF19_001 250 2019-08-12 2019-08-12 0.1666667 11:11:00 01:21:00
#> 2 59709 LEA_IF19_001 251 2019-08-12 2019-08-12 0.1666667 11:49:00 01:59:00
#> 3 59710 LEA_IF19_001 252 2019-08-12 2019-08-12 0.1666667 12:44:00 01:54:00
#> 4 59711 LEA_IF19_001 253 2019-08-12 2019-08-12 0.1666667 14:02:00 01:12:00
#> 5 59712 LEA_IF19_001 254 2019-08-12 2019-08-12 0.1666667 14:44:00 01:54:00
#> 6 59713 LEA_IF19_001 255 2019-08-13 2019-08-13 0.1666667 08:42:00 00:52:00
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


filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN")
)

fn121 <- get_FN121(filters)

nrow(fn121)
#> [1] 171
head(fn121)
#>     id       prj_cd   sam     effdt0     effdt1   effdur   efftm0   efftm1
#> 1 3883 LSA_IA17_CIN 01001 2017-06-06 2017-06-07 28.78333 07:55:00 12:42:00
#> 2 3884 LSA_IA17_CIN 01002 2017-06-06 2017-06-07 26.75000 09:15:00 12:00:00
#> 3 3885 LSA_IA17_CIN 01003 2017-06-06 2017-06-07 26.43333 08:38:00 11:04:00
#> 4 3886 LSA_IA17_CIN 01004 2017-06-07 2017-06-08 27.96667 08:18:00 12:16:00
#> 5 3887 LSA_IA17_CIN 01005 2017-06-07 2017-06-08 27.03333 08:37:00 11:39:00
#> 6 3888 LSA_IA17_CIN 01006 2017-06-07 2017-06-08 25.93333 08:59:00 10:55:00
#>   effst grtp   gr orient sidep site   dd_lat    dd_lon sitem      comment1
#> 1     1   GL GL10      1    22    S 48.34583 -89.13167    NA 0m waveheight
#> 2     1   GL GL10      1    36    M 48.30217 -89.17050    NA 0m waveheight
#> 3     1   GL GL10      1    14    S 48.27883 -89.06400    NA 0m waveheight
#> 4     1   GL GL10      1    13    S 48.24067 -89.23667    NA 0m waveheight
#> 5     1   GL GL10      1    19    S 48.25650 -89.21450    NA 0m waveheight
#> 6     1   GL GL10      1    33    M 48.24533 -89.17283    NA 0m waveheight
#>   secchi               slug grid.slug grid.grid
#> 1     NA lsa_ia17_cin-01001   su_0938       938
#> 2     NA lsa_ia17_cin-01002   su_0938       938
#> 3     NA lsa_ia17_cin-01003   su_1039      1039
#> 4     NA lsa_ia17_cin-01004   su_1137      1137
#> 5     NA lsa_ia17_cin-01005   su_1037      1037
#> 6     NA lsa_ia17_cin-01006   su_1137      1137


fn121 <- get_FN121(list(lake = "HU", prj_cd__endswith = "_003"))
nrow(fn121)
#> [1] 160
head(fn121)
#>      id       prj_cd sam     effdt0     effdt1 effdur   efftm0   efftm1 effst
#> 1 48340 LHA_IA18_003 301 2018-08-27 2018-08-28  23.15 11:13:00 10:22:00     1
#> 2 48341 LHA_IA18_003 302 2018-08-27 2018-08-28  23.05 11:58:00 11:01:00     1
#> 3 48342 LHA_IA18_003 303 2018-08-27 2018-08-28  23.56 12:25:00 11:59:00     1
#> 4 48343 LHA_IA18_003 304 2018-08-28 2018-08-29  22.36 13:00:00 11:22:00     1
#> 5 48344 LHA_IA18_003 305 2018-08-28 2018-08-29  21.33 13:21:00 10:41:00     1
#> 6 48345 LHA_IA18_003 306 2018-08-28 2018-08-29  20.48 13:37:00 10:06:00     1
#>   grtp   gr orient sidep site   dd_lat    dd_lon sitem    comment1 secchi
#> 1   GL GL21      1  32.4 2248 44.58082 -80.24860    NA    CJ TW RG     NA
#> 2   GL GL21      1  39.7 2248 44.53477 -80.16673    NA    CJ TW RG     NA
#> 3   GL GL21      1  36.0 2249 44.51710 -80.12047    NA    CJ TW RG     NA
#> 4   GL GL21      1  60.7 2248 44.58107 -80.21178    NA CJ TW CP RG     NA
#> 5   GL GL21      1  56.6 2248 44.57018 -80.18608    NA CJ TW CP RG     NA
#> 6   GL GL21      1  53.1 2248 44.56537 -80.16705    NA CJ TW CP RG     NA
#>               slug grid.slug grid.grid
#> 1 lha_ia18_003-301   hu_2248      2248
#> 2 lha_ia18_003-302   hu_2248      2248
#> 3 lha_ia18_003-303   hu_2249      2249
#> 4 lha_ia18_003-304   hu_2248      2248
#> 5 lha_ia18_003-305   hu_2248      2248
#> 6 lha_ia18_003-306   hu_2248      2248
```

## FN122 - Sample Efforts

Sample Efforts can be retrieved using the `get_fn122()` function. FN122
records contain information about efforts within a sample. For most gill
netting project an effort corresponds to a single panel of a particular
mesh size within a net set (gang). For trap netting and trawling
projects, there is usually just a single effort. The FN122 table
contains information about that particular effort such as gear depth,
gear temperature at set and lift, and effort distance. This function
takes an optional filter list which can be used to return records based
on several attributes of the effort including effort distance and depth
but also attributes of the projects or nets set they are associated with
such project code, lake, first year, last year, protocol, gear etc.

``` r

fn122 <- get_FN122(list(lake = "ON", year = 2012, gear = "GL", sidep__lte = 15))
nrow(fn122)
#> [1] 619
head(fn122)
#>       id       prj_cd sam eff effdst grdep grtem0 grtem1               slug
#> 1 289449 LOA_IA12_GL1   1 038    4.6   6.7   19.2     NA loa_ia12_gl1-1-038
#> 2 289450 LOA_IA12_GL1   1 051   15.2   6.7   19.2     NA loa_ia12_gl1-1-051
#> 3 289451 LOA_IA12_GL1   1 064   15.2   6.7   19.2     NA loa_ia12_gl1-1-064
#> 4 289452 LOA_IA12_GL1   1 076   15.2   6.7   19.2     NA loa_ia12_gl1-1-076
#> 5 289453 LOA_IA12_GL1   1 089   15.2   6.7   19.2     NA loa_ia12_gl1-1-089
#> 6 289454 LOA_IA12_GL1   1 102   15.2   6.7   19.2     NA loa_ia12_gl1-1-102


filters <- list(
  lake = "ER",
  protocol = "TWL",
  year__gte = 2010,
  sidep__lte = 20
)
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 384
head(fn122)
#>       id       prj_cd sam eff effdst grdep grtem0 grtem1                 slug
#> 1 314330 LEA_IF19_001 250 001    320  13.4   16.9   17.4 lea_if19_001-250-001
#> 2 314329 LEA_IF19_001 251 001    320  12.4   18.0   18.6 lea_if19_001-251-001
#> 3 314328 LEA_IF19_001 252 001    280  10.6   20.2   20.1 lea_if19_001-252-001
#> 4 314299 LEA_IF19_001 253 001    270   7.8   24.0   24.1 lea_if19_001-253-001
#> 5 314311 LEA_IF19_001 254 001    270   8.5   24.3   24.0 lea_if19_001-254-001
#> 6 314310 LEA_IF19_001 255 001    260  11.2   16.4   15.2 lea_if19_001-255-001


filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"), eff = "051"
)
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 171
head(fn122)
#>      id       prj_cd   sam eff effdst grdep grtem0 grtem1
#> 1 25221 LSA_IA17_CIN 01001 051  30.48    26     NA     NA
#> 2 25231 LSA_IA17_CIN 01002 051  30.48    36     NA     NA
#> 3 25241 LSA_IA17_CIN 01003 051  30.48    15     NA     NA
#> 4 25251 LSA_IA17_CIN 01004 051  30.48    13     NA     NA
#> 5 25261 LSA_IA17_CIN 01005 051  30.48    19     NA     NA
#> 6 25271 LSA_IA17_CIN 01006 051  30.48    37     NA     NA
#>                     slug
#> 1 lsa_ia17_cin-01001-051
#> 2 lsa_ia17_cin-01002-051
#> 3 lsa_ia17_cin-01003-051
#> 4 lsa_ia17_cin-01004-051
#> 5 lsa_ia17_cin-01005-051
#> 6 lsa_ia17_cin-01006-051



filters <- list(lake = "HU", prj_cd__like = "_007", eff = c("127", "140"))
fn122 <- get_FN122(filters)
nrow(fn122)
#> [1] 758
head(fn122)
#>       id       prj_cd sam eff effdst grdep grtem0 grtem1                 slug
#> 1 217649 LHA_IA18_007 701 127     50  16.5     NA     NA lha_ia18_007-701-127
#> 2 217768 LHA_IA18_007 701 140     50  16.2     NA     NA lha_ia18_007-701-140
#> 3 217650 LHA_IA18_007 702 127     50  11.6     NA     NA lha_ia18_007-702-127
#> 4 217769 LHA_IA18_007 702 140     50  11.6     NA     NA lha_ia18_007-702-140
#> 5 217651 LHA_IA18_007 703 127     50  11.4     NA     NA lha_ia18_007-703-127
#> 6 217770 LHA_IA18_007 703 140     50  12.2     NA     NA lha_ia18_007-703-140
```

## FN123 - Catch Counts

Catch counts by effort, species, and group are available using the
`get_FN123()` function. FN123 records contain information about catch
counts by species for each effort in a sample. For most gill netting
projects this corresponds to catches within a single panel of a
particular mesh size within a net set (gang). Group (GRP) is
occasionally included to further sub-divide the catch into user defined
groups that are usually specific to the project, but will always be
included and will be ‘00’ by default. This function takes an optional
filter list which can be used to return record based on several
attributes of the catch including species, or group code but also
attributes of the effort, the sample or the project(s) that the catches
were made in.

``` r

fn123 <- get_FN123(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
nrow(fn123)
#> [1] 101
head(fn123)
#>       id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 746079 LOA_IA12_GL1   1 114 334  00      2    NA      2      NA
#> 2 746080 LOA_IA12_GL1   1 127 334  00      1    NA      1      NA
#> 3 746081 LOA_IA12_GL1   1 140 334  00      1    NA      1      NA
#> 4 746130 LOA_IA12_GL1  10 140 334  00      1    NA      1      NA
#> 5 746604 LOA_IA12_GL1 102 127 334  00      1    NA      1      NA
#> 6 746611 LOA_IA12_GL1 103 140 334  00      1    NA      1      NA
#>                          slug
#> 1   loa_ia12_gl1-1-114-334-00
#> 2   loa_ia12_gl1-1-127-334-00
#> 3   loa_ia12_gl1-1-140-334-00
#> 4  loa_ia12_gl1-10-140-334-00
#> 5 loa_ia12_gl1-102-127-334-00
#> 6 loa_ia12_gl1-103-140-334-00

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
#>       id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 793328 LEA_IF10_001 250 001 331  01      4    NA      4        
#> 2 793333 LEA_IF10_001 250 001 331  03     22    NA     22        
#> 3 793222 LEA_IF10_001 250 001 334  01      1    NA      1        
#> 4 793343 LEA_IF10_001 251 001 331  01      2    NA      2        
#> 5 793337 LEA_IF10_001 251 001 331  03     25    NA     25        
#> 6 793342 LEA_IF10_001 251 001 334  01      1    NA      1        
#>                          slug
#> 1 lea_if10_001-250-001-331-01
#> 2 lea_if10_001-250-001-331-03
#> 3 lea_if10_001-250-001-334-01
#> 4 lea_if10_001-251-001-331-01
#> 5 lea_if10_001-251-001-331-03
#> 6 lea_if10_001-251-001-334-01


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
#>      id       prj_cd   sam eff spc grp catcnt catwt biocnt comment
#> 1 49401 LSA_IA17_CIN 01001 051 091  00      1    NA      1      NA
#> 2 49446 LSA_IA17_CIN 01004 051 091  00      1    NA      1      NA
#> 3 49470 LSA_IA17_CIN 01005 051 091  00      1    NA      1      NA
#> 4 49512 LSA_IA17_CIN 01007 051 091  00      1    NA      1      NA
#> 5 49549 LSA_IA17_CIN 01010 051 091  00      8    NA      8      NA
#> 6 49590 LSA_IA17_CIN 01015 051 091  00      1    NA      1      NA
#>                            slug
#> 1 lsa_ia17_cin-01001-051-091-00
#> 2 lsa_ia17_cin-01004-051-091-00
#> 3 lsa_ia17_cin-01005-051-091-00
#> 4 lsa_ia17_cin-01007-051-091-00
#> 5 lsa_ia17_cin-01010-051-091-00
#> 6 lsa_ia17_cin-01015-051-091-00


filters <- list(lake = "HU", spc = "076", grp = "55")
fn123 <- get_FN123(filters)
nrow(fn123)
#> [1] 220
head(fn123)
#>       id       prj_cd sam eff spc grp catcnt catwt biocnt comment
#> 1 419244 LHA_IA19_802 122 051 076  55      1    NA      1    <NA>
#> 2 419247 LHA_IA19_802 122 076 076  55      1    NA      1    <NA>
#> 3 419272 LHA_IA19_802 161 032 076  55      1    NA      1    <NA>
#> 4 419405 LHA_IA19_802  41 114 076  55      1    NA      1    <NA>
#> 5 419408 LHA_IA19_802  42 064 076  55      1    NA      1    <NA>
#> 6 570629 LHA_IA19_077 701 089 076  55      2     0      2        
#>                          slug
#> 1 lha_ia19_802-122-051-076-55
#> 2 lha_ia19_802-122-076-076-55
#> 3 lha_ia19_802-161-032-076-55
#> 4  lha_ia19_802-41-114-076-55
#> 5  lha_ia19_802-42-064-076-55
#> 6 lha_ia19_077-701-089-076-55
```

## FN124 - Length Tallies

An api endpoint and associated function for FN124 records has not been
created yet, but will be coming soon.

## FN125 - Biological Data

Biological data is maintained in the FN125 table and can be accessed
using the `get_FN125` function. FN125 records contain the biological
data collected from individual fish sampled in assessment projects such
as length, weight, sex, and maturity. For convenience this end point
also returns data from child tables such as the ‘preferred’ age, and
lamprey wounds. This function takes an optional filter list which can be
used to return records based on several different biological attributes
(such as size, sex, or maturity), but also of the species, or group
code, or attributes of the effort, the sample, or the project(s) that
the samples were collected in.

``` r
fn125 <- get_FN125(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
nrow(fn125)
#> [1] 230
head(fn125)
#>        id       prj_cd sam eff species grp fish flen tlen  rwt girth clipc sex
#> 1 1560987 LOA_IA12_GL1   1 114     334  00    1  540   NA 1846    NA    NA   2
#> 2 1560988 LOA_IA12_GL1   1 114     334  00    2  496   NA 1585    NA    NA   1
#> 3 1560989 LOA_IA12_GL1   1 127     334  00    3  665   NA 4474    NA    NA   2
#> 4 1560990 LOA_IA12_GL1   1 140     334  00    4  621   NA 3112    NA    NA   2
#> 5 1561027 LOA_IA12_GL1  10 140     334  00    1  708   NA 5539    NA    NA   2
#> 6 1561916 LOA_IA12_GL1 102 127     334  00    1  576   NA 2483    NA    NA   1
#>   mat gon noda nodc agest fate fishtags lamprey_marks
#> 1  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 2  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 3  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 4  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 5  NA  NA   NA   NA    2A   NA     NULL          NULL
#> 6  NA  NA   NA   NA    2A   NA     NULL          NULL
#>                                         age_estimates              diet_data
#> 1     740335, 7, A61SM, NA, 5, TRUE, 9, 5, NA, NA, NA 159234, 1, 7999, 1, NA
#> 2     740334, 8, A61SM, NA, 7, TRUE, 9, 7, NA, NA, NA                   NULL
#> 3     740324, 9, A61SM, NA, 7, TRUE, 9, 7, NA, NA, NA 159235, 1, 7999, 3, NA
#> 4    740332, 10, A61SM, NA, 8, TRUE, 9, 8, NA, NA, NA 159236, 1, 7999, 3, NA
#> 5                                                NULL                   NULL
#> 6 740710, 362, A61SM, NA, 11, TRUE, 9, 11, NA, NA, NA 159409, 1, 7999, 2, NA
#>   comment5                          slug
#> 1       NA   loa_ia12_gl1-1-114-334-00-1
#> 2       NA   loa_ia12_gl1-1-114-334-00-2
#> 3       NA   loa_ia12_gl1-1-127-334-00-3
#> 4       NA   loa_ia12_gl1-1-140-334-00-4
#> 5       NA  loa_ia12_gl1-10-140-334-00-1
#> 6       NA loa_ia12_gl1-102-127-334-00-1

filters <- list(
  lake = "ER",
  year = "2019",
  protocol = "TWL",
  spc_in = c("331", "334"),
  sidep__lte = 10
)
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 862
head(fn125)
#>        id       prj_cd sam eff species grp fish flen tlen rwt girth clipc  sex
#> 1 1613248 LEA_IF19_001 253 001     331  01    1   50   58   2    NA    NA <NA>
#> 2 1613249 LEA_IF19_001 253 001     331  01   10   54   57   2    NA    NA <NA>
#> 3 1613250 LEA_IF19_001 253 001     331  01   11   42   44   1    NA    NA <NA>
#> 4 1613251 LEA_IF19_001 253 001     331  01   12   61   64   3    NA    NA <NA>
#> 5 1613252 LEA_IF19_001 253 001     331  01   13   62   66   3    NA    NA <NA>
#> 6 1613253 LEA_IF19_001 253 001     331  01   14   60   64   2    NA    NA <NA>
#>    mat  gon noda nodc agest fate fishtags lamprey_marks age_estimates diet_data
#> 1 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 2 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 3 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 4 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 5 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#> 6 <NA> <NA>   NA   NA    NA    K     NULL          NULL          NULL      NULL
#>   comment5                           slug
#> 1           lea_if19_001-253-001-331-01-1
#> 2          lea_if19_001-253-001-331-01-10
#> 3          lea_if19_001-253-001-331-01-11
#> 4          lea_if19_001-253-001-331-01-12
#> 5          lea_if19_001-253-001-331-01-13
#> 6          lea_if19_001-253-001-331-01-14

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
#>      id       prj_cd   sam eff species grp  fish flen tlen rwt girth clipc sex
#> 1 86108 LSA_IA17_CIN 01001 051     091  00 10042  237  264 130     0     1   1
#> 2 86185 LSA_IA17_CIN 01004 051     091  00 10245  276  307 205     0     0   1
#> 3 86255 LSA_IA17_CIN 01005 051     091  00 10160  236  265 130     0     0   2
#> 4 86320 LSA_IA17_CIN 01007 051     091  00 10109  255  287 170     0     0   1
#> 5 86373 LSA_IA17_CIN 01010 051     091  00 10289  298  332 335     0     0   1
#> 6 86374 LSA_IA17_CIN 01010 051     091  00 10290  323  360 425     0     0   1
#>   mat gon noda nodc agest fate fishtags               lamprey_marks
#> 1   2  23   NA   NA    NA    K     NULL 59463, 1, NA, NA, 0, NA, NA
#> 2   1  10   NA   NA    NA    K     NULL 59547, 1, NA, NA, 0, NA, NA
#> 3   1  10   NA   NA    NA    K     NULL 59617, 1, NA, NA, 0, NA, NA
#> 4   1  10   NA   NA    NA    K     NULL 59685, 1, NA, NA, 0, NA, NA
#> 5   1  10   NA   NA    NA    K     NULL 59738, 1, NA, NA, 0, NA, NA
#> 6   1  10   NA   NA    NA    K     NULL 59739, 1, NA, NA, 0, NA, NA
#>                                               age_estimates diet_data comment5
#> 1                                                      NULL      NULL       NA
#> 2 27208, 1, A34PD, 86, 3, TRUE, 5, 3, +, NA, Paul Drombolis      NULL       NA
#> 3 27267, 1, A34PD, 86, 2, TRUE, 4, 2, +, NA, Paul Drombolis      NULL       NA
#> 4 27320, 1, A34PD, 86, 3, TRUE, 4, 3, +, NA, Paul Drombolis      NULL       NA
#> 5 27366, 1, A34PD, 86, 4, TRUE, 5, 4, +, NA, Paul Drombolis      NULL       NA
#> 6 27367, 1, A34PD, 86, 4, TRUE, 5, 4, +, NA, Paul Drombolis      NULL       NA
#>                                  slug
#> 1 lsa_ia17_cin-01001-051-091-00-10042
#> 2 lsa_ia17_cin-01004-051-091-00-10245
#> 3 lsa_ia17_cin-01005-051-091-00-10160
#> 4 lsa_ia17_cin-01007-051-091-00-10109
#> 5 lsa_ia17_cin-01010-051-091-00-10289
#> 6 lsa_ia17_cin-01010-051-091-00-10290



filters <- list(lake = "HU", spc = "076", grp = "55")
fn125 <- get_FN125(filters)
nrow(fn125)
#> [1] 428
head(fn125)
#>        id       prj_cd sam eff species grp fish flen tlen  rwt girth clipc sex
#> 1  853256 LHA_IA19_802 122 051     076  55    4  492  513 1500    NA     0   2
#> 2  853259 LHA_IA19_802 122 076     076  55    5  470  490 1575    NA     1   2
#> 3  853285 LHA_IA19_802 161 032     076  55    1  475  494 1400    NA     0   2
#> 4  853517 LHA_IA19_802  41 114     076  55    3  468  489 1325    NA  <NA>   2
#> 5  853520 LHA_IA19_802  42 064     076  55    1  438  455 1100    NA  <NA>   1
#> 6 1160285 LHA_IA19_077 701 089     076  55    4  420  429  881    NA  <NA>   1
#>   mat gon noda nodc agest fate fishtags                lamprey_marks
#> 1   2  20   NA <NA>     1 <NA>     NULL 573830, 1, NA, NA, 0, NA, NA
#> 2   2  20   NA <NA>     1 <NA>     NULL 573831, 1, NA, NA, 0, NA, NA
#> 3   2  20   NA <NA>     1 <NA>     NULL 574056, 1, NA, NA, 0, NA, NA
#> 4   2  20   NA <NA>     1 <NA>     NULL 574897, 1, NA, NA, 0, NA, NA
#> 5   2  20   NA <NA>     1 <NA>     NULL 574902, 1, NA, NA, 0, NA, NA
#> 6   1  10   NA <NA>     1    K     NULL 808382, 1, NA, NA, 0, NA, NA
#>   age_estimates diet_data comment5                          slug
#> 1          NULL      NULL     <NA> lha_ia19_802-122-051-076-55-4
#> 2          NULL      NULL     <NA> lha_ia19_802-122-076-076-55-5
#> 3          NULL      NULL     <NA> lha_ia19_802-161-032-076-55-1
#> 4          NULL      NULL     <NA>  lha_ia19_802-41-114-076-55-3
#> 5          NULL      NULL     <NA>  lha_ia19_802-42-064-076-55-1
#> 6          NULL      NULL     <NA> lha_ia19_077-701-089-076-55-4
```

## FN125Tags - Tags Recovered or Applied

FN125Tags records contain information about the individual tags applied
to or recovered from on a sampled fish and can be fetched from the api
using `get_FN125Tags()` function. Historically, tag data was stored in
three related fields - TAGDOC, TAGSTAT and TAGID. This convention is
fine as long a single biological sample only has a one tag. In recent
years, it has been come increasingly common for fish to have multiple
tags, or tag types associated with individual sampling events. FN125Tag
accommodates those events. This function takes an optional filter list
which can be used to return records based on several different
attributes of the tag (tag type, colour, placement, agency, tag stat,
and tag number) as well as, attributes of the sampled fish such as the
species, or group code, or attributes of the effort, the sample, or the
project(s) that the samples were collected in.

``` r

fn125_tags <- get_FN125Tags(list(
  lake = "ON",
  year = 2019,
  spc = "081",
  gear = "GL"
))
nrow(fn125_tags)
#> [1] 186
head(fn125_tags)
#>       id       prj_cd sam eff species grp fish fish_tag_id tagstat  tagid
#> 1 118612 LOA_IA19_GL1  11 127     081  00   00           1      NA 600214
#> 2 118619 LOA_IA19_GL1 115 089     081  00   00           1      NA 600134
#> 3 118620 LOA_IA19_GL1 118 140     081  00   00           1      NA 640584
#> 4 118621 LOA_IA19_GL1 119 102     081  00   00           1      NA 640445
#> 5 118622 LOA_IA19_GL1 119 140     081  00   00           1      NA 600236
#> 6 118623 LOA_IA19_GL1 120 102     081  00   00           1      NA 640716
#>   tagdoc xcwtseq xtaginckd xtag_chk comment_tag                            slug
#> 1  67026      NA        NA       NA          NA loa_ia19_gl1-11-127-081-00-14-1
#> 2  67026      NA        NA       NA          NA loa_ia19_gl1-115-089-081-00-1-1
#> 3  67026      NA        NA       NA          NA loa_ia19_gl1-118-140-081-00-1-1
#> 4  67026      NA        NA       NA          NA loa_ia19_gl1-119-102-081-00-1-1
#> 5  67026      NA        NA       NA          NA loa_ia19_gl1-119-140-081-00-2-1
#> 6  67026      NA        NA       NA          NA loa_ia19_gl1-120-102-081-00-1-1


fn125_tags <- get_FN125Tags(list(lake = "SU"))
nrow(fn125_tags)
#> [1] 39
head(fn125_tags)
#>     id       prj_cd   sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 1633 LSA_IA17_CIN 01029 102     131  00   00           1       C  9050  23014
#> 2 1634 LSA_IA17_CIN 01029 114     131  00   00           1       C 13323  23019
#> 3 1635 LSA_IA17_CIN 01029 114     131  00   00           2       C 13324  23019
#> 4 1632 LSA_IA16_CIN 01122 140     031  00   00           1       C  9987  29262
#> 5 1602 LSA_IA14_CIN 01096 153     031  00   00           1       A 25529  23019
#> 6 1603 LSA_IA14_CIN 01096 153     031  00   00           1       A 25530  23019
#>   xcwtseq xtaginckd xtag_chk comment_tag                                  slug
#> 1      NA        NA       NA          NA lsa_ia17_cin-01029-102-131-00-11083-1
#> 2      NA        NA       NA          NA lsa_ia17_cin-01029-114-131-00-11082-1
#> 3      NA        NA       NA          NA lsa_ia17_cin-01029-114-131-00-11082-2
#> 4      NA        NA       NA          NA lsa_ia16_cin-01122-140-031-00-13172-1
#> 5      NA        NA       NA          NA lsa_ia14_cin-01096-153-031-00-12899-1
#> 6      NA        NA       NA          NA lsa_ia14_cin-01096-153-031-00-12900-1


filters <- list(lake = "HU", spc = "076", grp = "55")
fn125_tags <- get_FN125Tags(filters)
nrow(fn125_tags)
#> [1] 161
head(fn125_tags)
#>      id       prj_cd sam eff species grp fish fish_tag_id tagstat tagid tagdoc
#> 1 80204 LHA_IA15_F14  10 001     076  55   55           1       A 28816  25012
#> 2 80213 LHA_IA15_F14  26 001     076  55   55           1       A 28839  25012
#> 3 80188 LHA_IA15_F14   8 001     076  55   55           1       A 28813  25012
#> 4 80202 LHA_IA15_F14   9 001     076  55   55           1       A 28814  25012
#> 5 72356 LHA_IS05_014   4   1     076  55   55           1       A 20099  25012
#> 6 72381 LHA_IS05_014   7   1     076  55   55           1       A 20236  25012
#>   xcwtseq xtaginckd xtag_chk comment_tag                           slug
#> 1      NA        NA       NA          NA lha_ia15_f14-10-001-076-55-1-1
#> 2      NA        NA       NA          NA lha_ia15_f14-26-001-076-55-1-1
#> 3      NA        NA       NA          NA  lha_ia15_f14-8-001-076-55-1-1
#> 4      NA        NA       NA          NA  lha_ia15_f14-9-001-076-55-1-1
#> 5      NA        NA       NA          NA    lha_is05_014-4-1-076-55-1-1
#> 6      NA        NA       NA          NA    lha_is05_014-7-1-076-55-1-1
```

## FN125Lamprey - Observed Lamprey Wounds

FN125Lam records contain information about the individual lamprey wounds
observed on a sampled fish and can be fetched using the
`get_Fn125Lamprey()` function. Historically, lamprey wounds were
reported as a single field (XLAM) in the FN125 table. In the early 2000
the Great Lakes fishery community agreed to capture lamprey wounding
data in a more consistent fashion across the basin using the conventions
described in Ebener et al 2006. The FN125Lam table captures data from
individual lamprey wounds collected using those conventions. A sampled
fish with no observed wound will have a single record in this table
(with lamijc value of 0), while fish with lamprey wounds, will have one
record for every observed wound. This function takes an optional filter
list which can be used to return records based on several different
attributes of the wound (wound type, degree of healing, and wound size)
as well as, attributes of the sampled fish such as the species, or group
code, or attributes of the effort, the sample, or the project(s) that
the samples were collected in.

``` r
fn125_lam <- get_FN125Lam(list(
  lake = "ON",
  spc = "081",
  year = "2015",
  gear = "GL"
))
nrow(fn125_lam)
#> [1] 48
head(fn125_lam)
#>         prj_cd sam eff species grp fish     id lamid xlam lamijc lamijc_type
#> 1 LOA_IA15_GL1 102 038     081  00   00 818115     1   NA     NA           0
#> 2 LOA_IA15_GL1 102 102     081  00   00 818116     1   NA     NA           0
#> 3 LOA_IA15_GL1 102 114     081  00   00 818117     1   NA     NA           0
#> 4 LOA_IA15_GL1 103 114     081  00   00 818118     1   NA     NA           0
#> 5 LOA_IA15_GL1 116 114     081  00   00 818119     1   NA     NA           0
#> 6 LOA_IA15_GL1 119 089     081  00   00 818120     1   NA     NA           0
#>   lamijc_size comment_lam                            slug
#> 1          NA          NA loa_ia15_gl1-102-038-081-00-1-1
#> 2          NA          NA loa_ia15_gl1-102-102-081-00-5-1
#> 3          NA          NA loa_ia15_gl1-102-114-081-00-7-1
#> 4          NA          NA loa_ia15_gl1-103-114-081-00-2-1
#> 5          NA          NA loa_ia15_gl1-116-114-081-00-2-1
#> 6          NA          NA loa_ia15_gl1-119-089-081-00-1-1


fn125_lam <- get_FN125Lam(list(
  lake = "SU", spc = "081", year__gte = 2015,
  lamijc_type = c("A1", "A2", "A3")
))
nrow(fn125_lam)
#> [1] 352
head(fn125_lam)
#>         prj_cd   sam eff species grp fish    id lamid xlam lamijc lamijc_type
#> 1 LSA_IA15_CIN 01009 076     081  01   01 54353     1   NA     NA          A3
#> 2 LSA_IA15_CIN 01014 064     081  01   01 54603     1   NA     NA          A1
#> 3 LSA_IA15_CIN 01014 102     081  01   01 54614     1   NA     NA          A1
#> 4 LSA_IA15_CIN 01017 089     081  01   01 54719     1   NA     NA          A1
#> 5 LSA_IA15_CIN 01017 089     081  01   01 54720     2   NA     NA          A2
#> 6 LSA_IA15_CIN 01017 089     081  01   01 54721     3   NA     NA          A3
#>   lamijc_size comment_lam                                  slug
#> 1          NA        <NA> lsa_ia15_cin-01009-076-081-01-10639-1
#> 2          NA        <NA> lsa_ia15_cin-01014-064-081-01-10784-1
#> 3          NA        <NA> lsa_ia15_cin-01014-102-081-01-10771-1
#> 4          NA        <NA> lsa_ia15_cin-01017-089-081-01-10916-1
#> 5          NA        <NA> lsa_ia15_cin-01017-089-081-01-10916-2
#> 6          NA        <NA> lsa_ia15_cin-01017-089-081-01-10916-3



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
#>         prj_cd   sam eff species grp fish    id lamid xlam lamijc lamijc_type
#> 1 LSA_IA15_CIN 01003 051     091  00   00 53978     1   NA     NA           0
#> 2 LSA_IA15_CIN 01003 051     091  00   00 53979     1   NA     NA           0
#> 3 LSA_IA15_CIN 01003 051     091  00   00 53980     1   NA     NA           0
#> 4 LSA_IA15_CIN 01005 051     091  00   00 54145     1   NA     NA           0
#> 5 LSA_IA15_CIN 01005 051     091  00   00 54146     1   NA     NA           0
#> 6 LSA_IA15_CIN 01005 051     091  00   00 54147     1   NA     NA           0
#>   lamijc_size comment_lam                                  slug
#> 1          NA          NA lsa_ia15_cin-01003-051-091-00-10217-1
#> 2          NA          NA lsa_ia15_cin-01003-051-091-00-10218-1
#> 3          NA          NA lsa_ia15_cin-01003-051-091-00-10219-1
#> 4          NA          NA lsa_ia15_cin-01005-051-091-00-10403-1
#> 5          NA          NA lsa_ia15_cin-01005-051-091-00-10404-1
#> 6          NA          NA lsa_ia15_cin-01005-051-091-00-10405-1


filters <- list(lake = "HU", spc = "076", grp = "55")
fn125_lam <- get_FN125Lam(filters)
nrow(fn125_lam)
#> [1] 348
head(fn125_lam)
#>         prj_cd sam eff species grp fish     id lamid xlam lamijc lamijc_type
#> 1 LHA_IA03_002 219 064     076  55   55 741455     1 <NA>     NA           0
#> 2 LHA_IA03_002 219 064     076  55   55 741456     1 <NA>     NA           0
#> 3 LHA_IA03_002 219 089     076  55   55 741424     1 <NA>     NA           0
#> 4 LHA_IA03_002 219 089     076  55   55 741425     1 <NA>     NA           0
#> 5 LHA_IA03_002 219 114     076  55   55 741427     1 <NA>     NA           0
#> 6 LHA_IA03_007 706 064     076  55   55 741703     1 <NA>     NA           0
#>   lamijc_size comment_lam                                slug
#> 1          NA          NA lha_ia03_002-219-064-076-55-00001-1
#> 2          NA          NA lha_ia03_002-219-064-076-55-00002-1
#> 3          NA          NA lha_ia03_002-219-089-076-55-00001-1
#> 4          NA          NA lha_ia03_002-219-089-076-55-00002-1
#> 5          NA          NA lha_ia03_002-219-114-076-55-00001-1
#> 6          NA          NA lha_ia03_007-706-064-076-55-00001-1
```

## Fn126 - Diet Data

The `get_Fn126()` function can be used to access the api endpoint to for
FN126 records. FN126 records contain the counts of identifiable items in
found in the stomachs of fish sampled and processed in the field (the
FN126 table does include more detailed analysis that is often conducted
in the laboratory). The `get_FN126()` function takes an optional filter
list which can be used to return records based on several different
attributes of the diet item (taxon, taxon\_\_like), as well as,
attributes of the sampled fish such as the species, or group code, or
attributes of the effort, the sample, or the project(s) that the samples
were collected in.

``` r
fn126 <- get_FN126(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
nrow(fn126)
#> [1] 97
head(fn126)
#>       id       prj_cd sam eff species grp fish food taxon foodcnt comment6
#> 1 159234 LOA_IA12_GL1   1 114     334  00   00    1  7999       1       NA
#> 2 159235 LOA_IA12_GL1   1 127     334  00   00    1  7999       3       NA
#> 3 159236 LOA_IA12_GL1   1 140     334  00   00    1  7999       3       NA
#> 4 159409 LOA_IA12_GL1 102 127     334  00   00    1  7999       2       NA
#> 5 159411 LOA_IA12_GL1 103 140     334  00   00    1  7999       1       NA
#> 6 159470 LOA_IA12_GL1 113 038     334  00   00    1  7999       2       NA
#>                              slug
#> 1   loa_ia12_gl1-1-114-334-00-1-1
#> 2   loa_ia12_gl1-1-127-334-00-3-1
#> 3   loa_ia12_gl1-1-140-334-00-4-1
#> 4 loa_ia12_gl1-102-127-334-00-1-1
#> 5 loa_ia12_gl1-103-140-334-00-1-1
#> 6 loa_ia12_gl1-113-038-334-00-1-1



filters <- list(lake = "SU", prj_cd = c("LSA_IA12_CIN", "LSA_IA17_CIN"))
fn126 <- get_FN126(filters)
nrow(fn126)
#> [1] 331
head(fn126)
#>    id       prj_cd   sam eff species grp fish food taxon foodcnt       comment6
#> 1 324 LSA_IA17_CIN 01004 114     081  01   01    1  F121      10           <NA>
#> 2 325 LSA_IA17_CIN 01005 102     081  01   01    1  F121       3           <NA>
#> 3 326 LSA_IA17_CIN 01005 114     081  01   01    1  F121       7           <NA>
#> 4 327 LSA_IA17_CIN 01005 140     081  01   01    1  F121       6           <NA>
#> 5 328 LSA_IA17_CIN 01006 064     271  00   00    1  F121      NA unknown number
#> 6 329 LSA_IA17_CIN 01006 089     271  00   00    1  F121       5           <NA>
#>                                    slug
#> 1 lsa_ia17_cin-01004-114-081-01-10188-1
#> 2 lsa_ia17_cin-01005-102-081-01-10139-1
#> 3 lsa_ia17_cin-01005-114-081-01-10144-1
#> 4 lsa_ia17_cin-01005-140-081-01-10174-1
#> 5 lsa_ia17_cin-01006-064-271-00-10126-1
#> 6 lsa_ia17_cin-01006-089-271-00-10124-1

filters <- list(lake = "HU", spc = "076", grp = "55")
fn126 <- get_FN126(filters)
nrow(fn126)
#> [1] 15
head(fn126)
#>      id       prj_cd sam eff species grp fish food taxon foodcnt comment6
#> 1 89137 LHA_IA13_007 714 076     076  55   55    1  F121       5       NA
#> 2 88487 LHA_IA06_002 225 114     076  55   55    1  F999       9       NA
#> 3 87970 LHA_IA04_002 205 051     076  55   55    1  2540      18       NA
#> 4 87582 LHA_IA03_002 219 064     076  55   55    1  F999      NA       NA
#> 5 87583 LHA_IA03_002 219 089     076  55   55    1  F999       6       NA
#> 6 87584 LHA_IA03_002 219 089     076  55   55    2  F291       1       NA
#>                                  slug
#> 1     lha_ia13_007-714-076-076-55-1-1
#> 2     lha_ia06_002-225-114-076-55-2-1
#> 3 lha_ia04_002-205-051-076-55-00001-1
#> 4 lha_ia03_002-219-064-076-55-00002-1
#> 5 lha_ia03_002-219-089-076-55-00002-1
#> 6 lha_ia03_002-219-089-076-55-00002-2
```

## Fn127 - Age Estimates

The `get_fn127()` function can be used to access the api endpoint to for
FN127 records which contain age estimate/interpretations. This function
takes an optional filter list which can be used to return records based
on several different attributes of the age estimate such as the assigned
age, the aging structure, confidence, number of complete annuli and edge
code, or whether or not it was identified as the ‘preferred’ age for
this fish. Additionally, filters can be applied to select age estimates
based on attributes of the sampled fish such as the species, or group
code, or attributes of the effort, the sample, or the project(s) that
the samples were collected in.

``` r
fn127 <- get_FN127(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
nrow(fn127)
#> [1] 229
head(fn127)
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 740335 LOA_IA12_GL1   1 114     334  00   00     7 A61SM    NA    5      TRUE
#> 2 740334 LOA_IA12_GL1   1 114     334  00   00     8 A61SM    NA    7      TRUE
#> 3 740324 LOA_IA12_GL1   1 127     334  00   00     9 A61SM    NA    7      TRUE
#> 4 740332 LOA_IA12_GL1   1 140     334  00   00    10 A61SM    NA    8      TRUE
#> 5 740710 LOA_IA12_GL1 102 127     334  00   00   362 A61SM    NA   11      TRUE
#> 6 740680 LOA_IA12_GL1 103 140     334  00   00   364 A61SM    NA    9      TRUE
#>   conf nca edge agest comment7                              slug
#> 1    9   5   NA    NA       NA     loa_ia12_gl1-1-114-334-00-1-7
#> 2    9   7   NA    NA       NA     loa_ia12_gl1-1-114-334-00-2-8
#> 3    9   7   NA    NA       NA     loa_ia12_gl1-1-127-334-00-3-9
#> 4    9   8   NA    NA       NA    loa_ia12_gl1-1-140-334-00-4-10
#> 5    9  11   NA    NA       NA loa_ia12_gl1-102-127-334-00-1-362
#> 6    9   9   NA    NA       NA loa_ia12_gl1-103-140-334-00-1-364

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
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 760146 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 2 760147 LEA_IF10_001 250 001     331  03   03   125    99    99    2      TRUE
#> 3 760148 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 4 760149 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 5 760150 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#> 6 760151 LEA_IF10_001 250 001     331  03   03   125    99    99    3      TRUE
#>   conf nca edge agest comment7                                 slug
#> 1   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5824-125
#> 2   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5825-125
#> 3   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5826-125
#> 4   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5827-125
#> 5   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5828-125
#> 6   NA  NA   NA    NA          lea_if10_001-250-001-331-03-5830-125

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
#>      id       prj_cd   sam eff species grp fish ageid agemt xagem agea
#> 1 27208 LSA_IA17_CIN 01004 051     091  00   00     1 A34PD    86    3
#> 2 27267 LSA_IA17_CIN 01005 051     091  00   00     1 A34PD    86    2
#> 3 27320 LSA_IA17_CIN 01007 051     091  00   00     1 A34PD    86    3
#> 4 27366 LSA_IA17_CIN 01010 051     091  00   00     1 A34PD    86    4
#> 5 27367 LSA_IA17_CIN 01010 051     091  00   00     1 A34PD    86    4
#> 6 27368 LSA_IA17_CIN 01010 051     091  00   00     1 A34PD    86    4
#>   preferred conf nca edge agest       comment7
#> 1      TRUE    5   3    +    NA Paul Drombolis
#> 2      TRUE    4   2    +    NA Paul Drombolis
#> 3      TRUE    4   3    +    NA Paul Drombolis
#> 4      TRUE    5   4    +    NA Paul Drombolis
#> 5      TRUE    5   4    +    NA Paul Drombolis
#> 6      TRUE    5   4    +    NA Paul Drombolis
#>                                    slug
#> 1 lsa_ia17_cin-01004-051-091-00-10245-1
#> 2 lsa_ia17_cin-01005-051-091-00-10160-1
#> 3 lsa_ia17_cin-01007-051-091-00-10109-1
#> 4 lsa_ia17_cin-01010-051-091-00-10289-1
#> 5 lsa_ia17_cin-01010-051-091-00-10290-1
#> 6 lsa_ia17_cin-01010-051-091-00-10291-1



filters <- list(lake = "HU", spc = "076", grp = "55")
fn127 <- get_FN127(filters)
nrow(fn127)
#> [1] 201
head(fn127)
#>       id       prj_cd sam eff species grp fish ageid agemt xagem agea preferred
#> 1 428807 LHA_IA14_802 311 127     076  55   55   125 111JS    D1    2      TRUE
#> 2 428868 LHA_IA14_802 372 019     076  55   55   125 111JS    D1    1      TRUE
#> 3 415003 LHA_IS05_014   2   1     076  55   55   125 111XX    91   NA      TRUE
#> 4 415013 LHA_IS05_014   4   1     076  55   55   125 111XX    91   NA      TRUE
#> 5 415020 LHA_IS05_014   6   1     076  55   55   125 111XX    91   NA      TRUE
#> 6 415028 LHA_IS05_014   6   1     076  55   55   125 111XX    91   NA      TRUE
#>   conf nca edge agest comment7                              slug
#> 1    9  NA    +    NA     <NA> lha_ia14_802-311-127-076-55-3-125
#> 2    9  NA    +    NA     <NA> lha_ia14_802-372-019-076-55-9-125
#> 3   NA  NA <NA>    NA     <NA>     lha_is05_014-2-1-076-55-1-125
#> 4   NA  NA <NA>    NA     <NA>     lha_is05_014-4-1-076-55-1-125
#> 5   NA  NA <NA>    NA     <NA>     lha_is05_014-6-1-076-55-1-125
#> 6   NA  NA <NA>    NA     <NA>    lha_is05_014-6-1-076-55-10-125
```
