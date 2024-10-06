## ----setup_knitr, include=FALSE, cache=FALSE-------------------------------
library(knitr)
library(DRIMSeq)
opts_chunk$set(cache = FALSE, warning = FALSE, out.width = "7cm", fig.width = 7, out.height = "7cm", fig.height = 7)
library(PasillaTranscriptExpr)
#data_dir  <- system.file("extdata", package = "PasillaTranscriptExpr")

dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")



input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
    pfix = prefix()
  if (length(pfix) != 0) {
     pfix <<- paste(pfix, "/", sep="")
  }
}

run <- function() {}

output <- function(outputfile) {
pasilla_counts <- read.table(paste(pfix, parameters["counts", 2], sep="/"), 
  header = TRUE, as.is = TRUE)
pasilla_metadata <- read.table(paste(pfix, parameters["metadata", 2], sep="/"),
  header = TRUE, as.is = TRUE)
gene_id_subset <- readLines(paste(pfix, parameters["gene_id", 2], sep="/"))
pasilla_samples <- data.frame(sample_id = pasilla_metadata$SampleName, 
  group = pasilla_metadata$condition)
d <- dmDSdata(counts = pasilla_counts, samples = pasilla_samples)
d <- d[names(d) %in% gene_id_subset, ]
d <- dmFilter(d, min_samps_gene_expr = 7, min_samps_feature_expr = 3,
  min_gene_expr = 10, min_feature_expr = 10)

saveRDS(d, outputfile)

}

