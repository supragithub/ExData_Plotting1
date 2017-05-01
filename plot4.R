## Objective of the program is to read the household power consumption data 
## and create plots from this data

## For this plot we need data only for 1/2/2007 and 2/2/2007
## identify the rows for these two dates

all_rows <- readLines("./data/household_power_consumption.txt")
select_dt <- grep("^[12]/2/2007", all_rows)

## number of selected rows
num_select_rows <- length(select_dt)

## read a sample row for memory estimation 
enrg_head <- read.table("./data/household_power_consumption.txt", header = TRUE, sep = ";", nrows = 1, stringsAsFactors = FALSE, na.strings = "?")

## row_size stores the size of each row
row_size <- 0
for(i in seq_along(enrg_head[1,])){row_size <- row_size + object.size(enrg_head[1,i])}

## estimated memory requirement for select rows
data_size <- num_select_rows * row_size

## print it
message(paste("Estimated memory requirement :",format(data_size, units = "auto")))


## skip the rows till the requied date first appears

skip_rows <- (head(select_dt,1) -1)

## read selected number of records which is 

read_rows <- length(select_dt)

## read the select rows

enrg <- read.table("./data/household_power_consumption.txt", skip = skip_rows, header = FALSE, sep = ";", nrows = read_rows)

## set the variable names back

names(enrg) <- names(enrg_head)

## combine the Date and Time variables and convert into a DateTime variable
enrg$DateTime <- strptime(paste(enrg$Date, enrg$Time), "%d/%m/%Y %T")

## Now the data is ready for plotting

## create a 2X2 area for plotting
par(mfcol = c(2,2))

## Plot the Globale Active Power for Line chart

plot(enrg$DateTime, enrg$Global_active_power, type = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(enrg$DateTime, enrg$Global_active_power)

## Plot the Sub Metering 1, 2 and 3 data for Line Chart

plot(enrg$DateTime, enrg$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(enrg$DateTime, enrg$Sub_metering_1)
lines(enrg$DateTime, enrg$Sub_metering_2, col = "red")
lines(enrg$DateTime, enrg$Sub_metering_3, col = "blue")

## Create Legend for Sub Metering Line Chart

 legend("topright", names(enrg[,7:9]), lty = 1, col=c("black", "red", "blue"), cex = .75, y.intersp = 0.25, bty = "n")

## Plot the Voltage Chart

plot(enrg$DateTime, enrg$Voltage, type = "n", xlab = "datetime", ylab = "Voltage")
lines(enrg$DateTime, enrg$Voltage)

## Plot the Global Reactive Power Chart

plot(enrg$DateTime, enrg$Global_reactive_power, type = "n", xlab = "datetime", ylab = "Global_reactive_power")
lines(enrg$DateTime, enrg$Global_reactive_power)


## copy the impage to png device
dev.copy(png, "./plot4.png", width = 480, height = 480)

## close the device
dev.off()
