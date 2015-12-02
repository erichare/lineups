library(RSQLite)

trial_pic_ids <- sample(1:20, size = 2)

con <- dbConnect(SQLite(), dbname = "data/turk.db")

poss_ids <- dbGetQuery(con, paste0("SELECT DISTINCT pic_id FROM picture_details WHERE experiment = '", "turk19", "' AND trial = ", 0))[,1]

modded <- as.character(poss_ids %% 100)
modded[nchar(modded) == 1] <- paste0(0, modded[nchar(modded) == 1])

j <- sample(c(0:3, 0:3, 0:3))
k <- sample(c(0:4, 0:4, 4, 4))

ids <- lapply(paste0(j, k), function(ind) {
    which(ind == modded)
})

pic_ids <- NULL
for (i in 1:length(ids)) {
    candidates <- poss_ids[ids[[i]]]
    
    candidates <- candidates[candidates %/% 100 %in% setdiff(candidates %/% 100, pic_ids %/% 100)]
    pic_ids <- c(pic_ids, sample(candidates, 1))
}
