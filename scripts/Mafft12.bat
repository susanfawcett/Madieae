#!/bin/bash
# MafftSwords12.bat
# Aligns Swords12 subsets for all four clade pairs, exons and supercontigs

#SBATCH --job-name=MafftSwords12
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
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
INDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}
OUTDIR=${INDIR}/aligned

echo "=== MafftSwords12 ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID}"
echo "Input dir: ${INDIR}"
echo "Output dir: ${OUTDIR}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

which mafft || { echo "ERROR: mafft not found"; exit 1; }
mafft --version || true

mkdir -p "$OUTDIR" || { echo "mkdir failed"; exit 1; }
cd "$INDIR" || { echo "cd failed"; exit 1; }

if [[ "$INDIR" == *supercontigs* ]]; then
    MAFFT_OPTS="--genafpair --maxiterate 1000 --adjustdirection --thread ${SLURM_CPUS_PER_TASK}"
else
    MAFFT_OPTS="--localpair --maxiterate 1000 --adjustdirection --thread ${SLURM_CPUS_PER_TASK}"
fi
echo "MAFFT options: ${MAFFT_OPTS}"

shopt -s nullglob
files=( *.fasta )
echo "Found ${#files[@]} fasta files"

if [ ${#files[@]} -eq 0 ]; then
    echo "No .fasta files found; exiting."
    exit 0
fi

i=0
skipped=0
for f in "${files[@]}"; do
    base=${f%.fasta}
    outfile="${OUTDIR}/${base}.fasta"
    if [[ -s "$outfile" ]]; then
        echo "[skip] $base already aligned"
        skipped=$((skipped+1))
        continue
    fi
    echo "[align] $f"
    mafft $MAFFT_OPTS "$f" > "$outfile"
    # Dedup by sequence name (NFS cache can cause duplicate writes)
    python3 -c "
out = []
seen = set()
keep = False
for line in open('$outfile'):
    if line.startswith('>'):
        name = line[1:].split()[0]
        keep = name not in seen
        if keep: seen.add(name)
    if keep: out.append(line)
open('$outfile', 'w').writelines(out)
"
    i=$((i+1))
done

echo "Aligned: $i | Skipped: $skipped"
echo "=== Complete ==="
date
