
#' relabel inconsistent fishery names in FRAM/TAMM
#'
#' With argument `sep = TRUE`, will return data frame with separate
#' columns for the area and the the "class" (Net, Troll, Sport)
#'
#' @param x character vector of fishery names from TAMM or FRAM
#' @param sep Should we return a dataframe with separate column for class of fishing? Defaults to FALSE
#'
#' @return #vector with cleaned fishery names OR dataframe with cleaned name (`$full`),
#' area without fishery type (`$area`) and type of fishery (`$class`).
#' @export
#'
fishery_renamer = function(x, sep = FALSE){
  x = gsub("^A ", "Area ", x)
  x = gsub("^Ar ", "Area ", x)
  x = gsub(" Spt$", " Sport", x)
  x = gsub(" Sprt$", " Sport", x)
  x = gsub(" Trl$", " Troll", x)
  x = gsub("BCOutSport", "BCOut Sport", x)
  if(sep){
    x.class = gsub("^.* ", "", x)
    x.ident = gsub(pattern = " [^ ]*$", "", x)
    return(data.frame(full = x,
                      area = x.ident,
                      class = x.class))
  }else{
    return(x)
  }
}
