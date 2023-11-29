

Sys.setenv(GLIS_DOMAIN="https://intra.stage.glis.mnr.gov.on.ca/")

# HTTP only!!
Sys.setenv(GLIS_DOMAIN="http://127.0.0.1:8000/")

library(glfishr)

fn121 <- get_FN121(list(prj_cd='LHA_IA12_007'))

pts <- with(fn121, data.frame(slug=slug, dd_lat=DD_LAT0, dd_lon=DD_LON0))
grids <- get_grid5s_from_points(pts)


fof <- get_fisheries_offices()
ptypes <- get_project_types()


gps_tracks <- get_FN121_GPS_Tracks(list(prj_cd ="LEA_IA17_097"))


setwd("c:/Users/COTTRILLAD/Documents/1work/R/MyPackages/glfishr/sandbox/populate_template")

# source("./src/utils.R")
# source("./src/populate_template.R")


trg_dir <-
  "c:/Users/COTTRILLAD/Documents/1work/R/MyPackages/glfishr/sandbox/populate_template"

template_db <- file.path(
  trg_dir,
  "Great_Lakes_Assessment_Template_5.accdb"
)
trg_db <- file.path(
  trg_dir,
  "CapeRich_2009.accdb"
)


filters <- list(prj_cd="LHA_IA09_002")
populate_template(filters, template_db, trg_db)


PRJ_CD <- "DRM_IA19_003"

filters <- list(prj_cd = PRJ_CD)
populate_template(filters, template_db)


filters <- list(prj_cd="LHA_IA09_005")
populate_template(filters, template_db, "Oliphant_2009.accdb")


filters <- list(prj_cd=c("LHA_IA10_005", "LHA_IA10_006"))
populate_template(filters, template_db)


#one with fn012, one without
filters <- list(prj_cd=c("LHA_IA16_801", "LHA_IA10_006"))
populate_template(filters, template_db, overwrite=TRUE)

filters <- list(lake="HU", year=1985)
populate_template(filters, template_db)



fish <- get_FN125(list(
  lake = "HU", spc = '061',
  flen__null = FALSE
))

# length vs rwt
with(fish, plot(density(FLEN)))
with(fish, rug(FLEN))
abline(v=300, col='red')


#log-log
with(alewife, plot(log(TLEN)~log(RWT)))

alewife$K <- 100000 * alewife$RWT / (alewife$TLEN^3)

alewife[
  alewife$TLEN < 400,
  names(alewife) %in% c(
    "PRJ_CD", "SAM", "EFF", "SPC", "GRP", "FISH",
    "FLEN", "TLEN", "RWT"
  )
]




tags <- get_FN125_Tags(list(prj_cd="LHA_IS20_018"))


tags <- get_FN125_Tags(list(prj_cd="LHA_IS20_018",
  tagid__like='4356'))

tags <- get_FN125_Tags(list(lake = "HU", year = 2020 ))

tag_filters <- list(lake = "HU", year = 2020,
  tagdoc=c("C5014","A4018"))
tags <- get_FN125_Tags(tag_filters)


tag_filters <- list(
  lake = "HU", year = 2020,
  tagdoc__like = "670"
)
tags <- get_FN125_Tags(tag_filters)
nrow(tags)

fn127_filters <- list(lake="HU", year=2020)
fn127 <- get_FN127(fn127_filters)


fn127_filters <- list(lake="HU", year=2020, agemt__like="DW")
fn127 <- get_FN127(fn127_filters)
print(nrow(fn127))
head(fn127)

fn127_filters <- list(lake="HU", year=2020, agemt__not_like="DW")
fn127 <- get_FN127(fn127_filters)
print(nrow(fn127))
head(fn127)


#FN126 - Lifestage Like:

fn126_filters <- list(year=2020)
fn126 <- get_FN126(fn126_filters)
print(nrow(fn126))
head(fn126)


fn126_filters <- list(year__gte=2010, lifestage__null=FALSE)
fn126 <- get_FN126(fn126_filters)
print(nrow(fn126))
head(fn126)


fn126_filters <- list(year__gte=2010, lifestage__like=9)
fn126 <- get_FN126(fn126_filters)
print(nrow(fn126))
head(fn126)



fn126_filters <- list(year__gte=2010, lifestage__not_like=9)
fn126 <- get_FN126(fn126_filters)
print(nrow(fn126))
head(fn126)



# STRATUM FILTERS:


sc_filters <- list(prj_cd = "LEA_SC94_01F")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$MODE)
unique(sc111$SUBSPACE)


sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "??_21_02_S1")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$MODE)
unique(sc111$SUBSPACE)


sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_?1_02_S1")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$MODE)
unique(sc111$SUBSPACE)

sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_2?_02_S1")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$SUBSPACE)
unique(sc111$MODE)


sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_21_??_S1")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$SUBSPACE)
unique(sc111$MODE)

sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_21_02_??")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$MODE)
unique(sc111$SUBSPACE)
unique(sc111$MODE)



sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "??_21_??_S1")

sc111 <- get_SC111(sc_filters)
print(nrow(sc111))
unique(sc111$STRATUM)
unique(sc111$SSN)
unique(sc111$DTP)
unique(sc111$PRD)
unique(sc111$SUBSPACE)
unique(sc111$MODE)




sc_filters <- list(prj_cd = "LEA_SC94_01F")
sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)



sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "??_21_02_S1")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)



sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_?1_02_S1")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)



sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_2?_02_S1")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)


sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_21_??_S1")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)



sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "06_21_02_??")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)


sc_filters <- list(prj_cd = "LEA_SC94_01F", stratum = "??_21_02_??")

sc121 <- get_SC121(sc_filters)
print(nrow(sc121))
unique(sc121$STRATUM)
unique(sc121$SSN)
unique(sc121$DTP)
unique(sc121$PRD)
unique(sc121$SUBSPACE)
unique(sc121$MODE)
