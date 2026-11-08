#!/bin/bash
# MafftPlastomes.bat
# Realigns SSC and IRa plastome regions
# Array 0 = SSC, 1 = IRa

#SBATCH --job-name=MafftPlastomes
#SBATCH --account=fc_labordia
#SBATCH --partition=savio3
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --array=0-1
#SBATCH --output=logs/%j_%a.out
#SBATCH --error=logs/%j_%a.err

source ~/miniconda3/etc/profile.d/conda.sh
conda activate hybpiper

BASEDIR=.  # set to your plastome analysis directory

INFILES=(SSC_plastome_Madieae_359_fixed.fasta IRa_plastome_Madieae_359_fixed.fasta)
OUTFILES=(SSC_plastome_Madieae_359_aligned.fasta IRa_plastome_Madieae_359_aligned.fasta)

IN=${BASEDIR}/${INFILES[$SLURM_ARRAY_TASK_ID]}
OUT=${BASEDIR}/${OUTFILES[$SLURM_ARRAY_TASK_ID]}

echo "=== MafftPlastomes ==="
date
echo "Input: $IN"
echo "Output: $OUT"

mafft --auto --thread ${SLURM_CPUS_PER_TASK} "$IN" > "$OUT"

echo "=== Complete ==="
date
