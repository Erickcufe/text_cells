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
