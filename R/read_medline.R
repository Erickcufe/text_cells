read_medline <- function(text, key1 = "PMID-", key2 = "AB  -"){
  a <- vector()
  for (i in 1:length(text)){
    if (text[i]==""){
      a <- c(a, i)
    }
  }
  b <- 1
  data_list <- list()
    for (i in 1:length(a)){
    c <- a[i]
    data_list[[i]] <- text[b:c]
    b <- c+1
  }
  list_text <- data_list
  mydf <- data.frame()
  for (i in 1:length(list_text)){
    for (j in 1:length(list_text[[i]])){
      if (stringr::str_detect(list_text[[i]][j], key1)){
        tmp <- strsplit(list_text[[i]][j], " ")
        text_tidy <- data.frame(PMID=tmp[[1]][2])
        next
      }
      if (stringr::str_detect(list_text[[i]][j], key2)){
        for (l in j:length(list_text[[i]])){
          if (!stringr::str_detect(list_text[[i]][l], "FAU -") &
              !stringr::str_detect(list_text[[i]][l], "CI  -") &
              !stringr::str_detect(list_text[[i]][l], "AU  -")){
            next
          } else {
            tmp_1 <- paste(list_text[[i]][j:l], collapse = "")
            tmp_2 <- strsplit(tmp_1, " - ")
            text_tidy1 <- data.frame(AB = tmp_2[[1]][2])
          }
        }
      }
    }
    df <- cbind(text_tidy, text_tidy1)
    mydf <- rbind(mydf, df)
    mydf <- mydf[!duplicated(mydf$AB),]
  }
  return(mydf)
}
