# Madieae Nuclear Phylogenomics

**Baldwin, Fawcett, Kostic, Wessa, Freyman, in prep.**

Computational pipelines for phylogenomic analyses of Madieae (Asteraceae), based on targeted enrichment sequencing of 279 taxa using a custom MYbaits probe library (Arbor Biosciences) targeting 461 putatively single-copy nuclear loci, with additional plastome data from off-target reads and whole-genome sequencing. 



---

## Target File Preparation

Transcriptomes from *Dubautia latifolia* and *Wilkesia gymnoxiphium* were sequenced and assembled using SOAPdenovo-Trans (M.S. Barker, R.H. Robichaux, B.G. Baldwin, unpubl.). MarkerMiner v1.0 was used to identify 461 putatively single-copy nuclear loci (each >900 bp). These were used to develop a custom MYbaits probe library (Arbor Biosciences).

The target file is `Madieae2_targets.fasta`. 

---

## Raw Data Preparation

Raw reads from Arbor Biosciences were renamed, quality-filtered with fastp (adapter removal, poly-G tail removal, quality filtering), and unzipped prior to assembly. Processed reads are two files per sample (`_R1.fastq`, `_R2.fastq`).

## HybPiper — First Pass (279 samples)

HybPiper v2 was run on all 279 samples using BWA for read mapping, parallelized using GNU parallel. See https://github.com/mossmatters/HybPiper

```bash
hybpiper assemble -r SAMPLE_R1.fastq SAMPLE_R2.fastq \
    -t_dna Madieae2_targets.fasta --prefix SAMPLE --bwa --cpu 8
```

Post-assembly processing retrieved exon sequences (`01_dna_seqs/`) and supercontig sequences (`03_supercontig_seqs/`) per locus.

### Sample filtering

After initial alignment and IQ-Tree analysis, 30 samples were removed: 26 duplicated samples (mostly from earlier pilot study BS01 with poor target recovery), both *Chaenactis* samples (~30 loci recovered), and two poor-quality samples (*Eriophyllum congdonii* BW80 and *Dubautia plantaginea* subsp. *plantaginea* 1508_8_ML).

A dataset of 279 samples was recovered, with 192 samples representing only diploids and paleopolyploids and 68 members of the (tetraploid) Hawaiian silversword alliance (*Argyroxiphium*, *Dubautia*, and *Wilkesia*). North American polyploids *Eriophyllum jepsonii*, *E. latilobum*, *E. staechadifolium*, *Hemizonella minima*, *Madia anomala*, *M. citrigracilis*, *M. exigua*, *M. glomerata*, *M. gracilis*, *M. sativa*, and *Raillardella scaposa*, were phased and analyzed separately. Borderline cases include *Arnica dealbata* and *A. mollis*, where diploid populations are documented and paralogy did not indicate polyploidy were retained in the diploid dataset. *Guardiola platyphylla*, an outgroup used to root the tree was later omitted because it introduced topological instability, and *Venegasia carpesioides* was used instead, resulting in a dataset with 278 accessions.

---

## HybPhaser 

HybPhaser was used to assess SNP patterns, associate silversword samples with progenitor clades, and phase tetraploid reads by subgenome. For Silverswords, potential diploid progenitor lineages were identified through read mapping and four hypotheses were tested. See https://github.com/LarsNauheimer/HybPhaser 

| Hypothesis | Progenitor 1 | Progenitor 2 |
|---|---|---|
| AMA_ASC | *Anisocarpus madioides* | *Anisocarpus scabridus* |
| AMA_KYH | *Anisocarpus madioides* | *Kyhosia bolanderi* |
| AMA_MAD | *Anisocarpus madioides* | *Carlquistia muirii* |
| KYH_MAD | *Kyhosia bolanderi* | *Carlquistia muirii* |

**Consensus sequence generation**

```bash
# calls bin/1_generate_consensus_sequences_single_core.sh
sbatch batch_1_consensus_sing.sh
```

**SNP assessment**

```bash
R -f bin/1a_count_snps.R
R -f bin/1b_assess_dataset.R
R -f bin/1c_MY_loci_lists.R
R -f bin/1c_MY_sample_lists.R
```

**Clade association** (68 tetraploid silverswords against reference diploid clades):

```bash
sbatch batch_2_MY_extract_mapped_reads.sh
sbatch batch_2_MY_prepare_clade.sh
```

**Phasing** (one config per progenitor hypothesis):

```bash
sbatch batch_3_phase.sh
# calls R -f bin/3a_prepare_phasing_script.R
```

Second HybPiper pass on phased reads is documented in the Allopolyploid_Origin_Silverswords branch, and is hypothesis specific.

### HybPhaser bug fixes

Three bugs were identified and fixed in the original HybPhaser scripts:

1. `1_generate_consensus_sequences.sh` line 266 — `wait -n` not supported in bash < v4.3. Fixed by replacing with custom `anywait()` function.
2. `1_generate_consensus_sequences_single-core.sh` — missing `fi` at line 235. Fixed by inserting missing `fi`.
3. `4_merge_sequence_lists.R` — `samples_include_phased` never initialized when `file_with_samples_included` is set, causing failure at line 86. Fixed by initializing variable and correcting phased sample inclusion logic.

---

## Phylogenetic Pipeline

For each analysis, sequences were aligned, trimmed, and used for both concatenation-based and multispecies coalescent-based species tree inference.

### Alignment

We ran MAFFT as parallelized jobs. Exon alignments used L-INS-i (`--localpair --maxiterate 1000`). Supercontig alignments used E-INS-i (`--genafpair --maxiterate 1000`). `--adjustdirection` applied throughout to correct reverse-complement sequences.

*Jensia* was inadvertently omitted from supercontigs (*Jensia ramii*, *J. yosemitana*), so sequences for these two species were assembled *de novo* from raw reads using HybPiper and added to existing alignments using `mafft --add --keeplength`.

### Trimming

TrimAl with `-automated1` heuristic.

### Species tree inference

**Maximum Likelihood** IQ-Tree 3 with partition model, 1000 ultrafast bootstrap replicates (`-B 1000`). Gene and site concordance factors computed from locus trees.

```bash
iqtree3 -p TRIMMED_DIR --prefix concat -B 1000 -T AUTO
iqtree3 -S TRIMMED_DIR --prefix loci -T AUTO
iqtree3 -t concat.treefile --gcf loci.treefile --prefix concord
iqtree3 -te concat.treefile -p TRIMMED_DIR --scfl 100 --prefix concord2
```

**Multispecies Coalescent** ASTRAL 5.7.8 on per-locus IQ-Tree gene trees.

```bash
astral -i loci.treefile -o astral.tre
```
---

# Madieae Plastome Phylogenomics

Plastome phylogenomic pipeline for 279 Madieae (Asteraceae) samples. Plastomes were assembled by two methods and combined into a unified masked alignment for phylogenetic analysis. Subsets from this alignment are used for comparison with nuclear phylogenomic anlyses.

---

### Sequencing
Targeted enrichment sequencing of 279 Madieae taxa using a custom MYbaits probe library (Arbor Biosciences) targeted 461 nuclear loci. Off-target reads were used for plastome assembly. For 80 of these samples with poor plastome recovery from off-target reads, additional whole-genome sequence data was generated (Arbor Biosciences) and used to assemble plastomes.

### Assembly methods

**Hapl-O-Miner / SORTER2 (H sequences)** — assembled from off-target targeted enrichment reads using Hapl-O-Miner implemented in SORTER2 with *Venegasia carpesioides* as reference plastome. 279 samples recovered.

**GetOrganelle (G sequences)** — assembled from whole-genome sequencing data using GetOrganelle with *Venegasia carpesioides* as seed. 80 samples recovered. G sequences are the higher-quality assembly were not masked.

### Dataset composition
| Metric | Value |
|---|---|
| Total sequences | 359 |
| G sequences (GetOrganelle) | 80 |
| H sequences (Hapl-O-Miner) | 279 |
| Paired G+H samples | 80 |
| Lone-H samples | 199 |
| Alignment length | 216,986 bp |
| LSC partition | 1–148,254 bp |
| IRa partition | 148,255–181,942 bp |
| SSC partition | 181,943–216,986 bp |
| Analysis matrix (dedup, post-QC) | 271 sequences |

---

## Alignment

LSC region was hand-aligned and curated by Bruce Baldwin in Geneious. SSC and IRa regions were aligned with MAFFT (--auto). All three regions were concatenated into a single 216,986 bp master alignment.

---

## Artifact masking

Hapl-O-Miner introduces systematic directional base-calling artifacts at specific alignment positions, causing H sequences to cluster by assembly method rather than phylogeny. These artifacts were identified and masked using `mask_plastome_v3.py`.

### Method
For each of 80 G/H sequence pairs from the same sample, positions where both sequences have real base calls but disagree were recorded. A position is flagged as an artifact if the dominant G call differs from the dominant H call across at least MIN_PAIRS pairs. At each flagged position, H sequences carrying the artifact call are masked to N. G sequences are never masked. Masking is call-specific — H sequences carrying the correct (G-like) call at an artifact position are not masked.

### Parameter selection
Four masking thresholds were compared. MIN_PAIRS=3 was selected based on bootstrap support and topological stability.

| Parameter | Artifact positions | Mean BS | Min BS | Nodes <70 |
|---|---|---|---|---|
| MIN_PAIRS=2 | ~5,500 | 94.6 | 44 | 18 |
| MIN_PAIRS=3 | 4,119 | 95.7 | 60 | 7 |
| MIN_PAIRS=4 | ~3,200 | 93.4 | 29 | 21 |
| MIN_PAIRS=10 | 1,773 | 94.8 | 32 | 16 |

### Deduplication
For each of the 80 paired samples, the G (GetOrganelle) sequence is retained and the H sequence dropped. For 199 lone-H samples (no G counterpart), the masked H sequence is retained. Eight lone-H sequences with >10% N content were dropped. Final analysis matrix: 271 sequences (80 G + 191 lone-H).

---

## Phylogenetic analysis

IQ-Tree 3 with GTR+G model, partitioned by LSC/IRa/SSC, 1000 ultrafast bootstrap replicates. 

```bash
iqtree3 -s Madieae_plastome_masked_p3_dedup.fasta \
    -p Madieae_plastome_master_359_partitions.txt \
    --prefix IQTree/masked_p3_dedup \
    -B 1000 -T AUTO -m GTR+G
```

Guardiola was omitted from subsequent analyses, using Venegasia carpesioides as the root.

---
## Data

Sample data for all 279 taxa are available in [`Madieae_Phylogenomics_Master.csv`](files/Madieae_Phylogenomics_Master.csv).

| Column | Description |
|---|---|
| Genus, Species, Subspecies | Taxon name |
| Ploidy | Ploidy level (2n, 4n, 6n) |
| Collector, Collector_number, Voucher, Herbarium | Voucher specimen data |
| Location, State | Collection locality |
| Exon_loci | Number of exon loci recovered by HybPiper |
| SC_loci | Number of supercontig loci recovered |
| Exon_coverage | Mean proportion of target exon sequence recovered |
| Plastome_coverage | Plastome coverage relative to *Venegasia carpesioides* |
| G_coverage | GetOrganelle plastome coverage (80 samples) |
| H_coverage | Hapl-O-Miner plastome coverage |
| H_pct_masked | Proportion of H sequence masked as artifact |
| HybPhaser_loci | Number of loci used in HybPhaser SNP assessment |
| Allele_divergence | Mean allele divergence across loci |
| Locus_heterozygosity | Mean locus heterozygosity |
| Swords12 | Member of 12-silversword phasing subset |
| Swords68 | Member of 68-silversword dataset |
| Dip19 | Member of 19-diploid outgroup dataset |
| Dip60 | Member of 60-diploid outgroup dataset |
| Dip191 | Member of 191-diploid tarweed dataset |
| nDNA_279 | Member of full 279-sample nuclear dataset |
| SangerID | Identifier for Sanger sequence data |
| HybPiper_ID | HybPiper assembly identifier |
| plastome_label | Plastome sequence identifier |
| Tip_Label | Canonical tip label used in phylogenetic trees |

## Results summary

### Sequence quality

Alignment length 216,986 bp (LSC 1–148,254 | IRa 148,255–181,942 | SSC 181,943–216,986). All 271 sequences passed QC. Missingness (N + gap) ranges from 39.5–51.7% (mean 42.8%), reflecting sparse coverage typical of off-target plastome recovery from targeted enrichment reads. GetOrganelle (G) sequences have 0% artifact masking by design; Hapl-O-Miner (H) sequences have 0.97–1.61% of sites masked (mean 1.20%), consistent across all samples. *Jensia yosemitana* (JENYOS603) was not recovered and is absent from the plastome dataset. Partition rate scalers are: LSC 0.537, IRa 0.117, SSC 0.946. Most Madieae genera are monophyletic in the plastome tree, and largely congruent with nuclear analyses. 

### Partition comparisons

LSC and SSC were analyzed separately and compared to the whole plastome to identify potential sources of error or differences in topology.

| Region | Alignment (bp) | Mean BS | Nodes ≥95 | Nodes 70–94 | Nodes <70 | Min BS |
|---|---|---|---|---|---|---|
| Whole plastome | 216,986 | 95.6 | 209 | 52 | 7 | 29 |
| LSC | 148,254 | 93.2 | 205 | 41 | 22 | 1 |
| SSC | 35,044 | 90.6 | 175 | 61 | 32 | 24 |

## Files

### Nuclear phylogenomics
| File | Description |
|---|---|
| `Madieae2_targets.fasta` | Target file — 461 putatively single-copy nuclear loci |
| `Madieae_Phylogenomics_Master.csv` | Sample data for all 279 taxa (see column descriptions above) |

### Plastome phylogenomics
| File | Description |
|---|---|
| `Madieae_plastome_master_359_partitions.txt` | IQ-Tree partition file for plastome alignment (LSC/IRa/SSC) |
| `artifact_positions.tsv` | Flagged Hapl-O-Miner artifact positions with dominant G/H calls and pair support |
| `masking_log_p3.tsv` | Per-sequence masking summary for MIN_PAIRS=3 |
| `pair_divergence.tsv` | Per G/H pair divergence statistics |

The plastome alignment matrix (`Madieae_plastome_masked_p3_dedup.fasta`, 271 sequences, 216,986 bp) is available on Dryad.

## Scripts

| Script | Pipeline stage | Description |
|---|---|---|
| `scripts/batch_1_consensus_sing.sh` | HybPhaser | Consensus sequence generation |
| `scripts/batch_2_MY_extract_mapped_reads.sh` | HybPhaser | Clade association — extract mapped reads |
| `scripts/batch_2_MY_prepare_clade.sh` | HybPhaser | Clade association — prepare clade references |
| `scripts/batch_3_phase.sh` | HybPhaser | Subgenome phasing |
| `scripts/bin/1_generate_consensus_sequences.sh` | HybPhaser | Consensus sequence generation (parallel) |
| `scripts/bin/1_generate_consensus_sequences_single_core.sh` | HybPhaser | Consensus sequence generation (single core) |
| `scripts/bin/1a_count_snps.R` | HybPhaser | SNP counting |
| `scripts/bin/1b_assess_dataset.R` | HybPhaser | Dataset assessment |
| `scripts/bin/1c_MY_loci_lists.R` | HybPhaser | Locus list generation |
| `scripts/bin/1c_MY_sample_lists.R` | HybPhaser | Sample list generation |
| `scripts/bin/3a_prepare_phasing_script.R` | HybPhaser | Phasing script preparation |
| `scripts/bin/4_merge_sequence_lists.R` | HybPhaser | Merge sequence lists |
| `scripts/concat_plastomes.py` | Plastome | Concatenate LSC + IRa + SSC into master alignment |
| `scripts/mask_plastome_v3.py` | Plastome | Artifact detection, masking, and deduplication |
| `scripts/MafftPlastomes.bat` | Plastome | MAFFT alignment of plastome regions (SLURM) |
| `scripts/IQTreePlastomes.bat` | Plastome | IQ-Tree on full masked matrix (SLURM) |

## Software

| Tool | Version |
|---|---|
| SOAPdenovo-Trans | — |
| MarkerMiner | 1.0 |
| fastp | — |
| BWA | — |
| GNU parallel | — |
| HybPiper | 2.3.3 |
| HybPhaser | — |
| MAFFT | 7.525 |
| TrimAl | 1.5 |
| IQ-Tree | 3.0.0 |
| ASTRAL | 5.7.8 |
| GetOrganelle | 1.7.x |
| Hapl-O-Miner / SORTER2 | — |


## Citation

Baldwin, B.G., Fawcett, S., Kostic, A., Wessa, B.L. and Freyman, W.A., 2026. A tribal‐scale phylogenomic perspective on ancestry and major lineages of the allotetraploid Hawaiian silversword alliance (Madieae, Compositae). American Journal of Botany, p.e70284.


