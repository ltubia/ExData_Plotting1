plot3<-function() {
        
        library(sqldf)
        
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
        
        # Draw graph
        par(cex.main=0.9, cex=0.75)
        plot(y$DateTime, y$Sub_metering_1, type = "l", main = "", ylab ="Global Active Power", xlab = "")
        points(y$DateTime, y$Sub_metering_2, type = "l", col = "red")
        points(y$DateTime, y$Sub_metering_3, type = "l", col = "blue")
        legend("topright", lty = c(1,1,1), col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
                
        dev.copy(png, file = "plot3.png", width=480, height=480) ## Copy my plot to a PNG file

        dev.off() ## Don't forget to close the PNG device!
        par(cex.main=1, cex=1)
        rm(y)

}
        