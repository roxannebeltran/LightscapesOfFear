#spreadsheet with each drift dive as a row
dat=read.csv('DriftDur2020WithHoursSinceSunriseAndTOD.csv')

#spreadsheet with each seal-day as a row 
fat=read.csv('Lipid_estimates_all_MOMLEAN.csv')

#change lipid mass into percent lipid, for median, upper bound, lower bound
fat$PercLipidNoPup=(fat$Lipid_median/(fat$Lipid_median+fat$Lean_female))
fat$PercLipidNoPupLower=(fat$Lipid_lower_interval/
                             (fat$Lipid_lower_interval+fat$Lean_female))
fat$PercLipidNoPupUpper=(fat$Lipid_upper_interval/
                                (fat$Lipid_upper_interval+fat$Lean_female))

#for each drift dive, add percent lipid from closest day
for(i in 1:nrow(dat)){ 
  print(i)
  #figure out which seal
  fat_i=fat[fat$TOPPID==dat$TOPPID[i],]

  #index of closest "date" date to "fat_i" date
  index=which.min(abs(fat_i$JulDate-dat$DriftJulDate[i]))
  
  #populate columns with median, upper, and lower % fat from nearest date
  dat$PercLipidNoPup[i]=fat_i$PercLipidNoPup[index]
  dat$PercLipidNoPupLower[i]=fat_i$PercLipidNoPupLower[index]
  dat$PercLipidNoPupUpper[i]=fat_i$PercLipidNoPupUpper[index]
}

write.csv(dat,'DriftDur2020WithHoursSinceSunriseAndTODAndFAT.csv',row.names=FALSE)
