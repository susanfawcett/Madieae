#!/bin/bash
# TrimAlSwords12.bat
# Trims aligned Swords12 loci for all four clade pairs, exons and supercontigs

#SBATCH --job-name=TrimAlSwords12
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
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
ALNDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/aligned
OUTDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/trimmed

echo "=== TrimAlSwords12 ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID}"
echo "Input dir: ${ALNDIR}"
echo "Output dir: ${OUTDIR}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

which trimal || { echo "ERROR: trimal not found"; exit 1; }
trimal --version || true

find "$OUTDIR" -name "*.fasta" -delete 2>/dev/null
mkdir -p "$OUTDIR" || { echo "mkdir failed"; exit 1; }
cd "$ALNDIR" || { echo "cd failed"; exit 1; }
# Fix _R_ prefixes
for f in *.fasta; do grep -q "^>_R_" "$f" 2>/dev/null && sed -i 's/^>_R_/>/' "$f"; done

shopt -s nullglob
files=( *.fasta )
echo "Found ${#files[@]} aligned fasta files"

if [ ${#files[@]} -eq 0 ]; then
    echo "No .fasta files found; exiting."
    exit 0
fi

i=0
skipped=0
for f in "${files[@]}"; do
    base=${f%.fasta}
    outfile="${OUTDIR}/${base}.fasta"
    # Always overwrite — skip logic caused NFS cache duplication issues
    echo "[trim] $f"
    trimal -in "$f" -out "$outfile" -automated1
    i=$((i+1))
done

echo "Trimmed: $i | Skipped: $skipped"
echo "=== Complete ==="
date
