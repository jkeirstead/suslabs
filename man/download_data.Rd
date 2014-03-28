\name{download_data}
\alias{download_data}
\title{Gets most recent day}
\usage{
download_data(country, house, date = Sys.Date(), file)
}
\arguments{
  \item{country}{a character of length one giving the
  two-letter code representing the country, e.g. EN for
  England}

  \item{house}{a numeric of length one giving the house id}

  \item{date}{a vector of dates in the form 'YYYY-MM-DD' or
  Date objects for which to retrieve data.  Default =
  today.}

  \item{file}{a character giving the path to save the
  results.  If not specified, the default file name from
  the server is used. Must be same length as date}
}
\value{
the name of the file holding the data; if there's an error
this is an empty string
}
\description{
Gets most recent day
}

