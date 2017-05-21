
teams <- c("BOS", "BKN", "NYK", "PHI", "TOR", "CHI", "CLE", "DET", "IND", "MLE", "ATL", "CHA", "MIA", "ORL", "WAS", "DAL", "HOU", "MEM", "NOR", "SAS", "DEN", "MIN", "OKC", "POR", "UTA", "GSW", "LAC", "LAL", "PHX", "SAC")




DET_TOR_tor <- as.data.frame(read.csv("C:/Projects/bballsim/data/boxscores/DET-TOR_tor.csv", row.names=NULL))
colnames(DET_TOR_tor)[21] <- "plusmin"

DET_TOR_det <- as.data.frame(read.csv("C:/Projects/bballsim/data/boxscores/DET-TOR_det.csv", row.names=NULL))
colnames(DET_TOR_det)[21] <- "plusmin"

CLE_TOR_tor <- as.data.frame(read.csv("C:/Projects/bballsim/data/boxscores/CLE-TOR_tor.csv", row.names=NULL))
colnames(CLE_TOR_tor)[21] <- "plusmin"

CLE_TOR_cle <- as.data.frame(read.csv("C:/Projects/bballsim/data/boxscores/CLE-TOR_cle.csv", row.names=NULL))
colnames(CLE_TOR_cle)[21] <- "plusmin"


DET_TOR_det$XPTS <-as.numeric(as.character(DET_TOR_det[,20]))
DET_TOR_tor$XPTS <-as.numeric(as.character(DET_TOR_tor[,20]))

CLE_TOR_cle$XPTS <-as.numeric(as.character(CLE_TOR_cle[,20]))
CLE_TOR_tor$XPTS <-as.numeric(as.character(CLE_TOR_tor[,20]))
#DET_TOR_det$XPTS[14] < DET_TOR_tor$XPTS[14]


