
TLL=read.csv('TLLall.csv',header=FALSE)
colnames(TLL)=c("JulDate","Lat","Lon360","TOPPID")

dat=read.csv('DriftDur2020WithHoursSinceSunriseAndTODAndFAT.csv')

for(i in 1:nrow(dat)){ 
  print(i)
  #figure out which seal and subset TLL
  TLL_i=TLL[TLL$TOPPID==dat$TOPPID[i],]
  #interpolate TLL and drift date
  
  dat$Longitude[i]=approx(x=TLL_i$JulDate, y = TLL_i$Lon360, xout=dat$DriftJulDate[i], method = "linear",rule = 1, f = 0, ties = mean)$y
  
  dat$Latitude[i]=approx(x=TLL_i$JulDate, y = TLL_i$Lat, xout=dat$DriftJulDate[i], method = "linear",rule = 1, f = 0, ties = mean)$y
}


write.csv(dat,'DriftDur2020WithHoursSinceSunriseAndTODAndFATandTLL.csv',row.names=FALSE)
