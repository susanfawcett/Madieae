#!/bin/bash
#SBATCH --job-name=IQTreePlastV2
#SBATCH --account=fc_labordia
#SBATCH --partition=savio3
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --array=0-1
#SBATCH --output=logs/%j_%a.out
#SBATCH --error=logs/%j_%a.err

set -u

FASTAS=(
    LSC_plastome_Madieae_masked_dedup_noLoneHmask.fasta
    LSC_plastome_Madieae_masked_dedup_noLoneHmask_highNdrop.fasta
)

PREFIXES=(
    noLoneHmask
    noLoneHmask_highNdrop
)

BASEDIR=.  # set to your plastome analysis directory
FASTA=${BASEDIR}/${FASTAS[$SLURM_ARRAY_TASK_ID]}
PREFIX=${PREFIXES[$SLURM_ARRAY_TASK_ID]}
IQTREE_DIR=${BASEDIR}/IQTree

echo "=== IQTreePlastomes_v2 ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID}"
echo "Input: ${FASTA}"
echo "Prefix: ${PREFIX}"

source ~/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

which iqtree3 || { echo "ERROR: iqtree3 not found"; exit 1; }
iqtree3 --version || true

mkdir -p "$IQTREE_DIR" || { echo "mkdir failed"; exit 1; }
cd "$IQTREE_DIR" || { echo "cd failed"; exit 1; }

echo "[step] IQ-Tree run"
iqtree3 -s "$FASTA" \
    --prefix "$PREFIX" \
    -m GTR+G \
    -B 1000 \
    -T AUTO

echo "=== Complete ==="
date
