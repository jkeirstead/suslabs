## Functions for examining the sensors

##' Plots the sensor data from a file
##'
##' @param file the data file downloaded from \code{download_data}
##' @param sensors a character vector giving the names of the sensors to plot
##' @param output an output file name; if empty, the plot will be
##' shown on screen.  The extension on the file name will determine
##' the format
##' @seealso ggplot2::ggsave for valid image formats
##' @param w the image width in inches, if printing to file
##' @param h the image height in inches, if printing to file
##' @param xres the temporal resolution of the x axis
##' @import reshape2 ggplot2 scales
##' @export
plot_sensors <- function(file, sensors=get_sensors()$id, output, w=7, h=7, xres="30 min") {

    ## Prepare the data
    data <- prep_data(file)

    ## Factor the sensor column for easier reading
    labels <- with(get_sensors(), paste0(name, " [", unit,"]"))
    ids <- get_sensors()$id
    data <- transform(data, sensor=factor(sensor, level=ids, labels=labels))
    
    ## Now make the plot
    gg <- ggplot(data, aes(x=datetime, y=value)) +
        geom_line(aes(colour=device)) +
            facet_wrap(~sensor, ncol=3, scales="free_y") +
                theme_bw() +
                    scale_x_datetime(breaks=date_breaks(xres),
                                     labels=date_format("%H:%M")) +
                    scale_colour_discrete(name="Device") +
                    labs(x="Time of day", y="Value")

    if (missing(output)) {
        print(gg)
    } else {
        ggsave(output, gg, width=w, height=h)
    }
}

##' Converts a raw suslabs data sheet into a more useful format
##'
##' The raw data from the Suslabs server contains a mix of information
##' about the state of the connection points and the sensor hubs.
##' This method processes this raw data into a more usable form by
##' making the following corrections:
##'
##' \itemize{
##' \item Filter out connection point data, so that only sensor
##' information is presented
##' \item Converts the time column to a proper date time field
##' \item Transform the raw sensor data into more sensible units
##' }
##' 
##' @param f a character vector of length one giving a file name
##' @return a data frame containing the tidied data
##' @import stringr reshape2
prep_data <- function(f) {

    ## Verify the inputs
    if (length(f)!=1) stop("Only one file name is supported.")

    ## Load in the raw data
    raw <- read.csv(f, stringsAsFactors=FALSE)

    ## Remove the connection point rows
    raw <- subset(raw, DEVICETYPE!=0)

    ## Drop the other unloved columns
    raw <- subset(raw, select=-c(MESSAGE,DEVICETYPE,TIMEOFDAY,PACKET))

    ## Convert the time to a ISO standard
    ## and factor device
    date <- str_replace(f, ".*\\.([0-9]*)\\.CSV", "\\1")
    date <- str_replace(date, "([0-9]{4})([0-9]{2})([0-9]{2})", "\\1-\\2-\\3")
    raw <- transform(raw, HMS=as.POSIXct(paste(date, HMS)),
                     DEVICE=factor(DEVICE))
    
    ## Assign sensible names
    names(raw) <- c("datetime", "device", get_sensors()$id)

    ## Melt the data to prepare for transformation
    raw.m <- melt(raw, id=c("datetime", "device"), variable.name="sensor")

    ## Do the transformation
    tmp <- dlply(raw.m, .variables="sensor")
    tmp <- lapply(tmp, xform)
    tmp <- ldply(tmp)[,-1]

    ## Arrange the result by device, sensor, and datetime
    tmp <- arrange(tmp, device, sensor, datetime)

    ## Return the result
    return(tmp)
}

##' Transforms a data frame with a single sensor type
##'
##' @param df a data frame
##' @return a data frame where the value column has been transformed
##' back into native units for that sensor type.
xform <- function(df) {

    ## Check inputs
    sensor_type <- unique(df$sensor)
    if (length(sensor_type)!=1)
        stop("Only single sensor data frames are allowed.")

    f <- identity
    if (sensor_type=="HUMIDITY") {
        f <- function(x) return(-6 + 125*(x/2^16))
    } else if (sensor_type=="TEMP") {
        f <- function(x) return(-46.85+175.72*(x/2^16))
    }

    return(transform(df, value=f(value)))
}

##' Gets the details of the sensors
##'
##' Gets the details of all the sensors measured by the Suslabs hub.
##'
##' @return a data frame giving the sensor id, a plain-text name, and the units.
##'
##' @details Raw sensor data needs to be transformed before it can be
##' interpreted in everyday units.  This method will return \code{raw}
##' for the unit if the appropriate transformation is unknown.
get_sensors <- function() {
    df <- data.frame(id=c("CO2", "PIR", "LIGHT",
                         "SOUND", "HUMIDITY", "TEMP",
                         "ACC_X", "ACC_Y", "ACC_Z"),
                     name=c("Carbon dioxide", "Motion", "Light",
                         "Sound", "Relative humidity", "Temperature",
                         "Acceleration (x)", "Acceleration (y)", "Acceleration (z)"),
                     unit=c(rep("raw", 3), "raw", "percent", "deg C", rep("raw", 3)),
                     stringsAsFactors=FALSE)
    return(df)
}
