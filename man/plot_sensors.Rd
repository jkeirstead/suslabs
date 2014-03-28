\name{plot_sensors}
\alias{plot_sensors}
\title{Plots the sensor data from a file}
\usage{
plot_sensors(file, sensors = get_sensors()$id, output, w = 7, h = 7,
  xres = "30 min")
}
\arguments{
  \item{file}{the data file downloaded from
  \code{download_data}}

  \item{sensors}{a character vector giving the names of the
  sensors to plot}

  \item{output}{an output file name; if empty, the plot
  will be shown on screen.  The extension on the file name
  will determine the format}

  \item{w}{the image width in inches, if printing to file}

  \item{h}{the image height in inches, if printing to file}

  \item{xres}{the temporal resolution of the x axis}
}
\description{
Plots the sensor data from a file
}
\seealso{
ggplot2::ggsave for valid image formats
}

