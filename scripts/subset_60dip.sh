#!/bin/bash
# subset_60dip.sh
# Combines 12_swords phased sequences (one subgenome at a time) with
# Tarweeds60 diploid sequences for all four clade pairs, exons and supercontigs
# Run from compute node (srun) to avoid NFS cache write issues.

DIP_NAMELIST=$WORKDIR/Tarweeds60.txt
PIPER279=$PIPER279
OUTBASE=$WORKDIR

declare -A CLADES
CLADES[AMA_ASC]="AMA ASC"
CLADES[AMA_KYH]="AMA KYH"
CLADES[AMA_MAD]="AMA MAD"
CLADES[KYH_MAD]="KYH MAD"

for PAIR in AMA_ASC AMA_KYH AMA_MAD KYH_MAD; do
    echo "Processing ${PAIR}..."

    for CLADE in ${CLADES[$PAIR]}; do
        echo "  Subgenome: ${CLADE}"

        # --- Exons ---
        SWORDS_IN=${OUTBASE}/Swords12_${PAIR}_exons
        EXON_OUT=${OUTBASE}/Swords12_${PAIR}_exons_60dip/${CLADE}
        DIP_IN=${PIPER279}/01_dna_seqs
        mkdir -p ${EXON_OUT}

        for f in ${SWORDS_IN}/*.fasta; do
            locus=$(basename "$f" .fasta)
            dip_file=${DIP_IN}/${locus}.FNA
            if [ ! -f "$dip_file" ]; then continue; fi
            python3 -c "
clade = '${CLADE}'
names = set(open('${DIP_NAMELIST}').read().split())
sword_out = []
sword_seen = set()
keep = False
for line in open('$f'):
    if line.startswith('>'):
        cur = line[1:].split()[0]
        keep = '_to_' + clade in line and cur not in sword_seen
        if keep: sword_seen.add(cur)
    if keep:
        sword_out.append(line)
dip_out = []
dip_seen = set()
keep = False
for line in open('$dip_file'):
    if line.startswith('>'):
        full = line[1:].split()[0]
        keep = full in names and full not in dip_seen
        if keep: dip_seen.add(full)
    if keep:
        dip_out.append(line)
if sword_out or dip_out:
    with open('${EXON_OUT}/${locus}.fasta', 'w') as fh:
        fh.writelines(sword_out)
        fh.writelines(dip_out)
"
        done
        echo "    Exons done: $(ls ${EXON_OUT}/*.fasta 2>/dev/null | wc -l) loci"

        # --- Supercontigs ---
        SWORDS_IN=${OUTBASE}/Swords12_${PAIR}_supercontigs
        SUPER_OUT=${OUTBASE}/Swords12_${PAIR}_supercontigs_60dip/${CLADE}
        DIP_IN=${PIPER279}/03_supercontig_seqs
        mkdir -p ${SUPER_OUT}

        for f in ${SWORDS_IN}/*.fasta; do
            locus=$(basename "$f" .fasta)
            dip_file=${DIP_IN}/${locus}
            if [ ! -f "$dip_file" ]; then continue; fi
            python3 -c "
clade = '${CLADE}'
names = set(open('${DIP_NAMELIST}').read().split())
sword_out = []
sword_seen = set()
keep = False
for line in open('$f'):
    if line.startswith('>'):
        cur = line[1:].split()[0]
        keep = '_to_' + clade in line and cur not in sword_seen
        if keep: sword_seen.add(cur)
    if keep:
        sword_out.append(line)
dip_out = []
dip_seen = set()
keep = False
for line in open('$dip_file'):
    if line.startswith('>'):
        full = line[1:].split()[0]
        keep = full in names and full not in dip_seen
        if keep: dip_seen.add(full)
    if keep:
        dip_out.append(line)
if sword_out or dip_out:
    with open('${SUPER_OUT}/${locus}.fasta', 'w') as fh:
        fh.writelines(sword_out)
        fh.writelines(dip_out)
"
        done
        echo "    Supercontigs done: $(ls ${SUPER_OUT}/*.fasta 2>/dev/null | wc -l) loci"

    done
done
echo "All done!"
