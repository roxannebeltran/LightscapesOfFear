
################## calculate time since sunrise
dat = read.csv('DriftDur_withLight_2020_ALLSEALS_KeepOnly.csv')
dat = dat[, 1:15] #to remove "keep" column

UniqueSeals = unique(dat$TOPPID)

sunrises = read.csv('SunriseSunsetDaylengthSMOOTHED.csv')

#for each unique seal, subset sunrise hour data
for (i in 1:length(UniqueSeals)) {
  sunrises_i = sunrises[sunrises$TOPPID == UniqueSeals[i], ]
  
  SunriseDate = sunrises_i$JulDate
  SunsetDate = sunrises_i$JulDate.1
  Daylength = sunrises_i$SmoothedDaylength
  
  drifts = dat[dat$TOPPID == UniqueSeals[i], ]
  
  HoursSinceSunrise = vector(length = nrow(drifts))
  HoursSinceSunset = vector(length = nrow(drifts))
  SunriseHourClosest = vector(length = nrow(drifts))
  SunsetHourClosest = vector(length = nrow(drifts))
  DaylengthClosest = vector(length = nrow(drifts))
  
  #for each drift dive
  for (j in 1:nrow(drifts)) {
    #calculate index of closest SunriseDate to Drift Date
    diff = drifts[j, 4] - SunriseDate
    
    if (max(diff) >= 0) {
      index = which(diff == min(diff[diff > 0])) #closest without going over (max where difference is negative)
    } else{
      index = 1
    }
    
    SunriseHourClosest[j] = sunrises_i$SmoothedSunrise[index]
    HoursSinceSunrise[j] = drifts$DriftStartGMT[j]-SunriseHourClosest[j]
    
    #calculate index of closest SunsetDate to Drift Date
    diff = drifts[j, 4] - SunsetDate
    
    if (max(diff) >= 0) {
      index = which(diff == min(diff[diff > 0]))
    } else{
      index = 1
    }
    SunsetHourClosest[j] = sunrises_i$SmoothedSunset[index]
    HoursSinceSunset[j]  = drifts$DriftStartGMT[j]-SunsetHourClosest[j]
    
    DaylengthClosest[j] = Daylength[index]
  }
  out = cbind(
    drifts,
    SunriseHourClosest,
    HoursSinceSunrise,
    SunsetHourClosest,
    HoursSinceSunset,
    DaylengthClosest
  )
  colnames(out) = c(
    colnames(drifts),
    "SmoothSunriseHour",
    "HoursSinceSunrise",
    "SmoothSunsetHour",
    "HoursSinceSunset",
    "SmoothDaylength"
  )
  
  if (i == 1) {
    outall = out
  } else{
    outall = rbind(outall, out)
  }
}

write.csv(outall, 'DriftDur2020WithHoursSinceSunrise.csv', row.names = FALSE)
