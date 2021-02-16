
dat=read.csv('DriftDur2020WithHoursSinceSunrise.csv')

for(i in 1:nrow(dat)){#for each dive
  
  #Day if half hour after sunrise and less than daylength -1 (bcs daylength is sunrise to sunset so we need to account for the extra half hour of twilight * 2 included in that)
  if(!is.na(dat$HoursSinceSunrise[i])){
    if(dat$HoursSinceSunrise[i]<0&dat$HoursSinceSunset[i]<0){
      index=which.max(c(dat$HoursSinceSunrise[i],dat$HoursSinceSunset[i]))
      if(index==1){ #if sunrise is sooner
        dat$TimeOfDay[i]="Night"
      }else{ #if sunset is sooner
        dat$TimeOfDay[i]="Day"
      }
    }else if(dat$HoursSinceSunset[i]<=(23.5-dat$SmoothDaylength[i])){
      dat$TimeOfDay[i]="Night"
    }else if(dat$HoursSinceSunrise[i]<=(dat$SmoothDaylength[i]-.5)){
      dat$TimeOfDay[i]="Day"
    }
    
    #Twilight if half hour before/after sunrise or sunset
    dat$TimeOfDay[abs(dat$HoursSinceSunrise)<.5]="Twilight"
    dat$TimeOfDay[abs(dat$HoursSinceSunset)<.5]="Twilight"
    
    
  }
}

write.csv(dat,'DriftDur2020WithHoursSinceSunriseAndTOD.csv',row.names=FALSE)
