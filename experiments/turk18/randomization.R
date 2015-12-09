library(RSQLite)

trial_pic_ids <- sample(1:10, size = 2)

con <- dbConnect(SQLite(), dbname = "data/turk.db")

poss_ids <- dbGetQuery(con, paste0("SELECT DISTINCT pic_id FROM picture_details WHERE experiment = '", "turk18", "' AND trial = ", 0))[,1]

i <- sample(0:1, size = 1)
j <- sample(seq(1, 287, by = 2), size = 5)
k <- sample(seq(2, 288, by = 2), size = 5)

if (i == 0) pic_ids <- c(j, k) else pic_ids <- c(k, j)

dbDisconnect(con)
