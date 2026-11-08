#!/bin/bash
# ASTRALSwords12_60dip.bat
# ASTRAL for Swords12 + Tarweeds60 (Guardiola dropped, Venegasia root)

#SBATCH --job-name=ASTRALSwords12_60dip
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
LOCI=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/IQTree/loci.treefile
OUTPUT=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/ASTRAL/astral.tre
LOG=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/ASTRAL/astral.log

echo "=== ASTRALSwords12_60dip ==="
date
echo "Array task: ${SLURM_ARRAY_TASK_ID} — ${DIRS[$SLURM_ARRAY_TASK_ID]}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

[ ! -f "$LOCI" ] && { echo "ERROR: loci.treefile not found"; exit 1; }
mkdir -p "$(dirname $OUTPUT)"
[ -s "$OUTPUT" ] && { echo "[skip] already exists"; exit 0; }

echo "[run] ASTRAL on $(wc -l < $LOCI) locus trees"
astral -i "$LOCI" -o "$OUTPUT" 2> "$LOG"
echo "=== Complete ==="
date
