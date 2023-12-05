library(dplyr)

save_rds_to_csv <- function() {
  dirs <- list.dirs(path="results")

  for (dir in dirs) {
    files <- list.files(path = dir, pattern="*.rds")
    for (f in files) {
      f_in <- file.path(dir, f)
      print(f_in)
      x1 <- readRDS(f_in)
      ct_des <- lapply(x1, function(x) {if(is.list(x)){x[["ct_des"]]} else {NULL}}) %>% dplyr::bind_rows()
      ch <- lapply(x1, function(x) {if(is.list(x)){x[["ch"]]} else {NULL}}) %>% dplyr::bind_rows()
      f_out <- file.path(dir, stringr::str_sub(f, end = -5))
      print(f_out)
      readr::write_csv(ct_des, file = paste0(f_out, "_ct_des.csv"))
      readr::write_csv(ch, file = paste0(f_out, "_ch.csv"))
    }
  }
}

save_rds_to_csv()
