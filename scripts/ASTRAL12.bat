#!/bin/bash
# ASTRALSwords12.bat
# Runs ASTRAL on IQTree locus trees for all Swords12 analyses
# Both unrooted (no diploids) and rooted (61dip) analyses
# Input: loci.treefile from each IQTree directory
# Output: ASTRAL/ subdirectory in each analysis directory

#SBATCH --job-name=ASTRALSwords12
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --array=0-23
#SBATCH --output=/path/to/working/dir/Madieae_nDNA/12_swords/logs/%j_%a.out
#SBATCH --error=/path/to/working/dir/Madieae_nDNA/12_swords/logs/%j_%a.err

set -u

# All analyses - Swords12 unrooted (0-7) and 61dip (8-23)
DIRS=(
    Swords12_AMA_ASC_exons
    Swords12_AMA_ASC_supercontigs
    Swords12_AMA_KYH_exons
    Swords12_AMA_KYH_supercontigs
    Swords12_AMA_MAD_exons
    Swords12_AMA_MAD_supercontigs
    Swords12_KYH_MAD_exons
    Swords12_KYH_MAD_supercontigs
    Swords12_AMA_ASC_exons_61dip/AMA
    Swords12_AMA_ASC_exons_61dip/ASC
    Swords12_AMA_ASC_supercontigs_61dip/AMA
    Swords12_AMA_ASC_supercontigs_61dip/ASC
    Swords12_AMA_KYH_exons_61dip/AMA
    Swords12_AMA_KYH_exons_61dip/KYH
    Swords12_AMA_KYH_supercontigs_61dip/AMA
    Swords12_AMA_KYH_supercontigs_61dip/KYH
    Swords12_AMA_MAD_exons_61dip/AMA
    Swords12_AMA_MAD_exons_61dip/MAD
    Swords12_AMA_MAD_supercontigs_61dip/AMA
    Swords12_AMA_MAD_supercontigs_61dip/MAD
    Swords12_KYH_MAD_exons_61dip/KYH
    Swords12_KYH_MAD_exons_61dip/MAD
    Swords12_KYH_MAD_supercontigs_61dip/KYH
    Swords12_KYH_MAD_supercontigs_61dip/MAD
)

BASEDIR=/path/to/working/dir/Madieae_nDNA/12_swords
IQTREE_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/IQTree
ASTRAL_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/ASTRAL

echo "=== ASTRALSwords12 ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID}"
echo "IQTree dir: ${IQTREE_DIR}"
echo "ASTRAL dir: ${ASTRAL_DIR}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

which astral || { echo "ERROR: astral not found"; exit 1; }

LOCI=${IQTREE_DIR}/loci.treefile

if [ ! -f "$LOCI" ]; then
    echo "ERROR: loci.treefile not found at $LOCI"
    exit 1
fi

mkdir -p "$ASTRAL_DIR" || { echo "mkdir failed"; exit 1; }

OUTPUT=${ASTRAL_DIR}/astral.tre
LOG=${ASTRAL_DIR}/astral.log

if [ -s "$OUTPUT" ]; then
    echo "[skip] ASTRAL output already exists"
    exit 0
fi

echo "[run] ASTRAL on $(wc -l < $LOCI) locus trees"
astral -i "$LOCI" -o "$OUTPUT" 2> "$LOG"

echo "=== Complete ==="
date
