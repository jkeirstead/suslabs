#' suslabs
#'
#' Provides functions for downloading and analysing SusLabs NWE data.
#' 
#' @name suslabs
#' @docType package
NULL

.onLoad <- function(libname, pkgname) {
    base_url <<- read.csv("server-settings.txt", header=FALSE, stringsAsFactors=FALSE)$V1
}
