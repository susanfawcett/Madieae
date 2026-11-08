#!/bin/bash
#SBATCH --job-name=HybPiperJensia
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=/path/to/working/dir/Madieae_nDNA/logs/HybPiperJensia_%j.out
#SBATCH --error=/path/to/working/dir/Madieae_nDNA/logs/HybPiperJensia_%j.err

set -u

READS=/path/to/cleaned_reads  # set to your cleaned reads directory
TARGETS=/path/to/Madieae2_targets.fasta  # set to your targets file
OUTDIR=/path/to/working/dir/Madieae_nDNA/Jensia_hybpiper

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh
conda activate hybpiper

mkdir -p $OUTDIR
cd $OUTDIR

for SAMPLE in JENRAM494 JENYOS603; do
    echo "=== Running HybPiper for $SAMPLE ==="
    hybpiper assemble \
        -r ${READS}/${SAMPLE}_R1.fastq ${READS}/${SAMPLE}_R2.fastq \
        -t_dna ${TARGETS} \
        --prefix ${SAMPLE} \
        --bwa \
        --cpu ${SLURM_CPUS_PER_TASK}
    echo "=== Done $SAMPLE ==="
done

echo "=== Retrieving supercontig sequences ==="
cd $OUTDIR
hybpiper retrieve_sequences \
    -t_dna ${TARGETS} \
    --sample_names <(echo -e "JENRAM494\nJENYOS603") \
    supercontig

echo "=== All done ==="
date
