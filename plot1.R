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


## create a 1X1 area for plotting
par(mfcol = c(1,1))

## plotting a histogram of Global Active Power
hist(enrg$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

## copy the impage to png device
dev.copy(png, "./plot1.png", height = 480, width = 480)

## close the device
dev.off()
