#!/bin/bash
# IQTreeSwords12_60dip.bat
# IQ-Tree for Swords12 + Tarweeds60 (Guardiola dropped, Venegasia root)

#SBATCH --job-name=IQTree60dip
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=48:00:00
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
ALN_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/trimmed
IQTREE_DIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/IQTree

echo "=== IQTreeSwords12_60dip ==="
date
echo "Array task: ${SLURM_ARRAY_TASK_ID} — ${DIRS[$SLURM_ARRAY_TASK_ID]}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

mkdir -p "$IQTREE_DIR" && cd "$IQTREE_DIR"

echo "[step] Concatenation tree"
iqtree3 -p "$ALN_DIR" --prefix concat -B 1000 -T AUTO

FILT_DIR=${IQTREE_DIR}/filtered_loci
mkdir -p "$FILT_DIR"
for f in ${ALN_DIR}/*.fasta; do
    nseq=$(grep -c "^>" "$f" 2>/dev/null || echo 0)
    [ "$nseq" -ge 3 ] && cp "$f" "$FILT_DIR/" || echo "[skip] $(basename $f) has $nseq seqs"
done
echo "Loci passed filter: $(ls $FILT_DIR | wc -l)"

echo "[step] Locus trees"
iqtree3 -S "$FILT_DIR" --prefix loci -T AUTO

echo "[step] Gene concordance factors"
iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord

echo "[step] Site concordance factors"
iqtree3 -te concat.treefile -p "$ALN_DIR" --scfl 100 --prefix concord2

echo "=== Complete ==="
date
