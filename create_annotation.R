## ---------------------------
##
## Script name: create_annotation
##
## Purpose of script:parse a gencode gtf file and create a readable annotation file
##
## Author: Upasana Nepal
##
## Date Created: 2024-01-05
##
## Email: upasana.nepal2@gmail.com
##
## ---------------------------
##
## Notes: Download gtf file from gencode website for input
##      : Output contains gene type, gene name and Ensembl ID
##
## ---------------------------

#read the annotation file
annotation <- read.csv("gencode.v44.chr_patch_hapl_scaff.annotation.gtf", skip= 5, sep = "\t", header = F)
annotation <- annotation[annotation$V3 %in% c("exon", "gene","transcript"),]

# function to extract all attributes from a gtf files
extract_attributes <- function(gtf_attributes, att_of_interest){
  att <- strsplit(gtf_attributes, "; ")
  att <- gsub("\"","",unlist(att))
  if(!is.null(unlist(strsplit(att[grep(att_of_interest, att)], " ")))){
    return( unlist(strsplit(att[grep(att_of_interest, att)], " "))[2])
  }else{
    return(NA)}
}

annotation$gene_id <- unlist(lapply(annotation$V9, extract_attributes, "gene_id"))
annotation$gene_type <- unlist(lapply(annotation$V9, extract_attributes, "gene_type"))
annotation$gene_name <- unlist(lapply(annotation$V9, extract_attributes, "gene_name"))
annotation$chr <- annotation$V1

write.csv(annotation, "annotation_filtered.csv")
