#!/bin/bash
# IQTreeSwords12.bat
# IQ-Tree analysis for Swords12 subsets, all four clade pairs
# exons and supercontigs, unrooted, no diploid outgroups
# Full suite: concatenation + locus trees + gene & site concordance factors

#SBATCH --job-name=IQTreeSwords12
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=48:00:00
#SBATCH --array=0-7
#SBATCH --output=/path/to/working/dir/Madieae_nDNA/12_swords/logs/%j_%a.out
#SBATCH --error=/path/to/working/dir/Madieae_nDNA/12_swords/logs/%j_%a.err

set -u

DIRS=(
    Swords12_AMA_ASC_exons
    Swords12_AMA_ASC_supercontigs
    Swords12_AMA_KYH_exons
    Swords12_AMA_KYH_supercontigs
    Swords12_AMA_MAD_exons
    Swords12_AMA_MAD_supercontigs
    Swords12_KYH_MAD_exons
    Swords12_KYH_MAD_supercontigs
)

BASEDIR=/path/to/working/dir/Madieae_nDNA/12_swords
ALN_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/trimmed
IQTREE_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/IQTree

echo "=== IQTreeSwords12 ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID}"
echo "Input dir: ${ALN_DIR}"
echo "Output dir: ${IQTREE_DIR}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

which iqtree3 || { echo "ERROR: iqtree3 not found"; exit 1; }
iqtree3 --version || true

mkdir -p "$IQTREE_DIR" || { echo "mkdir failed"; exit 1; }
cd "$IQTREE_DIR" || { echo "cd failed"; exit 1; }

# Concatenation-based species tree with 1000 ultrafast bootstrap
echo "[step] Concatenation tree"
iqtree3 -p "$ALN_DIR" --prefix concat -B 1000 -T AUTO

# Individual locus trees
echo "[step] Locus trees"
# Filter out loci with <3 sequences before running IQTree
FILT_DIR=${IQTREE_DIR}/filtered_loci
mkdir -p "$FILT_DIR"
for f in ${ALN_DIR}/*.fasta; do
    nseq=$(grep -c "^>" "$f" 2>/dev/null || echo 0)
    if [ "$nseq" -ge 3 ]; then
        cp "$f" "$FILT_DIR/"
    else
        echo "[skip] $(basename $f) has $nseq seqs (<3)"
    fi
done
echo "Loci passed filter: $(ls $FILT_DIR | wc -l)"
iqtree3 -S "$FILT_DIR" --prefix loci -T AUTO

# Gene concordance factors
echo "[step] Gene concordance factors"
iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord

# Site concordance factors
echo "[step] Site concordance factors"
iqtree3 -te concat.treefile -p "$ALN_DIR" --scfl 100 --prefix concord2

echo "=== Complete ==="
date
