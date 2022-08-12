#' Exceed maximum number of API calls
#' 
#' The series of `glfishr` `get_**` functions each retrieve a maximum number of results 
#' when the function is called. Use `exceed_limit` to retrieve a dataframe that is longer 
#' than this limit. `exceed_limit` applies your chosen get function to each PRJ_CD of 
#' interest and binds those results into a new dataframe.
#'
#' @param get_fun Any `glfishr` function that begins with `get_`
#' @param prj_cds A list of PRJ_CD strings or a column containing each PRJ_CD of interest
#' @param extra_filters_as_list An optional list of additional filters to pass along to `get_fun`
#'
#' @return
#' @export
#'
#' @examples
#' FN011 <- get_FN011(list(protocol = "BSM", lake = "HU", prj_cd__not = "LHR_IA17_819", prj_cd__not_like = "BM"))
#' FN122 <- exceed_limit(get_FN122, FN011$PRJ_CD)
#' FN122_NA1 <- exceed_limit(get_FN122, FN011$PRJ_CD, list(gr = "NA1"))
#' FN125_NA1 <- exceed_limit(get_FN125, FN011$PRJ_CD, list(gr = "NA1"))
exceed_limit <- function(get_fun, prj_cds, extra_filters_as_list = NULL) {
  
  df_list <- lapply(1:length(prj_cds), function(i) {
    
    base_filter <- list(prj_cd = prj_cds[i])
    
    if (is.null(extra_filters_as_list)) {
      my_filters <- base_filter
    } else {
      my_filters <- append(base_filter, extra_filters_as_list)
    }
    
    tmp <- get_fun(my_filters)
    
    tmp_df <- data.frame(tmp)
  })
  
  my_FN122 <- do.call(rbind, df_list)
  
  return(my_FN122)
}