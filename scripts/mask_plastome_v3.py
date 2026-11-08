#!/usr/bin/env python3
# mask_plastome_v3.py
# Identifies HaplOMiner artifact positions from G/H pairs and masks them.
#
# Method:
#   1. For each of the 80 G/H pairs, compare position by position
#   2. At positions where both have real calls (not N or gap) but disagree,
#      record the G call and H call
#   3. Flag position as artifact if:
#      - dominant G call != dominant H call
#      - at least MIN_PAIRS pairs show this disagreement
#   4. Mask ALL H sequences (paired + lone-H) where they carry the dominant H call
#      at artifact positions (call-specific masking, not blanket masking)
#   5. Output full 359-seq masked matrix and dedup 279-seq matrix (keep G, drop H)
#   6. Drop high-N sequences (>HIGH_N_THRESHOLD) from dedup matrix
#
# Outputs:
#   Madieae_plastome_masked_p{N}_359.fasta    - all 359 seqs, H seqs masked
#   Madieae_plastome_masked_p{N}_dedup.fasta  - 279 seqs (G over H, high-N dropped)
#   artifact_positions.tsv                    - flagged positions with dominant calls
#   masking_log.tsv                           - per-sequence masking summary
#   pair_divergence.tsv                       - per G/H pair divergence stats
#
# Run from Madieae_plastomes/ after concat_plastomes.py

BASEDIR         = "/path/to/working/dir/Madieae_plastomes"
INFILE          = f"{BASEDIR}/Madieae_plastome_master_359.fasta"
HIGH_N_THRESHOLD = 0.10

from collections import defaultdict, Counter
import os

# --- Read master matrix ---
print("Reading master matrix...")
seqs = {}; order = []; hdr = None; parts = []
for line in open(INFILE):
    line = line.rstrip()
    if line.startswith('>'):
        if hdr: seqs[hdr] = ''.join(parts)
        hdr = line[1:]; parts = []; order.append(hdr)
    else: parts.append(line)
if hdr: seqs[hdr] = ''.join(parts)
aln_len = len(seqs[order[0]])
print(f"  {len(order)} sequences, {aln_len:,} bp")

# --- Identify true G/H pairs ---
g_seqs = {h[:-2]: h for h in seqs if h.endswith('_G')}
h_seqs = {h[:-2]: h for h in seqs if h.endswith('_H')}
pairs  = set(g_seqs) & set(h_seqs)
print(f"  G/H pairs: {len(pairs)}")
print(f"  Lone-H (no G): {len(h_seqs) - len(pairs)}")
print(f"  G-only (no H): {len(g_seqs) - len(pairs)}")

# --- Per-pair divergence stats ---
print("\nCalculating pair divergence...")
pair_div = []
for base in sorted(pairs):
    g = seqs[g_seqs[base]].upper()
    h = seqs[h_seqs[base]].upper()
    g_ns = g.count('N'); h_ns = h.count('N')
    comparable = 0; real_diff = 0
    for pos in range(aln_len):
        gb = g[pos]; hb = h[pos]
        if gb in '-N' or hb in '-N': continue
        comparable += 1
        if gb != hb: real_diff += 1
    pct = 100*real_diff/comparable if comparable else 0
    pair_div.append((g_seqs[base], h_seqs[base], comparable, g_ns, h_ns, real_diff, pct))

pair_div.sort(key=lambda x: x[6])
print(f"  Median divergence: {sorted(x[6] for x in pair_div)[len(pair_div)//2]:.4f}%")
print(f"  Min divergence (best anchor): {pair_div[0][0]} / {pair_div[0][1]} ({pair_div[0][6]:.4f}%)")
print(f"  Max divergence: {pair_div[-1][0]} ({pair_div[-1][6]:.4f}%)")

with open(f"{BASEDIR}/pair_divergence.tsv", 'w') as f:
    f.write("G_header\tH_header\tsites_compared\tG_has_N\tH_has_N\treal_diff\tpct_divergence\n")
    for row in pair_div:
        f.write('\t'.join(str(x) for x in row) + '\n')
print(f"  Written: pair_divergence.tsv")

# --- Identify artifact positions ---
print("\nScanning for artifact positions...")
# For each position, collect (G_call, H_call) from pairs where both have real calls
pos_g_calls = defaultdict(list)
pos_h_calls = defaultdict(list)

for base in pairs:
    g = seqs[g_seqs[base]].upper()
    h = seqs[h_seqs[base]].upper()
    for pos in range(aln_len):
        gb = g[pos]; hb = h[pos]
        if gb in '-N' or hb in '-N': continue
        if gb != hb:
            pos_g_calls[pos].append(gb)
            pos_h_calls[pos].append(hb)

print(f"  Positions with any G/H disagreement: {len(pos_g_calls):,}")

# Determine dominant calls and flag artifacts
artifact_info = {}  # pos -> (dominant_G, dominant_H, n_pairs)
for pos in pos_g_calls:
    n_pairs = len(pos_g_calls[pos])
    dom_g = Counter(pos_g_calls[pos]).most_common(1)[0][0]
    dom_h = Counter(pos_h_calls[pos]).most_common(1)[0][0]
    if dom_g != dom_h:
        artifact_info[pos] = (dom_g, dom_h, n_pairs)

print(f"  Positions where dominant G != dominant H: {len(artifact_info):,}")
for min_pairs in [2, 4]:
    n = sum(1 for v in artifact_info.values() if v[2] >= min_pairs)
    print(f"  MIN_PAIRS={min_pairs}: {n:,} artifact positions")

# Write artifact_positions.tsv
with open(f"{BASEDIR}/artifact_positions.tsv", 'w') as f:
    f.write("alignment_pos\tdominant_G_call\tdominant_H_call\tn_pairs_supporting\n")
    for pos in sorted(artifact_info):
        dom_g, dom_h, n_pairs = artifact_info[pos]
        f.write(f"{pos+1}\t{dom_g}\t{dom_h}\t{n_pairs}\n")
print(f"  Written: artifact_positions.tsv")

# --- Assess N content ---
print("\nAssessing N content...")
n_content = {}
for h in order:
    seq = seqs[h].upper()
    n_content[h] = seq.count('N') / len(seq)

high_n = {h for h,pct in n_content.items() if pct > HIGH_N_THRESHOLD}
print(f"  High-N sequences (>{HIGH_N_THRESHOLD*100:.0f}%): {len(high_n)}")
for h in sorted(high_n, key=lambda x: -n_content[x]):
    print(f"    {h}: {n_content[h]*100:.1f}%")

# --- Deduplication: keep G, drop paired H ---
drop_paired_h = {h_seqs[base] for base in pairs}
print(f"\nDeduplication: dropping {len(drop_paired_h)} paired H sequences (keeping G)")

# --- Write outputs ---
def write_masked(outfile, order, seqs, art_pos_info, drop, log_rows):
    kept = 0; skipped = 0
    with open(outfile, 'w') as out:
        for h in order:
            if h in drop:
                skipped += 1; continue
            seq = list(seqs[h].upper())
            n_masked = 0
            if h.endswith('_H'):
                # Mask positions where this H carries the dominant H artifact call
                for pos, (dom_g, dom_h, n_pairs) in art_pos_info.items():
                    if seq[pos] == dom_h:
                        seq[pos] = 'N'
                        n_masked += 1
            s = ''.join(seq)
            out.write('>' + h + '\n')
            for i in range(0, len(s), 80):
                out.write(s[i:i+80] + '\n')
            kept += 1
            assembler = 'G' if h.endswith('_G') else 'H'
            callable_art = sum(1 for pos,(dg,dh,np) in art_pos_info.items()
                               if seqs[h].upper()[pos] not in '-N') if h.endswith('_H') else 0
            log_rows.append((h, assembler, callable_art, n_masked,
                             f"{100*n_masked/len(s):.3f}" if n_masked else "0.000",
                             h not in drop))
    print(f"  Written: {kept} seqs, dropped: {skipped}")
    return kept

for min_pairs in [2, 4]:
    art_pos_info = {pos: v for pos,v in artifact_info.items() if v[2] >= min_pairs}
    print(f"\n=== MIN_PAIRS={min_pairs} ({len(art_pos_info):,} artifact positions) ===")

    log_rows = []

    # Full 359 masked
    outfile = f"{BASEDIR}/Madieae_plastome_masked_p{min_pairs}_359.fasta"
    print(f"Writing {outfile}...")
    write_masked(outfile, order, seqs, art_pos_info, set(), log_rows)

    log_rows = []

    # Dedup + high-N drop
    drop = drop_paired_h | high_n
    outfile = f"{BASEDIR}/Madieae_plastome_masked_p{min_pairs}_dedup.fasta"
    print(f"Writing {outfile}...")
    write_masked(outfile, order, seqs, art_pos_info, drop, log_rows)

    # Write masking log
    logfile = f"{BASEDIR}/masking_log_p{min_pairs}.tsv"
    with open(logfile, 'w') as f:
        f.write("header\tassembler\tcallable_artifact_sites\tn_masked\tpct_masked\tin_dedup\n")
        for row in log_rows:
            f.write('\t'.join(str(x) for x in row) + '\n')
    print(f"  Written: masking_log_p{min_pairs}.tsv")

print("\nDone!")
