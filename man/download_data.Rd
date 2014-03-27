\name{download_data}
\alias{download_data}
\title{Gets most recent day}
\usage{
download_data(country, house, file)
}
\arguments{
  \item{country}{a two-letter code giving the country code,
  e.g. EN for England}

  \item{house}{a numeric giving the house id}

  \item{file}{a character giving the path to save the
  results.  If not specified, the default file name from
  the server is used.}
}
\value{
the name of the file holding the data; if there's an error
this is an empty string
}
\description{
Gets most recent day
}

