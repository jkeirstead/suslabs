#' suslabs
#'
#' Provides functions for downloading and analysing SusLabs NWE data.
#' 
#' @name suslabs
#' @docType package
NULL

.onAttach <- function(libname, pkgname) {
    config <- "server-settings.txt"
    if (file.exists(config)) {
        set_base_url(read.csv(config, header=FALSE, stringsAsFactors=FALSE)$V1)
    } else {
        msg <- sprintf("Config file '%s' not found.  Call set_base_url before using package functions.", config)
        warning(msg)
    }
}

##' Set the base url for the SusLabs server
##'
##' @param url a character vector giving the URL
##' @export
set_base_url <- function(url) {
    base_url <<- url
}


