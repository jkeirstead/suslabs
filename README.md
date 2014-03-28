# suslabs

suslabs is an R package that provides easy access to environmental monitoring data collected using a [SusLabs NWE](http://suslab.eu/) hub.  

## System requirements
	
You must have [Curl](http://curl.haxx.se/) installed to use this package.

In order to restrict access to the SusLabs server, you must manually set the base url of the server in one of two ways:

 * by placing a file called `server-settings.txt` in your working directory *before* loading the package.  This file should contain a single line giving the server url with trailing slash, e.g. `http://suslabs.server/`
 
 * by loading the package and then calling the `set_base_url` function
 
## Use

The package can then be used to download and plot sensor data.  Here's a simple example:

First we load the package into our R session.  If the `server-settings.txt` file hasn't been found, a warning message will remind you to manually set it with `set_base_url`.

```r
library(suslabs)
```

Then we can download data, specifying the country and house number.  Optionally, you can specify the name of the file in which to save the data.  

```r
country <- 'EN'
house <- 7
f <- download_data(country, house)
```	

By default, `download_data` will retrieve today's data.  However you can choose to select one or more days' worth of data by specifying the dates in ISO format.  The function automatically strips out dates for which there is no data available.  

```r
## f is a vector of length 2 since there is no data for the first date
f <- download_data(country, house, c("1900-01-01", "2014-03-27", "2014-03-28"))
```

The object `f` now gives the path to the download data file, which you can find on your hard drive in R's working directory (unless you've used the optional file argument and specified a different path).  

We can then plot this data.  The first case shows the plot on the screen:

```r
## Show all the sensors
plot_sensors(f)

## Or just a few of them
plot_sensors(f, sensors=c("CO2", "LIGHT"))
```

You can also save the results to a file as shown below.  Note that the format of the resulting graphics file is determined by the extension of the `output` file.

```r
plot_sensors(f, output='plot.pdf')
```

There are other plotting options available for setting the plot size (when writing to a file) and the temporal resolution of the x-axis.  You can get full details on this, or other functions, by typing `?function` at the command line.  For example, the following shows you the full options for the `plot_sensors` method.

```r
?plot_sensors
```

## Limitations

The package currently plots the data in its raw form.  No corrections have been made to convert, for example, `TEMPERATURE` values into degrees Celsius.  This will be introduced in future versions.
