\name{prep_data}
\alias{prep_data}
\title{Converts a raw suslabs data sheet into a more useful format}
\usage{
prep_data(f)
}
\arguments{
  \item{f}{a character vector of length one giving a file
  name}
}
\value{
a data frame containing the tidied data
}
\description{
The raw data from the Suslabs server contains a mix of
information about the state of the connection points and
the sensor hubs. This method processes this raw data into a
more usable form by making the following corrections:
}
\details{
\itemize{ \item Filter out connection point data, so that
only sensor information is presented \item Converts the
time column to a proper date time field \item Transform the
raw sensor data into more sensible units }
}

