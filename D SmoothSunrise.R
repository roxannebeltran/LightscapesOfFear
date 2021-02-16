dat=read.csv('SunriseSunsetTimesALL.csv')

seals=unique(dat$TOPPID)

#for each seal
for(i in 1:length(seals)){ 
#pull data
dat.i=dat[dat$TOPPID==seals[i],]
rise.i=dat.i[dat.i$Rise==TRUE,c(1,3:11),]
set.i=dat.i[dat.i$Rise==FALSE,c(1,5:11),]
#always starts with a sunset so need to do sunrise(1:end-1) and sunset (2:end)
rise.i=rise.i[1:(nrow(rise.i)-1),]
set.i=set.i[2:nrow(set.i),]
#clean up with loess
rise.i$SmoothedSunrise=lowess(x=rise.i$JulDate,y=((rise.i$JulDate-floor(rise.i$JulDate))*24),f=.2)$y
set.i$SmoothedSunset=lowess(x=set.i$JulDate,y=((set.i$JulDate-floor(set.i$JulDate))*24),f=.2)$y
#calculatedaylength
SmoothedDaylength=24+(set.i$SmoothedSunset-rise.i$SmoothedSunrise)

if(i==1){
  outall=cbind(rise.i,set.i,SmoothedDaylength)
}else{
  outall=rbind(outall,cbind(rise.i,set.i,SmoothedDaylength))
}
}
colnames(outall)[1]="Sunrise"
colnames(outall)[12]="Sunset"

write.csv(outall,'SunriseSunsetDaylengthSMOOTHED.csv',row.names = FALSE)
