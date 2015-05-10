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

# Plot4

par(mfrow = c(2, 2))
with(DT, {
  par(mar = c(4,4,4,2), oma = c(3,2,2,2), cex = 0.5)
  plot(DateTime, Global_active_power, type = 'l', ylab = 'Global Active Power (kilowatts)')
  plot(DateTime, Voltage, type = 'l', ylab = 'Voltage')
  {with(DT, plot(DateTime, Sub_metering_1, type = 'l', xlab = '', ylab = 'Energy sub metering',col = 'grey45'))
   with(DT, lines(DateTime, Sub_metering_2, col = 'red', xlab = ''))
   with(DT, lines(DateTime, Sub_metering_3, col = 'blue', xlab = ''))
  }
  plot(DateTime, Global_reactive_power, type = 'l')
})
dev.copy(png, file = 'plot4.png', height=480, width=480)
dev.off()
