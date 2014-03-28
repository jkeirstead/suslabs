\name{get_download_link}
\alias{get_download_link}
\title{Gets a download link for a specified country, house, and date}
\usage{
get_download_link(country, house, date)
}
\arguments{
  \item{country}{a two-letter country code}

  \item{house}{a numeric house id}

  \item{date}{a character vector giving dates in the form
  'YYYY-MM-DD'}
}
\value{
a character vector containing the download links.  If there
is no data available for a specified date, then NA is
returned.
}
\description{
Gets a download link for a specified country, house, and
date
}

