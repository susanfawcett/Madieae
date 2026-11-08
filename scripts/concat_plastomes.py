#!/usr/bin/env python3
# concat_plastomes.py
# Concatenates LSC + IRa + SSC into master plastome matrix
# LSC already aligned by Bruce in Geneious
# IRa and SSC realigned by MAFFT (MafftPlastomes.bat)
# Run from Madieae_plastomes/ after MAFFT completes

BASEDIR = "/path/to/working/dir/Madieae_plastomes"

LSC = f"{BASEDIR}/LSC_plastome_Madieae_359_fixed.fasta"
IRA = f"{BASEDIR}/IRa_plastome_Madieae_359_aligned.fasta"
SSC = f"{BASEDIR}/SSC_plastome_Madieae_359_aligned.fasta"
OUT = f"{BASEDIR}/Madieae_plastome_master_359.fasta"
PART = f"{BASEDIR}/Madieae_plastome_master_359_partitions.txt"

def read_fasta(f):
    seqs = {}; order = []; hdr = None; parts = []
    for line in open(f):
        line = line.rstrip()
        if line.startswith('>'):
            if hdr: seqs[hdr] = ''.join(parts)
            hdr = line[1:]; parts = []; order.append(hdr)
        else: parts.append(line)
    if hdr: seqs[hdr] = ''.join(parts)
    return seqs, order

print("Reading LSC...")
lsc, order = read_fasta(LSC)
print("Reading IRa...")
ira, _ = read_fasta(IRA)
print("Reading SSC...")
ssc, _ = read_fasta(SSC)

# Verify all headers match
assert set(lsc) == set(ira) == set(ssc), "Header mismatch between regions!"

lsc_len = len(lsc[order[0]])
ira_len = len(ira[order[0]])
ssc_len = len(ssc[order[0]])
total   = lsc_len + ira_len + ssc_len

print(f"LSC: {lsc_len} bp")
print(f"IRa: {ira_len} bp")
print(f"SSC: {ssc_len} bp")
print(f"Total: {total} bp")
print(f"Sequences: {len(order)}")

# Write concatenated matrix
with open(OUT, 'w') as out:
    for h in order:
        seq = lsc[h] + ira[h] + ssc[h]
        out.write('>' + h + '\n')
        for i in range(0, len(seq), 80):
            out.write(seq[i:i+80] + '\n')

# Write partition file for IQTree
with open(PART, 'w') as p:
    p.write(f"DNA, LSC = 1-{lsc_len}\n")
    p.write(f"DNA, IRa = {lsc_len+1}-{lsc_len+ira_len}\n")
    p.write(f"DNA, SSC = {lsc_len+ira_len+1}-{total}\n")

print(f"Written: {OUT}")
print(f"Partitions: {PART}")
