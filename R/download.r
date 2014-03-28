## Functions for downloading data

##' Gets most recent day
##'
##' @param country a character of length one giving the two-letter
##' code representing the country, e.g. EN for England
##' @param house a numeric of length one giving the house id
##' @param date a vector of dates in the form 'YYYY-MM-DD' or Date
##' objects for which to retrieve data.  Default = today.
##' @param file a character giving the path to save the results.  If
##' not specified, the default file name from the server is used.
##' Must be same length as date
##' @return the name of the file holding the data; if there's an error
##' this is an empty string
##' @import RCurl stringr
##' @export
download_data <- function(country, house, date=Sys.Date(), file) {

    ## Check inputs
    if (length(country)!=1 | length(house)!=1)
        stop("Country and house must be vectors of length one.")
    if (!missing(file)) {
        if (length(date)!=length(file))
            stop("You must specify the same number of files and dates.")
    }

    ## Remove empty values
    link <- get_download_link(country, house, date)
    link <- link[!is.na(link)]

    if (length(link)==0) {
        message("No valid dates specified.")
        return(character(0))
    }

    ## Download the files
    if (missing(file)) file <- str_extract(link, "SUSLAB.*\\.CSV")

    ## Define download params
    params <- data.frame(link, file, stringsAsFactors=FALSE)
    params <- apply(params, 1, as.list)
    status <- suppressWarnings(lapply(params, function(l) download.file(l$link, destfile=l$file, method="curl")))
    if (status==0) {
        message(sprintf("Successfully saved data to %s", file))
        return(file)
    } else {
        message("Problem saving data.")
        return(character(0))
    }

}

##'
##' Gets a download link for a specified country, house, and date
##'
##' @param country a two-letter country code
##' @param house a numeric house id
##' @param date a character vector giving dates in the form
##' 'YYYY-MM-DD'
##'
##' @return a character vector containing the download links.  If
##' there is no data available for a specified date, then NA is
##' returned.
##' @import XML RCurl
get_download_link <- function(country, house, date) {

    ## Tidy the inputs
    if (class(date)=="Date") date <- as.character(date)
    
    ## Build the URL
    args <- sprintf("country=%s&houseid=%d", country, house)
    doc <- paste0(base_url, "suslabnwe.wp2013devices.php?", args)

    ## Parse the webpage
    page <- htmlParse(doc)

    ## Find the data download buttons
    datapage <- "suslabnwe.wp2013housedatadownload.php"
    form <- getNodeSet(page, paste0("//form[@action='", datapage, "']"))[[1]]

    ## Extract hidden field names and values
    inputs <- getNodeSet(form, "input")
    hidden <- data.frame(name=sapply(inputs, xmlGetAttr, "name"),
                         value=sapply(inputs, xmlGetAttr, "value"),
                         stringsAsFactors=FALSE)

    ## Get the buttons of choice
    buttons <- getNodeSet(form, "button")
    button_details <- sapply(buttons, xmlAttrs)
    button_ids <- as.numeric(lapply(date, grep, button_details[2,]))
    buttons <- as.matrix(button_details[,button_ids])

    ## Remove any missing columns
    empties <- which(is.na(buttons[2,]))
    if (length(empties)>0) buttons <- as.matrix(buttons[,-empties])

    if (ncol(buttons)==0) {
        message("No download link found.")
        return(NA)
    }
    
    ## Each button is a unique link so
    args <- apply(as.matrix(buttons), 2,
                  function(x) rbind(hidden, as.data.frame(t(x), stringsAsFactors=FALSE)))
    args <- lapply(args, function(x) {
        tmp <- x$value
        names(tmp) <- x$name
        return(tmp)
    })
    
    url <- paste0(base_url, datapage, "?")
    response <- lapply(args, function(x) getForm(url, .params=x))

    ## Parse the response for download link
    results <- lapply(response, htmlParse)

    ## Extract the link
    download_base <- "suslabnwe.download.php"
    link <- lapply(results, getNodeSet, "//a[@href]")
    link <- lapply(link, sapply, xmlGetAttr, "href")
    link <- lapply(link, function(x) x[grep(download_base, x)])
    link <- paste0(base_url, link)
        
    return(link)
    
}
