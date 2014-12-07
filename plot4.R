## Exploratory Data Analysis Assignment 1
## 7/12/2014

##  P L O T     4

#########################
##  PART 1
##
##  GET A NICE DATA SET
#########################


## 1) DOWNLOAD THE DATA

    if (!file.exists("./data")) {
        # Create the folder to download
        dir.create("data")
        
        #Download the zipped data to a temp file
        elecURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

        temp <- tempfile()      #Creates a file called "temp" to hold the zip
        download.file(elecURL, 
                      destfile= temp, 
                      method = "curl")
        dateDownloaded <- date()
    }
    
# 2) UNZIP THE DATA
    #Unzip
    unzip(temp, exdir="./data/")
    
    #Clean up
    unlink(temp) #Deletes the temp file
    rm(temp)     #Removes the temp file from the environment
    
# 3) OPEN THE TABLE AS A DATA FRAME
    library(dplyr)
    myData <- read.table(
        "./data/household_power_consumption.txt", 
        sep=";", 
        header=TRUE,
        stringsAsFactors = FALSE,
        na.strings=c("?","NA","")
    )
    df <- tbl_df(myData)

    #Clean up
    rm(myData)
    
## 4) FORMAT THE DATE AND TIME PROPERLY 
    # Add a DateTime column in POSIXct format
    df$DateTime <- as.POSIXct(
        strptime(
            paste(df$Date, df$Time), 
            format="%d/%m/%Y %H:%M:%S"
            )
        )
    
## 5) ONLY GET DATA FOR RELEVANT DAYS (AND NO NAs)
    df2 <- df[df$DateTime >="2007-02-01" 
             & 
                 df$DateTime<"2007-02-03" 
             & 
                 !is.na(df$DateTime)
             , 
             ]


#####################################
##  PART 2
##
##  MAKE THE CHART
####################################

# PLOT 4: FOUR CHARTS
    png(
        "plot4.png"
        , width =     480
        , height =    480
        , units =     "px"
    )
    #Make a 2x2 grid for the plots
    par(
        mfrow= c(2,2)
        )
    
#Top left plot
    plot(
        df2$DateTime
         , df2$Global_active_power
         , type="l"
         , ylab="Global Active Power"
         , xlab=""
    )
    
#Top right plot
    plot(
        df2$DateTime
        , df2$Voltage
        , type = "l"
        , ylab = "Voltage"
        , xlab = "datetime"
        )
    
#Bottom left plot
    plot(
        df2$DateTime
        , df2$Sub_metering_1
        , type = "l"
        , ylab="Energy sub metering"
        , xlab=""
    )
    
    #Sub_metering_2 (red)
    lines(
        df2$DateTime
        , df2$Sub_metering_2
        , col = "red"
    )
    #Sub_metering_3 (blue)
    lines(
        df2$DateTime
        , df2$Sub_metering_3
        , col = "blue"
    )
    #Add a legend
    legend(
        "topright"  #Position
        , c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")   # Text 
        , lty = c(1, 1, 1)      # Line type in legend = Straight lines
        , lwd = c(2.5, 2.5, 2.5)  # Line width = 2.5 pixels wide
        , col = c("black", "red", "blue")   # Line colour
    )
    
#Bottom right plot
    plot(
        df2$DateTime
        , df2$Global_reactive_power
        , type="l"
        , ylab = "Global_reactive_power"
        , xlab = "datetime"
        )
    
    
    dev.off()    
    
 ##
    