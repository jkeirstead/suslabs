\name{load_data}
\alias{load_data}
\title{Loads data from multiple files into a single data frame}
\usage{
load_data(f)
}
\arguments{
  \item{f}{a character length of file names}
}
\value{
a data.frame giving the data in four columns: datetime, the
device id, the sensor name, and the measured value.
}
\description{
Loads data from multiple files into a single data frame
}

