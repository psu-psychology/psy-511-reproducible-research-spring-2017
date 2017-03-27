*_____GENERAL SETUP_________________________________________________________________.
     *_____DEFINING MACROS__________________________________________________________.
*These macros allow you to define path names without having to rewrite them throughout your syntax.
*Choose the path you need depending on where you want to retrieve the data file from.
*Works on SPSS 13 OR SPSS 16.

DEFINE getSMFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Master.sav'
!ENDDEFINE.
DEFINE getSTFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Temp.sav'
!ENDDEFINE.
DEFINE getGMFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Gmat.Master.sav'
!ENDDEFINE.
DEFINE getGTFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Gmat.Temp.sav'
!ENDDEFINE.
DEFINE getAFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Combined.sav'
!ENDDEFINE.
DEFINE getATFile ()
'/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Combined.sav'
!ENDDEFINE.

     *_____PATH NAMES FOR GET & SAVE________________________________________________
*Now that you have already defined the macros you only need to run this syntax to GET your file.
GET FILE=getMFile.

*Now that you have already defined the macros you only need to run this syntax to SAVE your file.
SAVE OUTFILE=getMFile.

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
************************************************************************************.
***************** PREP FILES FOR MERGE *********************************************.
************************************************************************************.
*_____PREP GAIT DATA FOR MERGE______________________________________________________.
      *_____COMPUTE VARIABLES_______________________________________________________.
      *_____RECODE GAIT DISRUPTIONS INTO NUMERICS___________________________________.
*_____PREP SPONTANEOUS DATA FOR MERGE_______________________________________________.
*_____MERGE FILES AND CREATE COMBINED_______________________________________________.
      *_____CHECK THAT FILES MERGED PROPERLY________________________________________.
************************************************************************************.
***************** CORRELATIONS BETWEEN GAITMAT AND SPONTANEOUS *********************.
************************************************************************************.
*_____WITHIN CONDITIONS_____________________________________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND TOTAL WALKING_____________________________.
      *_____CORRELATIONS BETWEEN GAIT AND FALLS_____________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND STEPS PER BOUT____________________________.
            *_____TOTAL BOUTS_______________________________________________________.
            *_____PROPORTION OF BOUTS_______________________________________________.
*_____ACROSS CONDITIONS_____________________________________________________________.
      *_____AGGREGATE TO ONE ROW PER BABY___________________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND TOTAL WALKING_____________________________.
      *_____CORRELATIONS BETWEEN GAIT AND FALLS_____________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND STEPS PER BOUT____________________________.
            *_____TOTAL BOUTS_______________________________________________________.
            *_____PROPORTION OF BOUTS_______________________________________________.
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.



************************************************************************************.
***************** PREP FILES FOR MERGE *********************************************.
************************************************************************************.
*_____PREP GAIT DATA FOR MERGE______________________________________________________.
      *_____COMPUTE VARIABLES_______________________________________________________.

GET FILE=getGMFile.

*Create walk experience value, if not already done.
COMPUTE expwkdays=DATEDIFF(tday, wday, "days").
EXECUTE.
COMPUTE expwkmos=expwkdays/30.42.
EXECUTE.
VARIABLE LABELS expwkdays 'WalkExpDays'.
VARIABLE LABELS expwkmos 'WalkExpMonths'.

SELECT IF (stepl < 999).
EXECUTE.

COMPUTE leg=(legl+legr)/2.
EXECUTE.

      *_____RECODE GAIT DISRUPTIONS INTO NUMERICS___________________________________.

*Trips.
RECODE
  trip (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  trip#.
EXECUTE.

*Falls.
RECODE
  fall (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  fall#.
EXECUTE.

*Backsteps.
RECODE
  backstep (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  backstep#.
EXECUTE.

*Shortsteps.
RECODE
  shortstep (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  shortstep#.
EXECUTE.

*Doublesteps.
RECODE
  dblstep (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  dblstep#.
EXECUTE.

*Stops.
RECODE
  stop (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  stop#.
EXECUTE.

*Diaper touchs.
RECODE
  dprtch (CONVERT)
  ('.'=SYSMIS) ('n'=0)  ('1'=1)  ('2'=2)  ('3'=3)  ('4'=4)  ('5'=5)  ('6'=6)  ('7'=7)  ('8'=8)  ('9'=9)  ('10'=10)  (ELSE=999)  INTO
  dprtch#.
EXECUTE.

COMPUTE sumdisrupttype=SUM(trip#,fall#,stop#,shortstep#,backstep#,dblstep#).
EXECUTE.
COMPUTE sumdisruptnostop=SUM(trip#,fall#,shortstep#,backstep#,dblstep#).
EXECUTE.

AGGREGATE
 /OUTFILE=*
 /BREAK id agegroup condition trialnum
 /expwkdays=MEAN(expwkdays)
 /leg=MEAN(leg)
 /stepcount=N(stepcnt)
 /steplength=MEAN(stepl)
 /stepwidth=MEAN(stepwdt)
 /stridelength=MEAN(strl)
 /vel=MEAN(velocity)
 /base=MEAN(base)
 /trip#=MEAN(trip#)
 /fall#=MEAN(fall#)
 /stop#=MEAN(stop#)
 /shortstep#=MEAN(shortstep#)
 /backstep#=MEAN(backstep#)
 /dblstep#=MEAN(dblstep#)
 /sdsteplength=SD(stepl)
 /sdstepwidth=SD(stepwdt)
 /sdvel=SD(velocity)
 /sdbase=SD(base)
 /sumdisrupt=MEAN(sumdisrupttype)
 /sumdisruptnostop=MEAN(sumdisruptnostop).

*Aggregate to one row for each condition.
AGGREGATE
 /OUTFILE=*
 /BREAK id agegroup condition 
 /expgmat=MEAN(expwkdays)
 /leg=MEAN(leg)
 /stepcount=N(stepcount)
 /steplength=MEAN(steplength)
 /stepwidth=MEAN(stepwidth)
 /stridelength=MEAN(stridelength)
 /vel=MEAN(vel)
 /base=MEAN(base)
 /sdsteplength=MEAN(steplength)
 /sdstepwidth=MEAN(stepwidth)
 /ntrial=N(trialnum)
 /sdvel=MEAN(vel)
 /sdbase=MEAN(base)
 /trip#=SUM(trip#)
 /fall#=SUM(fall#)
 /stop#=SUM(stop#)
 /shortstep#=SUM(shortstep#)
 /backstep#=SUM(backstep#)
 /dblstep#=SUM(dblstep#) 
 /sumdisrupt=SUM(sumdisrupt)
 /sumdisruptnostop=SUM(sumdisruptnostop).

COMPUTE steplengthCoV=sdsteplength/steplength.
COMPUTE stepwidthCoV=sdstepwidth/stepwidth.
COMPUTE velCoV=sdvel/vel.
COMPUTE baseCoV=sdbase/base.
EXECUTE.

COMPUTE proptrip=trip#/ntrial.
COMPUTE propfall=fall#/ntrial.
COMPUTE propstop=stop#/ntrial.
COMPUTE propshortstep=shortstep#/ntrial.
COMPUTE propbackstep=backstep#/ntrial.
COMPUTE propdblstep=dblstep#/ntrial.
COMPUTE propsumdisrupt=sumdisrupt/ntrial.
COMPUTE propsumdisruptnostop=sumdisruptnostop/ntrial.
EXECUTE.

RECODE condition ('n'=0) ('p'=1) ('c'=2) INTO conditionnum.
EXECUTE.
RECODE agegroup (13=0) (19=1) INTO agegroup#.
EXECUTE.
SORT CASES BY agegroup# id condition.
EXECUTE.

SAVE OUTFILE='C:\Users\Whitney\Desktop\Diapers.GTemp.sav'.
SAVE OUTFILE=getGTFile.


*_____PREP SPONTANEOUS DATA FOR MERGE_______________________________________________.

GET FILE=getSMFile.

*Create spontaneous dataset to merge in gait data.
AGGREGATE
 /OUTFILE=*
 /BREAK= agegroup# id condition 
 /expspon=MEAN(expwkdays)
 /totalwalkdur = SUM (walkboutdur) /totalfalldur = SUM (fallboutdur) /totalwalkbouts = SUM(activitywalk) 
 /totalsteps# = SUM (steps#) /totalstepSingleton = SUM(stepsingleton) /totalstepsTwo = N(stepstwo) 
 /totalsteps3to5 = N(steps3to5) /totalsteps6to10 = N(steps6to10) /totalsteps11to15 = N(steps11to15)
 /totalsteps16to20 = N(steps16to20) /totalsteps21to25 = N(steps21to25) /totalsteps26to30 = N(steps26to30)
 /totalsteps31to35 = N(steps31to35) /totalsteps36to40 = N(steps36to40) /totalsteps41to45 = N(steps41to45)
 /totalsteps46to50 = N(steps46to50)
 /totalstepsGT10 = N(stepsGT10) /totalstepsGE20 = N(stepsGE20) /totalstepsGE40 = N(stepsGE40)
 /totalFall= SUM(activityfall) /totalrestdur= SUM(restdur).

RECODE condition ('n'=0) ('p'=1) ('c'=2) INTO conditionnum.
EXECUTE.

COMPUTE meansteps# = totalsteps#/totalwalkbouts.
COMPUTE fallRateSteps = totalFall/totalsteps#.
COMPUTE fallRateTime = totalFall/totalwalkdur.
COMPUTE cadence = totalsteps#/totalwalkdur.
COMPUTE propstepSingleton = totalstepSingleton/totalwalkbouts. 
COMPUTE propstepTwo = totalstepsTwo/totalwalkbouts.
COMPUTE propstepsGT10 = totalstepsGT10/totalwalkbouts.
COMPUTE propstepsGE20 = totalstepsGE20/totalwalkbouts.
COMPUTE propstepsGE40 = totalstepsGE40/totalwalkbouts.
COMPUTE propsteps3to5 = totalsteps3to5/totalwalkbouts.
COMPUTE propsteps6to10 = totalsteps6to10/totalwalkbouts.
COMPUTE propsteps11to15 = totalsteps11to15/totalwalkbouts.
COMPUTE propsteps16to20 = totalsteps16to20/totalwalkbouts.
COMPUTE propsteps21to25 = totalsteps21to25/totalwalkbouts.
COMPUTE propsteps26to30 = totalsteps26to30/totalwalkbouts.
COMPUTE propsteps31to35 = totalsteps31to35/totalwalkbouts.
COMPUTE propsteps36to40 = totalsteps36to40/totalwalkbouts.
COMPUTE propsteps41to45 = totalsteps41to45/totalwalkbouts.
COMPUTE propsteps46to50 = totalsteps46to50/totalwalkbouts.
EXECUTE.

SORT CASES BY agegroup# id condition.
EXECUTE.

SAVE OUTFILE='C:\Users\Whitney\Desktop\Diapers.STemp.sav'.
SAVE OUTFILE=getSTFile.

*_____MERGE FILES AND CREATE COMBINED_______________________________________________.

*Merge in gaitmat data - below is syntax for a local file.
MATCH FILES /FILE=*
  /FILE='C:\Users\Whitney\Desktop\Diapers.GTemp.sav'
  /BY agegroup# id condition.
EXECUTE.

*Merge in gaitmat data - below is syntax files on labdocs.
MATCH FILES /FILE=*
  /FILE='/Volumes/LABDOCS/StudiesCurrent/Diapers/Diapers/SPSS/Diapers.Gmat.Temp.sav'
  /BY agegroup# id condition.
EXECUTE.

SAVE OUTFILE='C:\Users\Whitney\Desktop\Diapers.Combined.sav'.
SAVE OUTFILE=getAFile.

      *_____CHECK THAT FILES MERGED PROPERLY________________________________________.

AGGREGATE
/OUTFILE=*
/BREAK agegroup# id
/dummy=MEAN(expgmat).
CROSSTABS
  /TABLES=id BY agegroup#
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.
*FREQUENCIES VARIABLES=condition
  /ORDER=ANALYSIS.


************************************************************************************.
***************** CORRELATIONS BETWEEN GAITMAT AND SPONTANEOUS *********************.
************************************************************************************.
*_____WITHIN CONDITIONS_____________________________________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND TOTAL WALKING_____________________________.

GET FILE=getAFile.

SORT CASES BY agegroup# condition.
SPLIT FILE BY agegroup# condition.
EXECUTE.

CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    base
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    vel
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Graphs of correlations with steplength.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH meansteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH cadence
  /MISSING=LISTWISE.
*Steplength has .46 or so correlation with totalwalkbouts in cloth and naked, marginal in pampers.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkbouts
  /MISSING=LISTWISE.

*Graphs of correlations with stepwidth.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH meansteps#
  /MISSING=LISTWISE.

*Graphs of correlations with base.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH meansteps#
  /MISSING=LISTWISE.

*Add velocity graphs here.

SPLIT FILE OFF.

      *_____CORRELATIONS BETWEEN GAIT AND FALLS_____________________________________.

GET FILE=getAFile.

SORT CASES BY agegroup# condition.
SPLIT FILE BY agegroup# condition.
EXECUTE.

*fallRateSteps has a couple sig correlations, not consistent across conditions. All other n.s.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    base
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    fall#
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

SPLIT FILE OFF.

      *_____CORRELATIONS BETWEEN GAIT AND STEPS PER BOUT____________________________.
            *_____TOTAL BOUTS_______________________________________________________.

GET FILE=getAFile.

SORT CASES BY agegroup# condition.
SPLIT FILE BY agegroup# condition.
EXECUTE.

CORRELATIONS
  /VARIABLES=totalstepSingleton totalstepsTwo totalsteps3to5 totalsteps6to10 totalsteps11to15 
totalsteps16to20 totalsteps16to20 totalsteps26to30 totalsteps31to35 totalsteps36to40 totalsteps41to45
totalsteps46to50 totalstepsGT10 totalstepsGE20 totalstepsGE40 stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalstepSingleton totalstepsTwo totalsteps3to5 totalsteps6to10 totalsteps11to15 
totalsteps16to20 totalsteps16to20 totalsteps26to30 totalsteps31to35 totalsteps36to40 totalsteps41to45
totalsteps46to50 totalstepsGT10 totalstepsGE20 totalstepsGE40 steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalsteps6to10
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalsteps16to20
  /MISSING=LISTWISE.

SPLIT FILE OFF.

            *_____PROPORTION OF BOUTS_______________________________________________.

GET FILE=getAFile.

SORT CASES BY agegroup# condition.
SPLIT FILE BY agegroup# condition.
EXECUTE.

CORRELATIONS
  /VARIABLES=propstepSingleton propstepTwo propsteps3to5 propsteps6to10 propsteps11to15 
propsteps16to20 propsteps21to25 propsteps26to30 propsteps31to35 propsteps36to40 propsteps41to45
propsteps46to50 propstepsGT10 propstepsGE20 propstepsGE40 steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=propstepSingleton propstepTwo propsteps3to5 propsteps6to10 propsteps11to15 
propsteps16to20 propsteps21to25 propsteps26to30 propsteps31to35 propsteps36to40 propsteps41to45
propsteps46to50 propstepsGT10 propstepsGE20 propstepsGE40 stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH propstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propsteps6to10
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propsteps16to20
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepsGT10
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepsGE20
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propsteps41to45
  /MISSING=LISTWISE.

CORRELATIONS
  /VARIABLES=propstepSingleton  stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
SPLIT FILE OFF.

      *_____AGGREGATE TO ONE ROW PER BABY___________________________________________.

GET FILE=getAFile.

AGGREGATE
 /OUTFILE=*
 /BREAK= agegroup# id  
 /expspon=MEAN(expspon)
 /totalwalkdur = MEAN (totalwalkdur) 
 /totalfalldur = MEAN (totalfalldur) 
 /totalwalkbouts = MEAN(totalwalkbouts) 
 /totalsteps# = MEAN (totalsteps#) 
 /totalstepSingleton = MEAN(totalstepSingleton) 
 /totalstepsTwo = MEAN(totalstepsTwo) 
 /totalsteps3to5 = MEAN(totalsteps3to5) 
 /totalsteps6to10 = MEAN(totalsteps6to10) 
 /totalsteps11to15 = MEAN(totalsteps11to15)
 /totalsteps16to20 = MEAN(totalsteps16to20) 
 /totalsteps21to25 = MEAN(totalsteps21to25) 
 /totalsteps26to30 = MEAN(totalsteps26to30)
 /totalsteps31to35 = MEAN(totalsteps31to35) 
 /totalsteps36to40 = MEAN(totalsteps36to40) 
 /totalsteps41to45 = MEAN(totalsteps41to45)
 /totalsteps46to50 = MEAN(totalsteps46to50)
 /totalstepsGT10 = MEAN(totalstepsGT10) 
 /totalstepsGE20 = MEAN(totalstepsGE20) 
 /totalstepsGE40 = MEAN(totalstepsGE40)
 /totalFall= MEAN(totalFall) 
 /totalrestdur= MEAN(totalrestdur)
 /meansteps# = MEAN(meansteps#)
 /fallRateSteps = MEAN(fallRateSteps)
 /fallRateTime = MEAN(fallRateTime)
 /cadence = MEAN(cadence)
 /propstepSingleton = MEAN(propstepSingleton)
 /propstepTwo = MEAN(propstepTwo)
 /propstepsGT10 = MEAN(propstepsGT10)
 /propstepsGE20 = MEAN(propstepsGE20)
 /propstepsGE40 = MEAN(propstepsGE40)
 /propsteps3to5 = MEAN(propsteps3to5)
 /propsteps6to10 = MEAN(propsteps6to10)
 /propsteps11to15 = MEAN(propsteps11to15)
 /propsteps16to20 = MEAN(propsteps16to20)
 /propsteps21to25 = MEAN(propsteps21to25)
 /propsteps26to30 = MEAN(propsteps26to30)
 /propsteps31to35 = MEAN(propsteps31to35)
 /propsteps36to40 = MEAN(propsteps36to40)
 /propsteps41to45 = MEAN(propsteps41to45)
 /propsteps46to50 = MEAN(propsteps46to50)
 /expgmat=MEAN(expgmat)
 /stepcount=N(stepcount)
 /steplength=MEAN(steplength)
 /stepwidth=MEAN(stepwidth)
 /stridelength=MEAN(stridelength)
 /vel=MEAN(vel)
 /base=MEAN(base).

*SAVE OUTFILE=getATFile.


*_____ACROSS CONDITIONS_____________________________________________________________.
      *_____AGGREGATE TO ONE ROW PER BABY___________________________________________.
      *_____CORRELATIONS BETWEEN GAIT AND TOTAL WALKING_____________________________.

GET FILE=getATFile.

SORT CASES BY agegroup# .
SPLIT FILE BY agegroup# .
EXECUTE.

CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    base
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    vel
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    expspon
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Graphs of correlations with steplength.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH meansteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH cadence
  /MISSING=LISTWISE.
*Steplength has .46 or so correlation with totalwalkbouts in cloth and naked, marginal in pampers.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkbouts
  /MISSING=LISTWISE.

*Graphs of correlations with stepwidth.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH meansteps#
  /MISSING=LISTWISE.

*Graphs of correlations with base.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH totalsteps#
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH totalwalkdur
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH meansteps#
  /MISSING=LISTWISE.

*Add velocity graphs here.
GRAPH
  /SCATTERPLOT(BIVAR)=vel WITH totalwalkbouts
  /MISSING=LISTWISE.

SPLIT FILE OFF.

      *_____CORRELATIONS BETWEEN GAIT AND FALLS_____________________________________.

GET FILE=getATFile.

SORT CASES BY agegroup# .
SPLIT FILE BY agegroup# .
EXECUTE.

*fallRateSteps has a couple sig correlations, not consistent across conditions. All other n.s.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    base
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalFall totalrestdur fallRateSteps fallRateTime totalfalldur 
    fall#
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

SPLIT FILE OFF.

*Scatterplot shows that correlation is due to one outlier.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH fallratesteps
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=base WITH fallratetime
  /MISSING=LISTWISE.

      *_____CORRELATIONS BETWEEN GAIT AND STEPS PER BOUT____________________________.
            *_____TOTAL BOUTS_______________________________________________________.

GET FILE=getATFile.

SORT CASES BY agegroup# .
SPLIT FILE BY agegroup# .
EXECUTE.

CORRELATIONS
  /VARIABLES=totalstepSingleton totalstepsTwo totalsteps3to5 totalsteps6to10 totalsteps11to15 
totalsteps16to20 totalsteps16to20 totalsteps26to30 totalsteps31to35 totalsteps36to40 totalsteps41to45
totalsteps46to50 totalstepsGT10 totalstepsGE20 totalstepsGE40 stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=totalstepSingleton totalstepsTwo totalsteps3to5 totalsteps6to10 totalsteps11to15 
totalsteps16to20 totalsteps16to20 totalsteps26to30 totalsteps31to35 totalsteps36to40 totalsteps41to45
totalsteps46to50 totalstepsGT10 totalstepsGE20 totalstepsGE40 steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

SPLIT FILE OFF.

            *_____PROPORTION OF BOUTS_______________________________________________.

GET FILE=getATFile.

SORT CASES BY agegroup# .
SPLIT FILE BY agegroup# .
EXECUTE.

CORRELATIONS
  /VARIABLES=propstepSingleton propstepTwo propsteps3to5 propsteps6to10 propsteps11to15 
propsteps16to20 propsteps21to25 propsteps26to30 propsteps31to35 propsteps36to40 propsteps41to45
propsteps46to50 propstepsGT10 propstepsGE20 propstepsGE40 steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=propstepSingleton propstepTwo propsteps3to5 propsteps6to10 propsteps11to15 
propsteps16to20 propsteps21to25 propsteps26to30 propsteps31to35 propsteps36to40 propsteps41to45
propsteps46to50 propstepsGT10 propstepsGE20 propstepsGE40 base
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepsGT10
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepsGE20
  /MISSING=LISTWISE.


CORRELATIONS
  /VARIABLES=propstepSingleton steplength stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH propstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepSingleton
  /MISSING=LISTWISE.
SPLIT FILE OFF.


####################################################################################.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalsteps#
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalsteps# steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkbouts
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalwalkbouts steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*Less interesting, not sure about these.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH cadence
  /MISSING=LISTWISE.
SPLIT FILE OFF.

***Step width.
SORT CASES BY agegroup# condition.
SPLIT FILE BY agegroup# condition.
EXECUTE.
CORRELATIONS
  /VARIABLES=totalsteps# totalstepSingleton totalwalkbouts totalwalkdur meansteps# cadence 
    stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Babies with higher width take fewer steps, only in 13-naked.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalsteps#
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalsteps# stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Step width and total singleton steps not correlated within each condition.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalstepSingleton
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalstepSingleton stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Step width and total walking bouts not correlated within conditions.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalwalkbouts
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalwalkbouts stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Babies with higher width have lower total walking time, but only in 13-naked.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH totalwalkdur
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=totalwalkdur stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Babies with higher width have lower meanstep#, in 13-naked and 13-pampers.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH meansteps#
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=meansteps# stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
*Cadence and width n.s. in all conditions.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH cadence
  /MISSING=LISTWISE.
CORRELATIONS
  /VARIABLES=cadence stepwidth
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*SPLIT FILE OFF.




SORT CASES BY agegroup# .
SPLIT FILE BY agegroup# .
EXECUTE.


CORRELATIONS
  /VARIABLES=totalsteps# totalwalkbouts totalwalkdur meansteps# cadence 
    steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH totalwalkbouts
  /MISSING=LISTWISE.

CORRELATIONS
  /VARIABLES=totalstepSingleton totalstepsTwo  stepwidth steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=propstepSingleton propstepTwo  stepwidth steplength
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=stepwidth WITH propstepSingleton
  /MISSING=LISTWISE.
GRAPH
  /SCATTERPLOT(BIVAR)=steplength WITH propstepSingleton
  /MISSING=LISTWISE.


AGGREGATE
  OUTFILE=*
  /BREAK id agegroup#
  /stepwidth=MEAN(stepwidth)
  /steplength=MEAN(steplength)
  /totwalkbouts=MEAN(totalwalkbouts)
  /propstepsingleton=MEAN(propstepsingleton)
  /meansteps#=MEAN(meansteps#).

SORT CASES BY agegroup#.
EXECUTE.
SPLIT FILE OFF.


