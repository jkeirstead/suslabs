## Functions for downloading data

##' Gets most recent day
##'
##' @param country a two-letter code giving the country code, e.g. EN
##' for England
##' @param house a numeric giving the house id
##' @param file a character giving the path to save the results.  If
##' not specified, the default file name from the server is used.
##' @return the name of the file holding the data; if there's an error this is an empty string
##' @import XML RCurl stringr
##' @export
download_data <- function(country, house, file) {
    ## Build the URL
    args <- sprintf("country=%s&houseid=%d", country, house)
    doc <- paste0(base_url, "suslabnwe.wp2013devices.php?", args)

    ## Parse the webpage
    page <- htmlParse(doc)

    ## Find the data download buttons
    datapage <- "suslabnwe.wp2013housedatadownload.php"
    form <- getNodeSet(page, paste0("//form[@action='", datapage, "']"))[[1]]
    buttons <- getNodeSet(form, "button")
    button <- buttons[[length(buttons)]]
    inputs <- getNodeSet(form, "input")
   
    ## Extract the values
    names <- sapply(inputs, xmlGetAttr, "name")
    values <- sapply(inputs, xmlGetAttr, "value")
    button.val <- xmlGetAttr(button, "value")
    button.name <- xmlGetAttr(button, "name")

    args <- c(values, button.val)
    names(args) <- c(names, button.name)

    url <- paste0(base_url, datapage, "?")
    response <- getForm(url, .params=args)

    ## Parse the response for download link
    results <- htmlParse(response)

    ## Extract the link
    download_base <- "suslabnwe.download.php"
    link <- getNodeSet(results, "//a[@href]")
    link <- sapply(link, xmlGetAttr, "href")
    link <- link[grep(download_base, link)]
    link <- paste0(base_url, link)

    ## Download the file
    if (missing(file)) file <- str_extract(link, "SUSLAB.*\\.CSV")
    status <- download.file(link, destfile=file, method="curl")
    if (status==0) {
        message(sprintf("Successfully saved data to %s", file))
        return(file)
    } else {
        message("Problem saving data.")
        return(character(0))
    }


}
