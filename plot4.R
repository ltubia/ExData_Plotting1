plot4<-function() {
        
        library(sqldf)
        library(lubridate)
        
        ## 1. Download file to temp file at local path
        temp<-"exdata_Fdata_Fhousehold_power_consumption.zip" ## Get file from local path
        if (!file.exists(temp))
        {
                fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                #temp<-tempfile()
                download.file(fileurl,paste0(getwd(),"/",temp), method="wget")
        }
        
        
        # read data filtering a priori so as to not load unnecesary dates
        y<-read.csv.sql(unzip("exdata_Fdata_Fhousehold_power_consumption.zip", "household_power_consumption.txt"),sql="select * from file where Date IN('1/2/2007','2/2/2007')", eol = "\n", sep = ";", header=TRUE)
        
        # convert dates        
        y<-transform(y, Date = as.Date(Date, format = "%d/%m/%Y"))
        
        # calculate weekday
        y$Wd<-weekdays(y$Date)
        y$DateTime<-ymd_hms(paste(y$Date, y$Time))
        
        #configure layout
        par(mfrow = c(2, 2), cex=0.6)
        
        # Draw graph: upper left
        plot(y$DateTime, y$Global_active_power, type = "l", main = "", ylab ="Global Active Power", xlab = "")
        # Draw graph: upper right
        plot(y$DateTime, y$Voltage, type = "l", main = "", ylab ="Voltage", xlab = "datetime")
        # Draw graph: bottom left
        plot(y$DateTime, y$Sub_metering_1, type = "l", main = "", ylab ="Global Active Power", xlab = "")
        points(y$DateTime, y$Sub_metering_2, type = "l", col = "red")
        points(y$DateTime, y$Sub_metering_3, type = "l", col = "blue")
        legend("topright", lty = c(1,1,1), col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), bty="n")
        # Draw graph: bottom right
        plot(y$DateTime, y$Global_reactive_power, type = "l", main = "", ylab ="Global_reactive_power", xlab = "datetime")
        
        dev.copy(png, file = "plot4.png" , width=480, height=480) ## Copy my plot to a PNG file
        dev.off() ## Don't forget to close the PNG device!
        
        # reset layout
        par(mfrow = c(1, 1), cex=1)
        rm(y)
}
