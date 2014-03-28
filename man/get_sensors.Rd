\name{get_sensors}
\alias{get_sensors}
\title{Gets the details of the sensors}
\usage{
get_sensors()
}
\value{
a data frame giving the sensor id, a plain-text name, and
the units.
}
\description{
Gets the details of all the sensors measured by the Suslabs
hub.
}
\details{
Raw sensor data needs to be transformed before it can be
interpreted in everyday units.  This method will return
\code{raw} for the unit if the appropriate transformation
is unknown.
}

