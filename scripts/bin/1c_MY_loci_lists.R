####################################
### Generation of sequence lists ###
####################################

# load config
if (!(exists("config_file"))) {config_file <- "./config.txt"}
source(config_file)

# load packages
library(ape)
library(seqinr)
library(stringr)

if(name_for_dataset_optimization_subset != ""){
  folder_subset_add <- paste("_",name_for_dataset_optimization_subset, sep="")
} else {
  folder_subset_add <- ""
} 

output_Robjects <- file.path(path_to_output_folder,"00_R_objects", name_for_dataset_optimization_subset)
output_sequences <- file.path(path_to_output_folder,paste("03_sequence_lists", folder_subset_add, sep=""))

if(intronerated_contig=="yes"){
  intronerated_name <- "intronerated" 
  intronerated_underscore <- "_"
} else {
  intronerated_name <- ""
  intronerated_underscore <- ""
}

targets <- read.fasta(fasta_file_with_targets, as.string=TRUE, set.attributes = FALSE)
targets_name <- unique(gsub(".*-","",labels(targets)))
samples <- readLines(path_to_namelist)


outsamples_missing <- readRDS(file=file.path(output_Robjects,"outsamples_missing.Rds"))
outloci_missing <- readRDS(file=file.path(output_Robjects,"outloci_missing.Rds"))
outloci_para_all <- readRDS(file=file.path(output_Robjects,"outloci_para_all.Rds"))
outloci_para_each <- readRDS(file=file.path(output_Robjects,"outloci_para_each.Rds"))
tab_snps_cl2b <- readRDS(file=file.path(output_Robjects,"Table_SNPs_cleaned.Rds"))

tab_snps <- as.matrix(tab_snps_cl2b)
loci <- t(tab_snps)
failed_loci <- which(colSums(is.na(loci))==nrow(loci))
failed_samples <- which(colSums(is.na(tab_snps))==nrow(tab_snps))


#############################################

folder4seq_consensus_loci <- file.path(output_sequences,"loci_consensus")
folder4seq_consensus_samples <- file.path(output_sequences,"samples_consensus")
folder4seq_contig_loci <- file.path(output_sequences,"loci_contigs")
folder4seq_contig_samples <- file.path(output_sequences,"samples_contigs")


unlink(c(folder4seq_consensus_loci, folder4seq_consensus_samples,  folder4seq_contig_loci, folder4seq_contig_samples),recursive = T) # delete directory, if it existed in order to prevent errors

dir.create(output_sequences, showWarnings = F)
dir.create(folder4seq_consensus_loci, showWarnings = F)
dir.create(folder4seq_consensus_samples, showWarnings = F)
dir.create(folder4seq_contig_loci, showWarnings = F)
dir.create(folder4seq_contig_samples, showWarnings = F)



print("start loci")


#########################################################################
### concatenate consensus files across all samples to lists per locus ###
#########################################################################
# this extracts sequences from all subfolders in the HybPiper folder and collates them into one file per locus


# if you are on Linux, then the bash commands cat and sed are used. If not, then R file operations are used, which are slower

if(Sys.info()['sysname']=="Linux"){
  if(intronerated_contig=="yes"){

# FOR LOOP FOR LOCI

    for(locus in targets_name){

print(locus)

      command_cat_consensus <- paste("cat",file.path(path_to_output_folder,"01_data/*/intronerated_consensus/",paste(locus,"_intronerated.fasta",sep="")),">",file.path(folder4seq_consensus_loci,paste(locus,"_intronerated_consensus.fasta",sep="")))
      system(command_cat_consensus, ignore.stderr = TRUE)
      command_cat_contig <- paste("cat",file.path(path_to_output_folder,"01_data/*/intronerated_contigs/",paste(locus,"_intronerated.fasta",sep="")),">",file.path(folder4seq_contig_loci,paste(locus,"_intronerated_contig.fasta",sep="")))
      system(command_cat_contig, ignore.stderr = TRUE)
      command_remove_locus_in_seqnames_consensus <- (paste("sed -i 's/-",locus,"//g' ", file.path(folder4seq_consensus_loci,paste(locus,"_intronerated_consensus.fasta",sep="")), sep=""))
      system(command_remove_locus_in_seqnames_consensus) 
      command_remove_locus_in_seqnames_contig <- (paste("sed -i 's/-",locus,"//g' ", file.path(folder4seq_contig_loci,paste(locus,"_intronerated_contig.fasta",sep="")), sep=""))
      system(command_remove_locus_in_seqnames_contig)
    }

# TO HERE

  } else {
    for(locus in targets_name){
      command_cat_consensus <- paste("cat",file.path(path_to_output_folder,"01_data/*/consensus/",paste(locus,".fasta",sep="")),">",file.path(folder4seq_consensus_loci,paste(locus,"_consensus.fasta",sep="")))
      command_cat_contig    <- paste("cat",file.path(path_to_output_folder,"01_data/*/contigs/",paste(locus,".fasta",sep="")),">",file.path(folder4seq_contig_loci,paste(locus,"_contig.fasta",sep="")))
      system(command_cat_consensus, ignore.stderr = TRUE)
      system(command_cat_contig, ignore.stderr = TRUE)
      command_remove_locus_in_seqnames_consensus <- (paste("sed -i 's/-",locus,"//g' ", file.path(folder4seq_consensus_loci,paste(locus,"_consensus.fasta",sep="")), sep=""))
      command_remove_locus_in_seqnames_contig <- (paste("sed -i 's/-",locus,"//g' ", file.path(folder4seq_contig_loci,paste(locus,"_contig.fasta",sep="")), sep=""))
      system(command_remove_locus_in_seqnames_consensus)
      system(command_remove_locus_in_seqnames_contig)
    } 
  }  
} else {
  if(intronerated_contig=="yes"){
    for(locus in targets_name){
      #list all fasta files from that locus for all samples
      fasta_files <- list.files(path=file.path(path_to_output_folder,"01_data/"), pattern=paste(locus,"_intronerated.fasta",sep=""), recursive=TRUE, full.names = TRUE)
      #select consensus/contig files
      consensus_files <- grep("consensus",fasta_files,value = TRUE)
      contigs_files <- grep("contigs",fasta_files,value = TRUE)
      #define output files
      output_file_consensus <- file.path(folder4seq_consensus_loci,paste(locus,"_intronerated_consensus.fasta",sep=""))
      output_file_contigs <- file.path(folder4seq_contig_loci,paste(locus,"_intronerated_contigs.fasta",sep=""))
      #generate output files
      file.create(output_file_consensus, overwrite=TRUE)
      file.create(output_file_contigs, overwrite=TRUE)
      #append sample fastas to the empty output file
      file.append(output_file_consensus,consensus_files)
      file.append(output_file_contigs,contigs_files)
      #read lines of each file and remove the "-locus" of the sequence names
      lines_consensus <- gsub(paste("-",locus,sep=""),"",readLines(output_file_consensus))
      lines_contigs <- gsub(paste("-",locus,sep=""),"",readLines(output_file_contigs))
      #write lines into files
      write(lines_consensus, file=output_file_consensus)
      write(lines_contigs, file=output_file_contigs)
    }
  } else {
    for(locus in targets_name){
      #list all fasta files from that locus for all samples
      fasta_files <- list.files(path=file.path(path_to_output_folder,"01_data/"), pattern=paste(locus,".fasta",sep=""), recursive=TRUE, full.names = TRUE)
      #select consensus/contig files
      consensus_files <- grep("consensus",fasta_files,value = TRUE)
      contigs_files <- grep("contigs",fasta_files,value = TRUE)
      #define output files
      output_file_consensus <- file.path(folder4seq_consensus_loci,paste(locus,"_consensus.fasta",sep=""))
      output_file_contigs <- file.path(folder4seq_contig_loci,paste(locus,"_contigs.fasta",sep=""))
      #generate output files
      file.create(output_file_consensus, overwrite=TRUE)
      file.create(output_file_contigs, overwrite=TRUE)
      #append sample fastas to the empty output file
      file.append(output_file_consensus,consensus_files)
      file.append(output_file_contigs,contigs_files)
      #read lines of each file and remove the "-locus" of the sequence names
      lines_consensus <- gsub(paste("-",locus,sep=""),"",readLines(output_file_consensus))
      lines_contigs <- gsub(paste("-",locus,sep=""),"",readLines(output_file_contigs))
      #write lines into files
      write(lines_consensus, file=output_file_consensus)
      write(lines_contigs, file=output_file_contigs)
    } 
  }  
}

print("DONE WITH LOCI, de-inerleaving")

# changing interleaved HybPiper files to non-interleaved fasta files
for(file in list.files(folder4seq_contig_loci, full.names = T)){
  file <- list.files(folder4seq_contig_loci, full.names = T)[3]
  lines <- readLines(file)
  conx <- file(file)
  writeLines(str_split(paste(gsub("(>.*)",":\\1:",lines),collapse =""), pattern = ":")[[1]][-1], conx)
  close(conx)
}

print("DONE!")
