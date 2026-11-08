#!/bin/bash
# subset_swords12s.sh
# Subsets Andy's HybPiper output to Swords12s samples for all four clade pairs
# Identical to Mar2026/scripts/subset_swords12.sh but uses ARGSANs657_1
# instead of ARGSANm_W244 (sandwicense sandwicense vs sandwicense macrocephalum)

NAMELIST=/path/to/working/dir/Madieae_nDNA/12_swords/Swords12.txt
PIPER=/path/to/HybPiper/output  # set to your HybPiper output directory
OUTBASE=/path/to/working/dir/Madieae_nDNA/12_swords

for PAIR in AMA_ASC AMA_KYH AMA_MAD KYH_MAD; do
    EXON_IN=${PIPER}/piper_out_Silversword_${PAIR}/01_dna_seqs
    SUPER_IN=${PIPER}/piper_out_Silversword_${PAIR}/03_supercontig_seqs
    EXON_OUT=${OUTBASE}/Swords12_${PAIR}_exons
    SUPER_OUT=${OUTBASE}/Swords12_${PAIR}_supercontigs

    mkdir -p ${EXON_OUT} ${SUPER_OUT}
    echo "Processing ${PAIR}..."

    # Exons
    for f in ${EXON_IN}/*.FNA; do
        locus=$(basename "$f" .FNA)
        python3 -c "
names = set(open('${NAMELIST}').read().split())
out = []
keep = False
for line in open('$f'):
    if line.startswith('>'):
        full = line[1:].split()[0]
        base = '_'.join(full.split('_')[:-2]) if '_to_' in full else full
        keep = base in names
    if keep:
        out.append(line)
if out:
    open('${EXON_OUT}/${locus}.fasta', 'w').writelines(out)
"
    done
    echo "  Exons done: $(ls ${EXON_OUT}/*.fasta 2>/dev/null | wc -l) loci"

    # Supercontigs
    for f in ${SUPER_IN}/*; do
        locus=$(basename "$f")
        python3 -c "
names = set(open('${NAMELIST}').read().split())
out = []
keep = False
for line in open('$f'):
    if line.startswith('>'):
        full = line[1:].split()[0]
        base = '_'.join(full.split('_')[:-2]) if '_to_' in full else full
        keep = base in names
    if keep:
        out.append(line)
if out:
    open('${SUPER_OUT}/${locus}.fasta', 'w').writelines(out)
"
    done
    echo "  Supercontigs done: $(ls ${SUPER_OUT}/*.fasta 2>/dev/null | wc -l) loci"

done
echo "All done!"
