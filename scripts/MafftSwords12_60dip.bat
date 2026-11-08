#!/bin/bash
# MafftSwords12_60dip.bat
# Aligns Swords12 + Tarweeds60 (Guardiola dropped, Venegasia as root) for all
# four clade pairs, both exons and supercontigs, each subgenome separately.
# Reads raw fastas from original 61dip dirs, drops GUAPLA before aligning.

#SBATCH --job-name=Mafft60dip
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=72:00:00
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

# Corresponding source dirs in original 61dip analysis
SRC_DIRS=(
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

BASEDIR=/path/to/working/dir/Madieae_nDNA/RootVenegasia/12SwordsSupercontigs
SRCBASE=/path/to/working/dir/Madieae_nDNA/12_swords
OUTDIR=${BASEDIR}/${DIRS[$SLURM_ARRAY_TASK_ID]}/aligned
SRCDIR=${SRCBASE}/${SRC_DIRS[$SLURM_ARRAY_TASK_ID]}

echo "=== MafftSwords12_60dip ==="
date
echo "Host: $(hostname)"
echo "Array task: ${SLURM_ARRAY_TASK_ID} — ${DIRS[$SLURM_ARRAY_TASK_ID]}"
echo "Source dir: ${SRCDIR}"
echo "Output dir: ${OUTDIR}"

source /global/home/users/$USER/miniconda3/etc/profile.d/conda.sh || { echo "conda init failed"; exit 1; }
conda activate hybpiper || { echo "conda activate failed"; exit 1; }

mkdir -p "$OUTDIR" || { echo "mkdir failed"; exit 1; }

if [[ "${DIRS[$SLURM_ARRAY_TASK_ID]}" == *supercontigs* ]]; then
    MAFFT_OPTS="--genafpair --maxiterate 1000 --adjustdirection --thread ${SLURM_CPUS_PER_TASK}"
else
    MAFFT_OPTS="--localpair --maxiterate 1000 --adjustdirection --thread ${SLURM_CPUS_PER_TASK}"
fi
echo "MAFFT options: ${MAFFT_OPTS}"

shopt -s nullglob
files=( ${SRCDIR}/*.fasta )
echo "Found ${#files[@]} source fasta files"

i=0
skipped=0
for f in "${files[@]}"; do
    base=$(basename ${f%.fasta})
    outfile="${OUTDIR}/${base}.fasta"
    if [[ -s "$outfile" ]]; then
        skipped=$((skipped+1))
        continue
    fi
    # Drop GUAPLA sequence, write temp file
    tmpfile=$(mktemp)
    python3 -c "
out = []; keep = True
for line in open('$f'):
    if line.startswith('>'):
        keep = 'GUAPLA' not in line
    if keep: out.append(line)
open('$tmpfile', 'w').writelines(out)
"
    echo "[align] $base"
    mafft $MAFFT_OPTS "$tmpfile" > "$outfile"
    rm -f "$tmpfile"
    # Strip _R_ prefixes
    sed -i 's/^>_R_/>/' "$outfile"
    # Dedup
    python3 -c "
out=[]; seen=set(); keep=False
for line in open('$outfile'):
    if line.startswith('>'):
        name=line[1:].split()[0]; keep=name not in seen
        if keep: seen.add(name)
    if keep: out.append(line)
open('$outfile','w').writelines(out)
"
    i=$((i+1))
done

echo "Aligned: $i | Skipped: $skipped"
echo "=== Complete ==="
date
