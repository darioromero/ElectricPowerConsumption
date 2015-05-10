library("data.table")
library('lubridate')
# using fread -> produces a data.table object
dt5r <- fread("household_power_consumption.txt", header = TRUE, nrows = 5, sep = ';')
columnNames <- names(dt5r)
classes <- c('character')

system.time(DT <- fread("household_power_consumption.txt", header = TRUE, colClasses = classes, sep = ';', na.strings = '?', verbose = FALSE))
print(object.size(DT), units="Mb")

setkey(DT, 'Date', 'Time')
DT <- DT[.(c('1/2/2007','2/2/2007')), ]
DT[, (c(3:9)) := lapply(.SD, as.numeric), .SDcols = c(3:9)]

datetime <- paste(DT[,Date], DT[,Time])
datetime <- fast_strptime(datetime, '%d/%m/%Y %H:%M:%S')

DT[,`:=`(WDay = as.character(wday(DT$Date, label = TRUE, abbr = TRUE)))]
DT[,`:=` (DateTime = datetime)]

setkey(DT, 'DateTime')

# Plot1

hist(DT$Global_active_power, col = 'red', 
     xlab = 'Global Active Power (kilowatts)',
     ylab = 'Frequency',
     main = 'Global Active Power')
dev.copy(png, file = 'plot1.png', height=480, width=480)
dev.off()

