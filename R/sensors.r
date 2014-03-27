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
plot_sensors <- function(file, sensors=c("CO2", "PIR", "LIGHT", "SOUND", "HUMIDITY", "TEMP", "ACC_X", "ACC_Y", "ACC_Z"), output, w=7, h=7, xres="30 min") {

    ## Load in the data 
    data <- read.csv(file, stringsAsFactors=FALSE)

    ## Extract just the sensors and set names
    data <- subset(data, DEVICETYPE==1,
                   select=-c(MESSAGE, TIMEOFDAY, PACKET, DEVICETYPE))

    value_cols <- grep("VALUE", names(data))
    names(data)[value_cols] <- c("CO2", "PIR", "LIGHT",
                                 "SOUND", "HUMIDITY", "TEMP",
                                 "ACC_X", "ACC_Y", "ACC_Z")

    data <- subset(data, select=c("HMS", "DEVICE", sensors))

    ## Now melt the data
    data.m <- melt(data, id=c("HMS", "DEVICE"),
                   value.name="value", variable.name="sensor")

    ## Tidy up the datatime
    data.m <- mutate(data.m, HMS=as.POSIXct(HMS, format="%H:%M:%S"))
    data.m <- mutate(data.m, DEVICE=factor(DEVICE))
    
    ## Now make the plot
    gg <- ggplot(data.m, aes(x=HMS, y=value)) +
        geom_line(aes(colour=DEVICE)) +
            facet_wrap(~sensor, ncol=3, scales="free_y") +
                theme_bw() +
                    scale_x_datetime(breaks=date_breaks(xres),
                                     labels=date_format("%H:%M")) +
                    labs(x="Time of day", y="Value")

    if (missing(output)) {
        print(gg)
    } else {
        ggsave(output, gg, width=w, height=h)
    }
}
