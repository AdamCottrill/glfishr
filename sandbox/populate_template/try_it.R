library(glfishr)

setwd("c:/Users/COTTRILLAD/Documents/1work/R/MyPackages/glfishr/sandbox/populate_template")

source("./src/utils.R")
source("./src/populate_template_assessment.R")


template_db <- "Great_Lakes_Assessment_Template_5.accdb"

filters <- list(prj_cd="LHA_IA09_002")
populate_template_assessment(filters, template_db)


PRJ_CD <- "DRM_IA19_003"

filters <- list(prj_cd = PRJ_CD)
populate_template_assessment(filters, template_db)


filters <- list(prj_cd="LHA_IA09_005")
populate_template_assessment(filters, template_db, "Oliphant_2009.accdb")


filters <- list(prj_cd=c("LHA_IA10_005", "LHA_IA10_006"))
populate_template_assessment(filters, template_db)


#one with fn012, one without
filters <- list(prj_cd=c("LHA_IA16_801", "LHA_IA10_006"))
populate_template_assessment(filters, template_db)

filters <- list(lake="HU", year=1985)
populate_template_assessment(filters, template_db)
