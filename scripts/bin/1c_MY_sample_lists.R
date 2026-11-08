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

folder_subset_add <- ""

output_sequences <- file.path(path_to_output_folder,paste("03_sequence_lists", folder_subset_add, sep=""))

folder4seq_consensus_loci <- file.path(output_sequences,"loci_consensus")
folder4seq_consensus_samples <- file.path(output_sequences,"samples_consensus")
folder4seq_contig_loci <- file.path(output_sequences,"loci_contigs")
folder4seq_contig_samples <- file.path(output_sequences,"samples_contigs")


#########################################################################
### concatenate consensus files across all loci to lists per sample   ###
#########################################################################

samples <- readLines(path_to_namelist)


# collect all sequences
# if you are on Linux, then the bash commands cat and sed are used. If not, then R file operations are used, which are slower
if(Sys.info()['sysname']=="Linux"){
  if(intronerated_contig=="yes"){



print ("start samples")


# # # # LOOP OVER SAMPLES

    for(sample in samples){
print(sample)
      command_cat_loci_consensus <- paste("cat",file.path(path_to_output_folder,"01_data/",sample,"/intronerated_consensus/*.fasta"),">",file.path(folder4seq_consensus_samples,paste(sample,"_intronerated_consensus.fasta",sep="")))
      system(command_cat_loci_consensus)
      command_cat_loci_contig <- paste("cat",file.path(path_to_output_folder,"01_data/",sample,"/intronerated_contigs/*.fasta"),">",file.path(folder4seq_contig_samples,paste(sample,"_intronerated_contig.fasta",sep="")))
      system(command_cat_loci_contig)
    } 

# # # # END OF LOOP




  } else {
    for(sample in samples){
      command_cat_loci_consensus <- paste("cat",file.path(path_to_output_folder,"01_data/",sample,"/consensus/*.fasta"),">",file.path(folder4seq_consensus_samples,paste(sample,"_consensus.fasta",sep="")))
      system(command_cat_loci_consensus)
      command_cat_loci_contig <- paste("cat",file.path(path_to_output_folder,"01_data/",sample,"/contigs/*.fasta"),">",file.path(folder4seq_contig_samples,paste(sample,"_contig.fasta",sep="")))
      system(command_cat_loci_contig)
    }
  }  
} else {
  if(intronerated_contig=="yes"){
    for(sample in samples){
      #list all fasta files from the sample for all loci
      consensus_files_samples <- list.files(path=file.path(path_to_output_folder,"01_data/",sample,"/intronerated_consensus/"),pattern="*.fasta", full.names = TRUE)
      contigs_files_samples <- list.files(path=file.path(path_to_output_folder,"01_data/",sample,"/intronerated_contigs/"),pattern="*.fasta", full.names = TRUE)
      #define output files
      output_file_consensus_samples <- file.path(folder4seq_consensus_samples,paste(sample,"_intronerated_consensus.fasta",sep=""))          
      output_file_contigs_samples <- file.path(folder4seq_contig_samples,paste(sample,"_intronerated_contigs.fasta",sep=""))          
      #create output files
      file.create(output_file_consensus_samples, overwrite=TRUE)
      file.create(output_file_contigs_samples, overwrite=TRUE)
      #append fasta files to empty output file
      file.append(output_file_consensus_samples,consensus_files_samples)                
      file.append(output_file_contigs_samples,contigs_files_samples)        
    } 
  } else {
    for(sample in samples){
      
      #list all fasta files from the sample for all loci
      consensus_files_samples <- list.files(path=file.path(path_to_output_folder,"01_data/",sample,"/consensus/"),pattern="*.fasta", full.names = TRUE)
      contigs_files_samples <- list.files(path=file.path(path_to_output_folder,"01_data/",sample,"/contigs/"),pattern="*.fasta", full.names = TRUE)
      #define output files
      output_file_consensus_samples <- file.path(folder4seq_consensus_samples,paste(sample,"_consensus.fasta",sep=""))          
      output_file_contigs_samples <- file.path(folder4seq_contig_samples,paste(sample,"_contigs.fasta",sep=""))          
      #create output files
      file.create(output_file_consensus_samples, overwrite=TRUE)
      file.create(output_file_contigs_samples, overwrite=TRUE)
      #append fasta files to empty output file
      file.append(output_file_consensus_samples,consensus_files_samples)                
      file.append(output_file_contigs_samples,contigs_files_samples)        
    }
  }
}

print ("Done with samples, de-interleaving")

# changing interleaved HybPiper files to non-interleaved fasta files
for(file in list.files(folder4seq_contig_samples, full.names = T)){
  lines <- readLines(file)
  conx <- file(file)
  writeLines(str_split(paste(gsub("(>.*)",":\\1:",lines),collapse =""), pattern = ":")[[1]][-1], conx)
  close(conx)
}

print("DONE")
