#!/bin/bash
# TrimAlSwords12_60dip.bat
# Trims aligned Swords12 + Tarweeds60 loci (Guardiola dropped, Venegasia root)

#SBATCH --job-name=TrimAl60dip
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --array=0-15
#SBATCH --output=/path/to/working/dir/Madieae_nDNA/RootVenegasia/logs/%j_%a.out
#SBATCH --error=/path/to/working/dir/Madieae_nDNA/RootVenegasia/logs/%j_%a.err

set -u

DIRS=(
    Swords12_AMA_ASC_exons_60dip/AMA
    Swords12_AMA_ASC_exons_60dip/ASC
    Swords12_AMA_ASC_supercontigs_60dip/AMA
    Swords12_AMA_ASC_supercontigs_60dip/ASC
    Swords12_AMA_KYH_exons_60dip/AMA
    Swords12_AMA_KYH_exons_60dip/KYH
    Swords12_AMA_KYH_supercontigs_60dip/AMA
    Swords12_AMA_KYH_supercontigs_60dip/KYH
    Swords12_AMA_MAD_exons_60dip/AMA
    Swords12_AMA_MAD_exons_60dip/MAD
    Swords12_AMA_MAD_supercontigs_60dip/AMA
    Swords12_AMA_MAD_supercontigs_60dip/MAD
    Swords12_KYH_MAD_exons_60dip/KYH
    Swords12_KYH_MAD_exons_60dip/MAD
    Swords12_KYH_MAD_supercontigs_60dip/KYH
    Swords12_KYH_MAD_supercontigs_60dip/MAD
)

BASEDIR=/path/to/working/dir/Madieae_nDNA/RootVenegasia/12SwordsSupercontigs
ALNDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/aligned
OUTDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/trimmed

echo "=== TrimAlSwords12_60dip ==="
date
echo "Array task: ${SLURM_ARRAY_TASK_ID} — ${DIRS[$SLURM_ARRAY_TASK_ID]}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

mkdir -p "$OUTDIR"
shopt -s nullglob
files=( ${ALNDIR}/*.fasta )
echo "Found ${#files[@]} files"

i=0; skipped=0
for f in "${files[@]}"; do
    base=$(basename ${f%.fasta})
    outfile="${OUTDIR}/${base}.fasta"
    if [[ -s "$outfile" ]]; then skipped=$((skipped+1)); continue; fi
    trimal -in "$f" -out "$outfile" -automated1
    i=$((i+1))
done

echo "Trimmed: $i | Skipped: $skipped"
echo "=== Complete ==="
date
