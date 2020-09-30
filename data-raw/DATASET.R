## code to prepare `DATASET` dataset goes here

# Filters: HUMAN, ABSTRACT, JOURNAL ARTICLE. 28-09-2020
# Search : cell-type AND dementia
# Neuron only 10,000 PMID of 26,000 was selected

# Oligodendrocyte

odp <- readLines("pubmed-Oligodendr_ODP-set.txt")
oligo1 <- read_medline(odp)
oligo <- readLines("pubmed-oligodendr-set.txt")
oligo2 <- read_medline(oligo)
oligodendrocyte <- rbind(oligo1, oligo2)
oligodendrocyte <- oligodendrocyte[!duplicated(oligodendrocyte$PMID),]
usethis::use_data(oligodendrocyte, overwrite = TRUE)

astro <- readLines("pubmed-astrocyteA-set.txt")
astrocyte <- read_medline(astro)
usethis::use_data(astrocyte, overwrite = TRUE)

micro <- readLines("pubmed-microgliaA-set.txt")
microglia <- read_medline(micro)
usethis::use_data(microglia, overwrite = TRUE)

neu <- readLines("pubmed-neuronANDd-set.txt")
neuron <- read_medline(neu)
usethis::use_data(neuron, overwrite = TRUE)

endo <- readLines("pubmed-endothelia-set.txt")
endothelial <- read_medline(endo)
usethis::use_data(endothelial, overwrite = TRUE)


astrocyte$Class <- "Astrocyte"
neuron$Class <- "Neuron"
microglia$Class <- "Microglia"
endothelial$Class <- "Endothelial"
oligodendrocyte$Class <- "Oligodendrocyte"

cells <- rbind(astrocyte, neuron, microglia,
               endothelial, oligodendrocyte)
usethis::use_data(cells, overwrite = TRUE)

prueba <- cbind(astrocyte$PMID, endothelial$PMID,
                microglia$PMID, neuron$PMID,
                oligodendrocyte$PMID)
a <- astrocyte$PMID
m <- microglia$PMID
e <- endothelial$PMID
ne <- neuron$PMID
o <- oligodendrocyte$PMID

n <- max(length(a), length(e),
         length(m), length(ne),
         length(o))

length(a) <- n
length(m) <- n
length(e) <- n
length(ne) <- n
length(o) <- n

VENN <- cbind(astrocyte = a, microglia = m,
              endothelial = e, neuron = ne,
              oligodendrocyte = o)

for (i in 1:ncol(VENN)){
  is.na_replace_blanck <- VENN[,i]
  is.na_replace_blanck[is.na(is.na_replace_blanck)] <- ""
  VENN[,i] <- is.na_replace_blanck
}

VENN <- data.frame(VENN)

ASOC <- list(Ast= VENN[VENN$astrocyte!="",1],
             Micro=VENN[VENN$microglia!="",2],
             Endo=VENN[VENN$endothelial!="",3],
             Neu=VENN[VENN$neuron!="",4],
             Oligo=VENN[VENN$oligodendrocyte!="",5])

VennDiagram::venn.diagram(ASOC, filename = "VennDiagram.png", col="transparent",
                          fill= c("#730CBB", "#F7C422", "#C049E6", "#13B7B3", "#13B725"),
                          cex = 2,compression ="lzw",
                          alpha= 0.7, resolution = 300)

# Obtenemos los PMID unicos de cada grupo
aver <- VennDiagram::get.venn.partitions(ASOC,
                                         force.unique = T,
                                         keep.elements = T,
                                         hierarchical = F)
Astrocyte_unicos <- data.frame(aver[31,7])
colnames(Astrocyte_unicos) <- "PMID"

Endothelial_unicos <- data.frame(aver[28,7])
colnames(Endothelial_unicos) <- "PMID"

Neuron_unicos <- data.frame(aver[28,7])
colnames(Neuron_unicos) <- "PMID"

Microglia_unicos <- data.frame(aver[24,7])
colnames(Microglia_unicos) <- "PMID"

Oligodendrocyte_unicos <- data.frame(aver[16,7])
colnames(Oligodendrocyte_unicos) <- "PMID"

astrocytes_final <- astrocyte[astrocyte$PMID %in% Astrocyte_unicos$PMID,]
endothelial_final <- endothelial[endothelial$PMID %in% Endothelial_unicos$PMID,]
neuron_final <- neuron[neuron$PMID %in% Neuron_unicos$PMID,]
microglia_final <- microglia[microglia$PMID %in% Microglia_unicos$PMID,]
oligodendrocyte_final <- oligodendrocyte[oligodendrocyte$PMID %in% Oligodendrocyte_unicos$PMID,]

neuron_final_1000 <- neuron_final[neuron_final$PMID %in% sample(neuron_final$PMID, 1000),]
neuron_test <- neuron_final[!(neuron_final$PMID %in% neuron_final_1000$PMID),]

astrocyte_1000 <- astrocytes_final[astrocytes_final$PMID %in% sample(astrocytes_final$PMID, 1000),]
astro_test <- astrocytes_final[!(astrocytes_final$PMID %in% astrocyte_1000$PMID),]

endo_1000 <- endothelial_final[endothelial_final$PMID %in% sample(endothelial_final$PMID, 1000),]
endo_test <- endothelial_final[!(endothelial_final$PMID %in% endo_1000$PMID),]

micro_1000 <- microglia_final[microglia_final$PMID %in% sample(microglia_final$PMID, 1000),]
micro_test <- microglia_final[!(microglia_final$PMID %in% micro_1000$PMID),]



Datatrain_beforeWEKA_4clases <- rbind(astrocyte_1000, endo_1000,
                            neuron_final_1000, micro_1000)
usethis::use_data(Datatrain_beforeWEKA_4clases, overwrite = TRUE)

Datatest_beforeWEKA_4clases <- rbind(astro_test, endo_test, micro_test,
                                     neuron_test)
usethis::use_data(Datatest_beforeWEKA_4clases, overwrite = TRUE)

foreign::write.arff(Datatrain_beforeWEKA_4clases, "cells_pre4classes.arff")

# IDFTransform = TRUE
# TFTransform = TRUE
# lowerCaseTokens = TRUE
# minTermFreq = 50
# normalizeDocLength = Normalize all data
# ouputWordCounts = TRUE
# stemmer = SnowballStemmer -English
# stopwordsHandler = Rainbow
# tokenizer = WordTokenizer -delimiters .,;:'"()?!
# WordToKeep = 1000
# Filter Normalize
# Save from WEKA to R

data_afterWEKA_4Classes <- read.csv("cells_afteWEKA4classes.csv")
usethis::use_data(data_afterWEKA, overwrite = TRUE)

# FALTA EQUILIBRAR LAS CLASES
# SE PODRIAN QUITAR 7100 PMID DE NEURON, O DEJAR TODAS EN MIL, Y
# HACER UN INTENTO CON 5 CLASES Y 4 CLASES, CON 1000 INSTANCIAS CADA CLASE




