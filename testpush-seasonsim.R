install.packages("abind")
library(abind)

#create dataframe 'standings' with team names and zeros for Wins/Losses
zeros <- rep(0, 30)
teams <- c("BOS", "BKN", "NYK", "PHI", "TOR", "CHI", "CLE", "DET", "IND", "MLE", "ATL", "CHA", "MIA", "ORL", "WAS", "DAL", "HOU", "MEM", "NOR", "SAS", "DEN", "MIN", "OKC", "POR", "UTA", "GSW", "LAC", "LAL", "PHX", "SAC")
ppg <- c(106.8, 105.3, 107.5, 105.8, 102.3, 110.7, 101.9, 104.3, 104.8, 101.5, 109.1, 103.7, 104.9, 102.9, 100.0, 116.2, 107.7, 104.3, 103.1, 107.4, 104.9, 108.1, 111.2, 106.8, 100.5, 106.5, 115.4, 101.4, 98.0, 103.3)

#sdppg <- rep(10, 30)

standings <- data.frame(team=teams, W=zeros, L=zeros,stringsAsFactors=FALSE)



#dataframe team_pts (ppg and oppg for each team) is generated in import_team_pts.R

#could put reading in box scores as function, then you can use team1 and team2 for each game, rather than having
#to type "DET" and "TOR each time

#could number the games (game1, game2 game3). make a loop that runs winloss so that it feeds in boxscores
#according to the game number. standings will then be updated for mulitple games

#fix - using a data frame for ppg, a matrix for stdevs
score_sim <- function(rt, ht) {

  htppg <- rnorm(1, mean=teams_pts[which(teams_pts$team==ht), 2], sd=pts.sd[ht, 1])
  htoppg <- rnorm(1, mean=teams_pts[which(teams_pts$team==ht), 3], sd=pts.sd[ht, 2])
  rtppg <- rnorm(1, mean=teams_pts[which(teams_pts$team==rt), 2], sd=pts.sd[rt, 1])
  rtoppg <- rnorm(1, mean=teams_pts[which(teams_pts$team==rt), 3], sd=pts.sd[rt, 2])
  htpts <- (htppg+rtoppg)/2+1.5
  rtpts <- (rtppg+htoppg)/2-1.5
 # rm(htppg, htoppg, rtppg, rtoppg)
  score <- list(rt, rtpts, ht, htpts)
  assign("score", score, envir=.GlobalEnv)
  assign('htpts',htpts,envir=.GlobalEnv) 
  assign('rtpts',rtpts,envir=.GlobalEnv)
  rm(htppg, htoppg, rtppg, rtoppg)
}

score_sim("TOR", "BOS")

winloss <- function(rtname, htname, rtscore, htscore){
  if(rtscore>htscore) {
    standings[which(standings$team==rtname), 2] = standings[which(standings$team==rtname), 2] +1
    standings[which(standings$team==htname), 3] = standings[which(standings$team==htname), 3] +1
  } else {
    standings[which(standings$team==rtname), 3] = standings[which(standings$team==rtname), 3] +1
    standings[which(standings$team==htname), 2] = standings[which(standings$team==htname), 2] +1
  }
  standings <- standings[order(-standings$W, standings$L),]
  assign('standings',standings,envir=.GlobalEnv)    
}


#next step would be to populate schedule with boxscore table info, as it comes in, and update point differential.
#df 'schedule' is created in import_1617_schedule.R




seasons.list <- list()
for (i in 1:20) {
  standings <- data.frame(team=teams, W=zeros, L=zeros,stringsAsFactors=FALSE)  #reset standings
  for (i in 1:nrow(schedule)) {
    score_sim(schedule[i, "rtname"], schedule[i, "htname"])
    # print(score) 
    winloss(schedule[i, "rtname"], schedule[i, "htname"], rtpts, htpts)
  }
  seasons.list[[length(seasons.list)+1]] <- standings
  #df.matrix(standings)
  rm(htpts, rtpts, score)
}




avg.record <- data.frame(team=teams, W=zeros, L=zeros,stringsAsFactors=FALSE)
for (tm in teams) {
  totw=0
  totl=0
    for (i in 1:length(seasons.list)) {
    totw = totw + seasons.list[[i]][which(seasons.list[[i]]$team==tm), 2]
    totl = totl + seasons.list[[i]][which(seasons.list[[i]]$team==tm), 3]    
  }
  avg.record[which(avg.record$team==tm), 2] = totw/length(seasons.list)
  avg.record[which(avg.record$team==tm), 3] = totl/length(seasons.list)  
  rm(totw, totl)
}

avg.record <- avg.record[order(-avg.record$W, avg.record$L),]



#trying to run standings mulitple timems, add them to list or array, then get avg wins from many season sims
#for some reasons, standings are always in same order, but diff# of wins
#probably wins/loss are different, but row names are in consistent order






#test section

winloss("DET", "TOR", 63, 75)

score_sim("TOR", "BOS")



#may need to put matrix in consistent order of teams, so when put in array, each team is in same row
#remove for now - put in list first
#seasons.array <- array(data=NA, dim=c(30, 2, 1))
#df.matrix <- function(x) {
#  tab <- as.matrix(subset(x, select=c(W, L)), rownames.force=NA)
#  rownames(tab) <- x$team
#  temparray <- array(data=x)
#  seasons.array <- abind(seasons.array, tab, along=3)
#  assign("seasons.array", seasons.array, envir=.GlobalEnv)
#}

#df.matrix(standings)
#sim - use ppg at home vs ppg on the road - 8 data points to run simulation
#then modify for b2b, 3 in 4 nights, etc.

#simulate seasons. add players, use ws/48 to get off/def ratings, then sim each game. 
#have players trend in different directions during the season
#use machine learning to have teams make decsision about minutes (rotatins?), and trades
#put in salaries/salaraycap and CBA. teamsAI decide if they want to make trades