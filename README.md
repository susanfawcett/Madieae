# The Allopolyploid Origin of the Hawaiian Silverswords

**Baldwin, B.G., et al. 2026. American Journal of Botany e70284. https://doi.org/10.1002/ajb2.70284**

This branch documents the computational pipeline for the nuclear phylogenomic analyses to evaluate the ancestral progenitors of the Hawaiian Silversword Alliance. Methods shared with other related publications (raw data preparation, HybPiper assembly, HybPhaser phasing, plastome analyses) are documented in https://github.com/susanfawcett/Madieae/.

---

## Overview

The Hawaiian silversword alliance (*Argyroxiphium*, *Dubautia*, *Wilkesia*; Asteraceae: Madieae) is an adaptive radiation endemic to the Hawaiian Islands. This analysis uses phased phylogenomics to test hypotheses about the diploid progenitor lineages of this allotetraploid group, using phased genomic sequences from 12 tetraploid silversword samples representing all major lineages and genome arrangements, along with 60 diploid Madieae outgroups across 461 nuclear loci. Ancestral traits and chromosome numbers are reconstructed using ultrametric trees. 

### Progenitor hypotheses tested

| Hypothesis | Progenitor 1 | Progenitor 2 |
|---|---|---|
| AMA_ASC | *Anisocarpus madioides* | *Anisocarpus scabridus* |
| AMA_KYH | *Anisocarpus madioides* | *Kyhosia bolanderi* |
| AMA_MAD | *Anisocarpus madioides* | *Carlquistia muirii* |
| KYH_MAD | *Kyhosia bolanderi* | *Carlquistia muirii* |

---

## Samples

### 12 tetraploid silverswords, 60 diploid tarweeds
| Genus | Species | Subspecies | Ploidy | Collector | Collection number | Herbarium | Location | Exon loci | SC loci | Exon coverage | HybPhaser loci | Allele divergence | Tip_Label |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| *Achyrachaena* | *mollis* |  | 2n | Bruce G. Baldwin | 651 | DAV | Solano Co.: Sacramento Valley | 460 | 53 | 0.998 | 460 | 0.386 | Achyrachaena_mollis_BGB651a |
| *Adenothamnus* | *validus* |  | 2n | Martha S. Witter | W86-99 | DAV | Municipio Ensenada: Punta Banda | 461 | 160 | 1 | 461 | 1.132 | Adenothamnus_validus_MSWW8699 |
| *Amblyopappus* | *pusillus* |  | 2n | Bruce G. Baldwin | s.n. | UC | Municipio Ensenada: Isla San Mart’n | 461 | 144 | 0.98 | 461 | 0.905 | Amblyopappus_pusillus_BGBsn1988 |
| *Anisocarpus* | *madioides* |  | 2n | Bruce G. Baldwin | 488 | DAV | Napa Co.: Outer North Coast Ranges, Mayacamas Mountains | 461 | 79 | 0.996 | 461 | 0.273 | Anisocarpus_madioides_BGB488 |
| *Anisocarpus* | *scabridus* |  | 2n | Bruce G. Baldwin | 676 | DAV | Lake Co.: High North Coast Ranges, Hull Mountain | 459 | 151 | 0.996 | 459 | 0.864 | Anisocarpus_scabridus_BGB676 |
| *Argyroxiphium* | *grayanum* |  | 4n | Bruce G. Baldwin | 661 | DAV | Maui: West Maui Mountains, Pu'u Kukui | 461 | 123 | 1 | 461 | 5.018 | Argyroxiphium_grayanum_BGB661 |
| *Argyroxiphium* | *sandwicense* | sandwicense | 4n | Bruce G. Baldwin | 657 | DAV | Hawai'i Island: Mauna Kea | 461 | 98 | 1 | 461 | 5.022 | Argyroxiphium_sandwicense_sandwicense_BGB657 |
| *Arnica* | *dealbata* |  | 2n | Bruce G. Baldwin | 920 | JEPS | Tehama Co.: Cascade Ranges | 460 | 232 | 0.993 | 459 | 1.761 | Arnica_dealbata_BGB920 |
| *Arnica* | *mollis* |  | 2n | Bruce G. Baldwin | 680 | DAV | Alpine Co.: northern Sierra Nevada, Carson Range | 461 | 215 | 0.996 | 461 | 1.805 | Arnica_mollis_BGB680 |
| *Baeriopsis* | *guadalupensis* |  | 2n | Jon P. Rebman | 6758 | UC | Municipio Ensenada: Isla Guadalupe, Islote Zapato (Outer Islet) | 461 | 171 | 0.98 | 460 | 1.555 | Baeriopsis_guadalupensis_JPR6758 |
| *Blepharipappus* | *scaber* |  | 2n | Bob Powell & Vic Claassen | 3275 | DAV | Lassen Co.: Modoc Plateau | 460 | 340 | 0.954 | 460 | 3.373 | Blepharipappus_scaber_VC3275 |
| *Blepharizonia* | *laxa* |  | 2n | Bruce G. Baldwin | 542a | DAV | San Joaquin Co.: Mt. Hamilton Range | 461 | 308 | 1 | 460 | 2.204 | Blepharizonia_laxa_BGB542a |
| *Blepharizonia* | *plumosa* |  | 2n | Bruce G. Baldwin | 1252 | JEPS | Contra Costa Co.: nw edge San Joaquin Valley (s of Antioch) | 461 | 161 | 0.998 | 461 | 1.105 | Blepharizonia_plumosa_BGB1252 |
| *Calycadenia* | *mollis* |  | 2n | Robert L. Carr | 2213 | EWU | Madera Co.: central Sierra Nevada foothills | 461 | 361 | 0.993 | 461 | 4.115 | Calycadenia_mollis_RLC2213 |
| *Calycadenia* | *truncata* |  | 2n | Bruce G. Baldwin | 605 | DAV | Tehama Co.: Cascade Range foothills | 461 | 347 | 0.996 | 458 | 3.663 | Calycadenia_truncata_BGB605 |
| *Carlquistia* | *muirii* |  | 2n | Bruce G. Baldwin | 615 | DAV | Fresno Co.: southern High Sierra Nevada, Kings River drainage | 460 | 113 | 0.996 | 460 | 0.948 | Carlquistia_muirii_BGB615 |
| *Carlquistia* | *muirii* |  | 2n | Bruce G. Baldwin | 618 | DAV | Monterey Co.: Outer South Coast Ranges, Santa Lucia Range, Ventana Double Cone | 460 | 124 | 0.998 | 460 | 0.804 | Carlquistia_muirii_BGB618 |
| *Carlquistia* | *muirii* |  | 2n | Bruce G. Baldwin | 683 | DAV | Tulare Co., southern High Sierra Nevada, Kaweah drainage | 460 | 86 | 0.996 | 460 | 0.478 | Carlquistia_muirii_BGB683 |
| *Carlquistia* | *muirii* |  | 2n | Bruce G. Baldwin | 726 | DAV | Tulare Co.: southern High Sierra Nevada, Greenhorn Mountains, Baker Point | 459 | 183 | 0.996 | 459 | 0.667 | Carlquistia_muirii_BGB726 |
| *Centromadia* | *perennis* |  | 2n | Donald W. Kyhos | s.n. | DAV | Municipio Ensenada: Colonet Mesa | 460 | 186 | 0.998 | 460 | 1.3 | Centromadia_perennis_DWKsn |
| *Centromadia* | *pungens* | pungens | 2n | Bruce G. Baldwin | 534 | DAV | San Luis Obispo Co.: Outer South Coast Ranges | 461 | 384 | 1 | 459 | 4.681 | Centromadia_pungens_pungens_BGB534 |
| *Constancea* | *nevinii* |  | 2n | Steven A. Junak | Sca-833 | JEPS | Los Angeles Co.: Santa Catalina Island | 460 | 186 | 0.993 | 460 | 0.682 | Constancea_nevinii_SAJSca833 |
| *Deinandra* | *fasciculata* |  | 2n | Bruce G. Baldwin | 533 | DAV | San Luis Obispo: Central Coast, Los Osos Valley | 460 | 356 | 0.991 | 458 | 4.086 | Deinandra_fasciculata_BGB533 |
| *Deinandra* | *floribunda* |  | 2n | Fred Sproul | s.n. (JEPS98939) | JEPS | San Diego Co.: Peninsular Ranges, Bankhead Springs | 460 | 226 | 0.993 | 459 | 2.297 | Deinandra_floribunda_FSsn1988 |
| *Dubautia* | *arborea* |  | 4n | Bruce G. Baldwin | 527b | DAV | Hawai'i Island: Mauna Kea, Pu'u La'au | 461 | 102 | 1 | 460 | 5.211 | Dubautia_arborea_BGB527b |
| *Dubautia* | *herbstobatae* |  | 4n | Gerald D. Carr | 1244 | HAW | O'ahu: Wai'anae Range, 'Ohikilolo Ridge | 461 | 99 | 1 | 460 | 5.308 | Dubautia_herbstobatae_GDC1244 |
| *Dubautia* | *knudsenii* | filiformis | 4n | Kenneth R. Wood | 13268 | PTBG | Kaua'i: upper Wainiha watershed | 461 | 151 | 1 | 460 | 4.805 | Dubautia_knudsenii_filiformis_KRW13268 |
| *Dubautia* | *laevigata* |  | 4n | Bruce G. Baldwin | 777 | DUKE | Kaua'i: Blue Hole | 461 | 101 | 1 | 461 | 5.22 | Dubautia_laevigata_BGB777 |
| *Dubautia* | *latifolia* |  | 4n | Bruce G. Baldwin | 675 | DAV | Kaua'i: NW watershed of Kauaikinana Stream (at Mohihi Road) | 461 | 92 | 1 | 461 | 4.944 | Dubautia_latifolia_BGB675 |
| *Dubautia* | *paleata* |  | 4n | Gerald D. Carr | 1375 | HAW | Kaua'i: Alaka'i Swamp | 461 | 154 | 1 | 461 | 5.116 | Dubautia_paleata_GDC1375 |
| *Dubautia* | *plantaginea* | plantaginea | 4n | Hank Oppenheimer | 11004 | UC | Maui: East Maui, upper Hanomanu Stream | 461 | 131 | 1 | 461 | 4.692 | Dubautia_plantaginea_plantaginea_HOH11004 |
| *Dubautia* | *scabra* | scabra | 4n | Bruce G. Baldwin | 526 | DAV | Hawai'i Island: Humu'ula Saddle, Pu'u Huluhulu | 461 | 110 | 1 | 460 | 5.11 | Dubautia_scabra_scabra_BGB526 |
| *Eatonella* | *nivea* |  | 2n | Bruce G. Baldwin | 868 | UC | Humboldt. Co.: Great Basin, Duferrena Field Station | 461 | 121 | 0.987 | 461 | 0.436 | Eatonella_nivea_BGB868 |
| *Eriophyllum* | *lanatum* | obovatum | 2n | E. Shapiro | s.n. | JEPS | San Bernardino Co.: San Bernardino Mountains | 461 | 203 | 0.978 | 461 | 1.494 | Eriophyllum_lanatum_obovatum_ESsn2008a |
| *Eriophyllum* | *lanosum* |  | 2n | Bruce G. Baldwin | 888 | JEPS | San Bernardino Co. | 461 | 307 | 0.993 | 460 | 2.818 | Eriophyllum_lanosum_BGB888 |
| *Harmonia* | *doris-nilesiae* |  | 2n | Barbara Williams | 518 | ???? | Trinity Co. | 459 | 327 | 0.993 | 458 | 4.327 | Harmonia_doris-nilesiae_BW518 |
| *Harmonia* | *guggolziorum* |  | 2n | Jack & Betty Guggolz | 1635 | JEPS | Mendocino Co. | 459 | 66 | 0.996 | 459 | 0.211 | Harmonia_guggolziorum_JG_&_BG1635 |
| *Harmonia* | *hallii* |  | 2n | Bruce G. Baldwin | 599 | DAV | Colusa Co. | 459 | 386 | 0.991 | 456 | 4.112 | Harmonia_hallii_BGB599 |
| *Harmonia* | *nutans* |  | 2n | Bruce G. Baldwin | 652 | DAV | Napa Co. | 459 | 367 | 0.991 | 457 | 5.456 | Harmonia_nutans_BGB652 |
| *Harmonia* | *stebbinsii* |  | 2n | Bruce G. Baldwin | 611 | DAV | Trinity Co. | 459 | 339 | 0.993 | 456 | 4.084 | Harmonia_stebbinsii_BGB611 |
| *Hemizonia* | *congesta* |  | 2n | Bruce G. Baldwin | 532 | DAV | San Luis Obispo Co. | 461 | 400 | 1 | 459 | 3.565 | Hemizonia_congesta_BGB532 |
| *Hemizonia* | *congesta* | congesta | 2n | Greg English-Loeb | EL-2-Hc | JEPS | Sonoma Co.: Dotsa Ranch, Tomales-Petaluma Road | 461 | 338 | 1 | 458 | 3.747 | Hemizonia_congesta_congesta_GELEL2Hc |
| *Holocarpha* | *macradenia* |  | 2n | Bruce G. Baldwin | 724 | DAV | Monterey Co. | 461 | 247 | 0.996 | 459 | 2.6 | Holocarpha_macradenia_BGB724 |
| *Holocarpha* | *obconica* |  | 2n | Bruce G. Baldwin | 1401 | JEPS | Alameda Co. | 461 | 247 | 0.993 | 460 | 3.036 | Holocarpha_obconica_BGB1401 |
| *Holozonia* | *filipes* |  | 2n | Bruce G. Baldwin | 513 | DAV | El Dorado Co. | 461 | 242 | 1 | 460 | 1.754 | Holozonia_filipes_BGB513 |
| *Hulsea* | *algida* |  | 2n | Bruce G. Baldwin | 678 | DAV | Alpine Co.: Sierra Nevada, Carson Range | 461 | 217 | 0.996 | 460 | 1.024 | Hulsea_algida_BGB678 |
| *Hulsea* | *californica* |  | 2n | Bruce G. Baldwin | s.n. | JEPS | San Diego Co.: Cleveland National Forest, 1.4 mi N of Laguna/El Prado Campround | 461 | 284 | 0.998 | 459 | 2.254 | Hulsea_californica_BGBsn1992a |
| *Jensia* | *rammii* |  | 2n | Bruce G. Baldwin | 494 | DAV | El Dorado Co. | 459 | 378 | 0.996 | 459 | 4.553 | Jensia_rammii_BGB494 |
| *Jensia* | *yosemitana* |  | 2n | Bruce G. Baldwin | 603 | DAV | Tuolumne Co. | 459 | 54 | 0.993 | 459 | 0.305 | Jensia_yosemitana_BGB603 |
| *Kyhosia* | *bolanderi* |  | 2n | Bruce G. Baldwin | 509b | DAV | El Dorado Co.: Sierra Nevada, Lake Tahoe, west shore | 460 | 134 | 0.998 | 459 | 0.786 | Kyhosia_bolanderi_BGB509b |
| *Lagophylla* | *minor* |  | 2n | Bruce G. Baldwin | 600 | DAV | Napa Co. | 459 | 343 | 0.98 | 458 | 3.087 | Lagophylla_minor_BGB600 |
| *Lagophylla* | *ramosissima* |  | 2n | Bruce G. Baldwin | 936 | JEPS | Solano Co. | 459 | 114 | 0.996 | 459 | 0.383 | Lagophylla_ramosissima_BGB936 |
| *Lasthenia* | *californica* |  | 2n | Bruce G. Baldwin | 830 | JEPS | Mariposa Co. | 459 | 410 | 0.911 | 456 | 7.427 | Lasthenia_californica_BGB830 |
| *Lasthenia* | *glaberrima* |  | 2n | Bruce G. Baldwin | 884 | JEPS | Solano Co. | 461 | 127 | 0.967 | 461 | 0.727 | Lasthenia_glaberrima_BGB884 |
| *Layia* | *gaillardioides* |  | 2n | Bruce G. Baldwin | 1072 | JEPS | Marin Co. | 459 | 285 | 0.985 | 458 | 1.824 | Layia_gaillardioides_BGB1072 |
| *Layia* | *heterotricha* |  | 2n | Bruce G. Baldwin | 738 | DAV | Santa Barbara Co. | 458 | 224 | 0.987 | 458 | 1.873 | Layia_heterotricha_BGB738 |
| *Madia* | *citriodora* |  | 2n | Bruce G. Baldwin | 715 | JEPS | Butte Co. | 459 | 74 | 0.996 | 459 | 0.279 | Madia_citriodora_BGB715 |
| *Madia* | *elegans* |  | 2n | Bruce G. Baldwin | 695 | DAV | Kern Co. | 459 | 396 | 0.993 | 458 | 4.877 | Madia_elegans_BGB695 |
| *Madia* | *radiata* |  | 2n | Bruce G. Baldwin | 693 | DAV | San Luis Obispo Co. | 460 | 329 | 0.996 | 459 | 3.181 | Madia_radiata_BGB693 |
| *Madia* | *subspicata* |  | 2n | Bruce G. Baldwin | 713 | DAV | Butte Co. | 460 | 51 | 0.998 | 460 | 0.246 | Madia_subspicata_BGB713 |
| *Monolopia* | *gracilens* |  | 2n | Bruce G. Baldwin | 1069 | JEPS | Contra Costa Co. | 461 | 126 | 1 | 461 | 1.313 | Monolopia_gracilens_BGB1069 |
| *Monolopia* | *major* |  | 2n | Bruce G. Baldwin | 1011 | JEPS | Colusa Co. | 461 | 403 | 0.998 | 459 | 5.148 | Monolopia_major_BGB1011 |
| *Osmadenia* | *tenella* |  | 2n | Gerald D. Carr | 1365 | DAV | San Diego Co.: Pala to Lilac Rd., 2.1 mi S of junction with Highway 76 | 460 | 405 | 0.996 | 460 | 5.159 | Osmadenia_tenella_GDC1365 |
| *Pseudobahia* | *bahiifolia* |  | 2n | Bruce G. Baldwin | 945 | JEPS | Madera Co. | 461 | 237 | 0.985 | 461 | 2.326 | Pseudobahia_bahiifolia_BGB945 |
| *Pseudobahia* | *peirsonii* |  | 2n | Bruce G. Baldwin | 913 | JEPS | Kern Co. | 461 | 282 | 0.989 | 460 | 1.98 | Pseudobahia_peirsonii_BGB913 |
| *Raillardella* | *argentea* |  | 2n | Bruce G. Baldwin | 512c | DAV | Alpine Co. | 460 | 216 | 0.993 | 458 | 2.097 | Raillardella_argentea_BGB512c |
| *Raillardella* | *pringlei* |  | 2n | Bruce G. Baldwin | 608b | DAV | Siskiyou Co.: Trinity Mountains, Toad Lake | 460 | 179 | 0.996 | 460 | 1.21 | Raillardella_pringlei_BGB608b |
| *Syntrichopappus* | *fremontii* |  | 2n | Bruce G. Baldwin | 1614 | JEPS | Kern Co. | 461 | 255 | 0.97 | 459 | 2.903 | Syntrichopappus_fremontii_BGB1614 |
| *Syntrichopappus* | *lemmonii* |  | 2n | Bruce G. Baldwin | 1611a | JEPS | Kern Co. | 461 | 233 | 0.976 | 461 | 3.278 | Syntrichopappus_lemmonii_BGB1611a |
| *Venegasia* | *carpesioides* |  | 2n | Bruce G. Baldwin | 893 | JEPS | San Luis Obispo Co. | 461 | 224 | 0.998 | 461 | 1.612 | Venegasia_carpesioides_BGB893 |
| *Wilkesia* | *gymnoxiphium* |  | 4n | Winona Char | 76.022 | HAW | Kaua'i | 461 | 253 | 1 | 461 | 5.317 | Wilkesia_gymnoxiphium_WC76.022 |
| *Wilkesia* | *hobdyi* |  | 4n | Gerald D. Carr | 1150 | HAW | Kaua'i | 461 | 183 | 1 | 461 | 5.287 | Wilkesia_hobdyi_GDC1150 |

---

## Analysis Design

### No-outgroup analyses (8)

Phased silverswords only, to assess subgenome monophyly and reciprocal monophyly between  sets of loci phased to different putative progenitor lineages.

```
Swords12_AMA_ASC_exons/
Swords12_AMA_ASC_supercontigs/
Swords12_AMA_KYH_exons/
Swords12_AMA_KYH_supercontigs/
Swords12_AMA_MAD_exons/
Swords12_AMA_MAD_supercontigs/
Swords12_KYH_MAD_exons/
Swords12_KYH_MAD_supercontigs/
```

### Diploid outgroup analyses (16)

Each subgenome from above phasings was combined with the 60 diploid outgroup to infer its relationship to diploids.

```
Swords12_AMA_ASC_exons_60dip/AMA/
Swords12_AMA_ASC_exons_60dip/ASC/
Swords12_AMA_ASC_supercontigs_60dip/AMA/
Swords12_AMA_ASC_supercontigs_60dip/ASC/
Swords12_AMA_KYH_exons_60dip/AMA/
Swords12_AMA_KYH_exons_60dip/KYH/
Swords12_AMA_KYH_supercontigs_60dip/AMA/
Swords12_AMA_KYH_supercontigs_60dip/KYH/
Swords12_AMA_MAD_exons_60dip/AMA/
Swords12_AMA_MAD_exons_60dip/MAD/
Swords12_AMA_MAD_supercontigs_60dip/AMA/
Swords12_AMA_MAD_supercontigs_60dip/MAD/
Swords12_KYH_MAD_exons_60dip/KYH/
Swords12_KYH_MAD_exons_60dip/MAD/
Swords12_KYH_MAD_supercontigs_60dip/KYH/
Swords12_KYH_MAD_supercontigs_60dip/MAD/
```
---

## Pipeline

### 1. Subsetting

Sequences subsetted from HybPiper output. Each phased subgenome retained as a unique taxon (`_to_AMA`, `_to_ASC`, etc.).

```bash
bash scripts/subset_60dip.sh
```

### 2. Alignment

MAFFT as SLURM array jobs (array 0–15 for 60dip analyses).

```bash
sbatch scripts/MafftSwords12_60dip.bat
```

Exon alignments: L-INS-i (`--localpair --maxiterate 1000 --adjustdirection`)  
Supercontig alignments: E-INS-i (`--genafpair --maxiterate 1000 --adjustdirection`)

### 3. Trimming

```bash
sbatch --dependency=afterok:$MAFFT_JOB scripts/TrimAlSwords12_60dip.bat
```

TrimAl `-automated1`. `_R_` prefixes introduced by `--adjustdirection` stripped before trimming.

### 4. Species tree inference

```bash
sbatch --dependency=afterok:$TRIMAL_JOB scripts/IQTreeSwords12_60dip.bat
```

IQ-Tree 3: Maximum likelihood tree (`-B 1000`), per-locus trees (`-S`), gene concordance factors, site concordance factors (`--scfl 100`). Loci with fewer than 3 sequences excluded from locus tree analysis.

```bash
sbatch --dependency=afterok:$IQTREE_JOB scripts/ASTRALSwords12_60dip.bat
```

ASTRAL 5.7.8 on per-locus gene trees.



## Phasing statistics

Proportion of reads assigned to each reference diploid clade by HybPhaser. AMA (*Anisocarpus madioides*), ASC (*A. scabridus*), MAD (*Carlquistia muirii* clade), JEN (*Jensia yosemitana*), HAR (*Harmonia guggolziorum*), KYH (*Kyhosia bolanderi*). This analysis was used to select candidate diploid lineages for pair-wise phasing.

| Sample | AMA | ASC | MAD | JEN | HAR | KYH |
|---|---|---|---|---|---|---|
| ARGGRA661_WM_1 | 0.311 | 0.150 | 0.073 | 0.026 | 0.018 | 0.061 |
| ARGSANs657_1 | 0.307 | 0.147 | 0.072 | 0.026 | 0.017 | 0.060 |
| DUBARB527b_2 | 0.298 | 0.144 | 0.079 | 0.031 | 0.018 | 0.060 |
| DUBHER_W253_1 | 0.301 | 0.143 | 0.075 | 0.029 | 0.019 | 0.061 |
| DUBKNUf_W831 | 0.231 | 0.103 | 0.057 | 0.022 | 0.016 | 0.047 |
| DUBLAE777_1 | 0.305 | 0.145 | 0.071 | 0.026 | 0.017 | 0.061 |
| DUBLAT675_1 | 0.303 | 0.144 | 0.072 | 0.026 | 0.017 | 0.060 |
| DUBPAL_W250_1 | 0.307 | 0.145 | 0.073 | 0.028 | 0.019 | 0.064 |
| DUBPLNp_W956_EM | 0.250 | 0.112 | 0.064 | 0.024 | 0.017 | 0.052 |
| DUBSCAs526_HSad_1 | 0.309 | 0.143 | 0.071 | 0.026 | 0.018 | 0.060 |
| WILGYM_W254_1 | 0.310 | 0.152 | 0.079 | 0.031 | 0.023 | 0.072 |
| WILHOB_W78_1 | 0.309 | 0.149 | 0.076 | 0.029 | 0.021 | 0.067 |

After phasing to six candidate references, four were selected for pairwise comparisons and subsequent analyses.

| Reference pair | Phased to | Data type | Loci (n) | Mean bp per locus | Median bp per locus | Min bp | Max bp |
|---|---|---|---|---|---|---|---|
| AMA_ASC | AMA | Exons | 461 | 1,287 | 1,172 | 299 | 3,803 |
| AMA_ASC | ASC | Exons | 461 | 1,284 | 1,173 | 675 | 3,842 |
| AMA_ASC | AMA | Supercontigs | 362 | 2,652 | 2,246 | 368 | 9,094 |
| AMA_ASC | ASC | Supercontigs | 363 | 2,523 | 2,154 | 581 | 9,075 |
| AMA_KYH | AMA | Exons | 461 | 1,286 | 1,170 | 731 | 3,803 |
| AMA_KYH | KYH | Exons | 461 | 1,278 | 1,167 | 716 | 3,846 |
| AMA_KYH | AMA | Supercontigs | 206 | 2,685 | 2,544 | 687 | 7,259 |
| AMA_KYH | KYH | Supercontigs | 211 | 2,531 | 2,061 | 660 | 7,236 |
| AMA_MAD | AMA | Exons | 461 | 1,288 | 1,173 | 759 | 3,842 |
| AMA_MAD | MAD | Exons | 461 | 1,282 | 1,170 | 673 | 3,842 |
| AMA_MAD | AMA | Supercontigs | 216 | 2,576 | 2,285 | 685 | 7,298 |
| AMA_MAD | MAD | Supercontigs | 213 | 2,466 | 2,063 | 446 | 6,568 |
| KYH_MAD | KYH | Exons | 461 | 1,284 | 1,170 | 704 | 3,846 |
| KYH_MAD | MAD | Exons | 461 | 1,286 | 1,172 | 759 | 3,803 |
| KYH_MAD | KYH | Supercontigs | 209 | 2,472 | 2,081 | 686 | 7,217 |
| KYH_MAD | MAD | Supercontigs | 216 | 2,546 | 2,238 | 791 | 7,475 |

---

## Trait Mapping and Chromosome Number Evolution

### Trait mapping

Ancestral state reconstruction for five discrete morphological traits using stochastic
character mapping (phytools `make.simmap`, ARD model, 100 simulations; Revell 2024).
Analyses conducted on three supercontig trees (AMA_ASC/AMA, AMA_KYH/KYH, AMA_MAD/MAD)
to bracket topological uncertainty.

Traits scored across 72 taxa (12 silverswords + 60 diploid outgroups):

| Trait | States | n (non-missing) |
|---|---|---|
| Habit | 0 = annual, 1 = perennial | 72 |
| Ray expression | 0 = reduced/absent, 1 = present | 72 |
| Pappus | 0 = absent, 1 = present | 72 |
| Self-incompatibility (SI) | 0 = self-compatible, 1 = self-incompatible | 50 |
| Disk bisexuality | 0 = functionally staminate, 1 = bisexual | 72 |
| Leaf margin | 0 = entire, 1 = dissected | 72 |

ASTRAL species trees were used as the fixed topology. Branch lengths were re-estimated
in substitutions/site by running IQ-Tree 3 with `-te` against the supercontig
alignment for the AMA_ASC/AMA, AMA_KYH/KYH and AMA_MAD/MAD analyses. Trees were then converted to
ultrametric using `chronos()` (ape; Paradis & Schliep 2019), penalized likelihood,
correlated rate model, lambda=1, no calibration points. Root: *Venegasia carpesioides*
(BGB893). 

Scripts: `scripts/make_ultrametric.R`, `scripts/trait_mapping.R`, `scripts/plot_traits.R`  
Trait data: `files/traits_12_Swords.txt`  
Ultrametric trees: `files/Swords12_AMA_ASC_supercontigs_60dip_AMA_ultrametric.tre`,
`files/Swords12_AMA_KYH_supercontigs_60dip_KYH_ultrametric.tre`,
`files/Swords12_AMA_MAD_supercontigs_60dip_MAD_ultrametric.tre`

### Chromosome number evolution

Probabilistic model of chromosome number evolution inferred using ChromEvol v2.0
(Glick & Mayrose 2014; Rice & Mayrose 2020). Input trees are the ultrametric trees
described above. Models run with linear gain and loss functions, constant duplication and
demi-ploidy rates, base number starting value *x* = 7, maximum chromosome number = 40.

Input files: `files/12swords_counts.txt`, ultrametric tree files (see above)

## Files

| File | Description |
|---|---|
| `Allopolyploid_Origin_samples.csv` | Sample data for 72 taxa (12 silverswords + 60 diploid outgroups) |
| `Tarweeds60.txt` | List of 60 diploid outgroup sample IDs |
| `hybpiper_stats_70_revised.xlsx` | HybPiper assembly statistics |
| `12swords_counts.txt` | Chromosome counts for ChromEvol input |
| `traits_12_Swords.txt` | Trait data for 72 taxa (7 traits) |
| `params_AMA_ASC.txt` | ChromEvol parameter file, AMA_ASC hypothesis |
| `params_AMA_KYH.txt` | ChromEvol parameter file, AMA_KYH hypothesis |
| `params_AMA_MAD.txt` | ChromEvol parameter file, AMA_MAD hypothesis |
| `12silverswords_AMA_ASC_supercontigs.tre` | ASTRAL no-outgroup tree, AMA_ASC hypothesis |
| `12silverswords_AMA_KYH_supercontigs.tre` | ASTRAL no-outgroup tree, AMA_KYH hypothesis |
| `12silverswords_AMA_MAD_supercontigs.tre` | ASTRAL no-outgroup tree, AMA_MAD hypothesis |
| `12silverswords_KYH_MAD_supercontigs.tre` | ASTRAL no-outgroup tree, KYH_MAD hypothesis |
| `AMA_ASC_AMA_SC_chromEvol_probs.tre` | ChromEvol output tree, AMA_ASC/AMA |
| `AMA_KYH_KYH_SC_chromEvol_probs.tre` | ChromEvol output tree, AMA_KYH/KYH |
| `AMA_MAD_MAD_SC_chromEvol_probs.tre` | ChromEvol output tree, AMA_MAD/MAD |
| `Swords12_AMA_ASC_supercontigs_60dip_AMA_ultrametric.tre` | Ultrametric tree for trait mapping, AMA_ASC/AMA |
| `Swords12_AMA_KYH_supercontigs_60dip_KYH_ultrametric.tre` | Ultrametric tree for trait mapping, AMA_KYH/KYH |
| `Swords12_AMA_MAD_supercontigs_60dip_MAD_ultrametric.tre` | Ultrametric tree for trait mapping, AMA_MAD/MAD |
| `Swords12_*_60dip_*_astral.tre` | ASTRAL species trees, per hypothesis and subgenome (16 files) |
| `Swords12_*_60dip_*_concat.treefile` | ML concatenation trees (16 files) |
| `Swords12_*_60dip_*_concord2.treefile` | Concordance factor trees (16 files) |
| `Swords12_*_60dip_*_contree.treefile` | Bootstrap consensus trees (16 files) |

## Scripts

| Script | Description |
|---|---|
| `subset_swords12.sh` | Subset 12 silversword sequences from HybPiper output |
| `subset_60dip.sh` | Subset 60 diploid outgroup sequences from HybPiper output |
| `HybPiperJensia.bat` | HybPiper assembly for *Jensia* supercontig sequences |
| `Mafft12.bat` | MAFFT alignment — no-outgroup analyses (SLURM array) |
| `TrimAl12.bat` | TrimAl trimming — no-outgroup analyses (SLURM array) |
| `IQTree12.bat` | IQ-Tree — no-outgroup analyses (SLURM array) |
| `ASTRAL12.bat` | ASTRAL — no-outgroup analyses |
| `MafftSwords12_60dip.bat` | MAFFT alignment — 60-diploid outgroup analyses (SLURM array) |
| `TrimAlSwords12_60dip.bat` | TrimAl trimming — 60-diploid outgroup analyses (SLURM array) |
| `IQTreeSwords12_60dip.bat` | IQ-Tree — 60-diploid outgroup analyses (SLURM array) |
| `ASTRALSwords12_60dip.bat` | ASTRAL — 60-diploid outgroup analyses |
| `batch_piper_assemble_Silversword_AMA_ASC.sh` | HybPiper second pass — assemble AMA_ASC phased reads |
| `batch_piper_assemble_Silversword_AMA_KYH.sh` | HybPiper second pass — assemble AMA_KYH phased reads |
| `batch_piper_assemble_Silversword_AMA_MAD.sh` | HybPiper second pass — assemble AMA_MAD phased reads |
| `batch_piper_assemble_Silversword_KYH_MAD.sh` | HybPiper second pass — assemble KYH_MAD phased reads |
| `batch_piper_post_Silversword_AMA_ASC.sh` | HybPiper post-processing — AMA_ASC |
| `batch_piper_post_Silversword_AMA_KYH.sh` | HybPiper post-processing — AMA_KYH |
| `batch_piper_post_Silversword_AMA_MAD.sh` | HybPiper post-processing — AMA_MAD |
| `batch_piper_post_Silversword_KYH_MAD.sh` | HybPiper post-processing — KYH_MAD |
| `make_ultrametric.R` | Build ultrametric trees via `chronos()` |
| `trait_mapping.R` | Stochastic character mapping (phytools `make.simmap`) |
| `plot_traits.R` | Plot trait mapping figures |


## Software

| Tool | Version | Citation |
|---|---|---|
| HybPiper | 2.3.3 | Johnson et al. 2023 |
| HybPhaser | — | Nauheimer et al. 2021 |
| MAFFT | 7.525 | Katoh & Standley 2013 |
| TrimAl | 1.5 | Capella-Gutierrez et al. 2009 |
| IQ-Tree | 3.0.0 | Minh et al. 2020 |
| ASTRAL | 5.7.8 | Zhang et al. 2018 |
| ape | 5.0 | Paradis & Schliep 2019 |
| phytools | 2.5.2 | Revell 2024 |
| ChromEvol | 2.0 | Glick & Mayrose 2014; Rice & Mayrose 2020 |
| Adobe Photoshop | 27.4.0 | — |

## Notes

- Locus 64734 was excluded from KYH_MAD exon analyses (only 2 sequences recovered).
- The `_R_` prefix introduced by MAFFT `--adjustdirection` was stripped from sequence headers before ASTRAL to avoid inflated tip counts.
- *Jensia rammii* and *J. yosemitana* supercontig sequences were assembled de novo from raw reads using HybPiper and added to existing alignments using
  `mafft --add --keeplength`.

---

## Citation

Baldwin, B.G., Fawcett, S., Kostic, A., Wessa, B.L. and Freyman, W.A., 2026. A tribal‐scale phylogenomic perspective on ancestry and major lineages of the allotetraploid Hawaiian silversword alliance (Madieae, Compositae). American Journal of Botany, p.e70284.

