# # randomization scheme for experiment
trial_pic_ids <- sample(1:20, size = 2)
# Factors: difficulty, sign, model, rep
# difficulty
i <- sample(c(1:3, 1:3, 1:3, 1:3))
# neg / pos
j <- sample(c(1:2, 1:2, 1:2, 1:2, 1:2, 1:2))
# model
k <- sample(c(1:6, 1:6))
# rep
l <- sample(c(1:3, 1:3, 1:3, 1:3))
# goodness-of-fit plots to sample from
g <- sample(3:6, 1)
f <- sample(1:3, 1)
dat <- paste0(99,g,f)
# combine all 13 
pic_ids <- c(paste0(i,j,k,l), dat)[sample(13,13)]



##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
### Scratch work. 
# # models 
# LETTERS[1:6]
# 
# # sign 
# c("P", "N")
# 
# # difficulty
# c("E", "M", "H")
# 
# # All possible lineup combos
# 
# all <- expand.grid(models = LETTERS[1:6], sign = c("P", "N"), diff = c("E", "M", "H"))
# 
# lineupcodes <- apply( all , 1 , paste , collapse = "" )
# 
# # randomization scheme idea 1 
# Model <- c(LETTERS[1:6], sample(LETTERS[1:6], 4))[sample(10, 10)]
# 
# Sign <- rep(c("P", "N"), each = 5)[sample(10, 10)]
# 
# Diff <- c(rep(c("E", "M", "H"), each = 3), sample(c("E", "M", "H"), 1))
# 
# rep <- c(rep(1:3, each = 3), sample(1:3,1))[sample(10,10)]
# chosen_lus <- data.frame(Model, Sign, Diff, rep, stringsAsFactors = FALSE)
# 
# test_scheme <- list()
# for (i in 1:216){
#     Model <- c(1:6, 1:6)[sample(12,12)]
#     Sign <- rep(1:2, each = 6)[sample(12,12)]
#     Diff <- rep(1:3, each = 4)[sample(12,12)]
#     rep <- c(rep(1:3, each = 4))[sample(12,12)]
#     id <- paste0(Model, Sign, Diff, rep)
#     chosen_lus <- data.frame(Model, Sign, Diff, rep, id, stringsAsFactors = FALSE)
#     test_scheme[[i]] <- chosen_lus
# }
# 
# test_schemedf <- dplyr::bind_rows(test_scheme)
# 
# test_schemedf_summ <- test_schemedf %>% group_by(Model, Sign, Diff, rep) %>% summarise(n = n())
# 
# ggplot(data = test_schemedf_summ) + 
#     geom_tile(aes(x = Model, y = Diff, fill = n)) + 
#     geom_text(aes(x = Model, y = Diff, label = n)) + 
#     facet_grid(rep~Sign, labeller = 'label_both') + 
#     coord_fixed()
# 
# test_schemedf$code <- apply(test_schemedf[,1:3], 1, paste , collapse = "")
# 
# qplot(test_schemedf$code)
# 
# test_scheme2 <- list()
# # randomization scheme idea 2 
# for ( i in 1:1000){
#     see <- data.frame(code = sample(lineupcodes, 10), stringsAsFactors = F)
#     see$rep <- i
#     test_scheme2[[i]] <- see 
# } 
# test_scheme2df <- bind_rows(test_scheme2)
# qplot(test_scheme2df$code)
# 
# test_scheme2df <- test_scheme2df %>% mutate(Code = code) %>% separate(Code, into = c("Model", "Sign","Diff"), sep = c(1,2))
# 
# test_scheme2df_summ <- test_scheme2df %>% group_by(Model, Sign, Diff) %>% summarise(n = n())
# 
# mean(test_scheme2df_summ$n)
# mean(test_schemedf_summ$n)
# 
# bind_rows(test_scheme2df_summ %>% mutate(scheme = 2), test_schemedf_summ %>% mutate(scheme = 1)) %>% 
# ggplot() + 
#     geom_tile(aes(x = Model, y = Diff, fill = n)) + 
#     geom_text(aes(x = Model, y = Diff, label = n)) + 
#     facet_grid(scheme~Sign) + 
#     coord_fixed()
# 
# # from eric - FINAL SCHEME
# 
# # difficulty
# i <- sample(c(1:3, 1:3, 1:3, 1:3))
# 
# # neg / pos
# j <- sample(c(1:2, 1:2, 1:2, 1:2, 1:2, 1:2))
# 
# # model
# k <- sample(c(1:6, 1:6))
# 
# # rep
# l <- sample(c(1:3, 1:3, 1:3, 1:3))
# 
# # Pic IDs to use
# pic_ids <- as.numeric(paste0(i, j, k, l))
# 
# test_scheme3 <- list()
# for(r in 1:252){
#     # difficulty
#     i <- sample(c(1:3, 1:3, 1:3, 1:3))
#     # neg / pos
#     j <- sample(c(1:2, 1:2, 1:2, 1:2, 1:2, 1:2))
#     # model
#     k <- sample(c(1:6, 1:6))
#     # rep
#     l <- sample(c(1:3, 1:3, 1:3, 1:3))
#     # Pic IDs to use
#     pic_ids <- as.numeric(paste0(i, j, k, l))
#     test_scheme3[[r]] <- data.frame(diff = i, sign = j, mod = k, rep = l, id = pic_ids)
# }
# 
# test_scheme3df <- bind_rows(test_scheme3)
# test_scheme3df_summ <- test_scheme3df %>% group_by(diff, sign, mod, rep) %>% summarise(n = n())
# ggplot(data = test_scheme3df_summ) +
#     geom_tile(aes(x = mod, y = diff, fill = n)) +
#     geom_text(aes(x = mod, y = diff, label = n)) +
#     facet_grid(sign~rep, labeller = "label_both")
# qplot(as.factor(test_scheme3df$id))
# 
# all <- expand.grid(diff =1:3, sign = 1:2, mod = 1:6,  rep = 1:3)
# 
# all$lineupcodes <- apply( all , 1 , paste , collapse = "" )
# 
# 
# test_scheme4 <- list()
# for(r in 1:240){
#     # Pic IDs to use
#     pic_ids <- sample(all$lineupcodes, 12)
#     
#     test_scheme4[[r]] <- data.frame(diff = substr(pic_ids, 1, 1), 
#                                     sign = substr(pic_ids, 2, 2),
#                                     mod = substr(pic_ids, 3, 3), rep = substr(pic_ids, 4, 4), 
#                                     id = pic_ids, stringsAsFactors = FALSE)
# }
# test_scheme4df <- bind_rows(test_scheme4)
# test_scheme4df_summ <- test_scheme4df %>% group_by(diff, sign, mod, rep) %>% summarise(n = n())
# ggplot(data = test_scheme4df_summ) + 
#     geom_tile(aes(x = mod, y = diff, fill = n)) + 
#     geom_text(aes(x = mod, y = diff, label = n)) +
#     facet_grid(sign~rep, labeller = "label_both")
