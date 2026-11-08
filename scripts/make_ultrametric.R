#!/usr/bin/env Rscript
# make_ultrametric.R
# Re-estimates branch lengths on ASTRAL topology using IQ-Tree (-te),
# then makes ultrametric with chronos() for ChromEvol and phytools trait mapping.
# Step 1: Run IQ-Tree with -te to fix ASTRAL topology, estimate ML branch lengths
# Step 2: Read resulting treefile, apply chronos()
# No calibration points -- penalized likelihood rate smoothing only

library(ape)

WORKDIR <- "."  # set to your working directory
CDIR    <- WORKDIR
IQDIR   <- file.path(ANALYSIS, "12_swords")  # set to your analysis directory
OUTDIR  <- WORKDIR

analyses <- list(
    list(
        astral  = file.path(IQDIR, "Swords12_AMA_ASC_supercontigs_60dip/AMA/ASTRAL/astral.tre"),
        aln     = file.path(IQDIR, "Swords12_AMA_ASC_supercontigs_60dip/AMA/IQTree/filtered_loci"),
        prefix  = file.path(OUTDIR, "Swords12_AMA_ASC_supercontigs_60dip_AMA_brlen"),
        out     = file.path(OUTDIR, "Swords12_AMA_ASC_supercontigs_60dip_AMA_ultrametric.tre"),
        name    = "AMA_ASC / AMA"
    ),
    list(
        astral  = file.path(IQDIR, "Swords12_AMA_KYH_supercontigs_60dip/KYH/ASTRAL/astral.tre"),
        aln     = file.path(IQDIR, "Swords12_AMA_KYH_supercontigs_60dip/KYH/IQTree/filtered_loci"),
        prefix  = file.path(OUTDIR, "Swords12_AMA_KYH_supercontigs_60dip_KYH_brlen"),
        out     = file.path(OUTDIR, "Swords12_AMA_KYH_supercontigs_60dip_KYH_ultrametric.tre"),
        name    = "AMA_KYH / KYH"
    ),
    list(
        astral  = file.path(IQDIR, "Swords12_AMA_MAD_supercontigs_60dip/MAD/ASTRAL/astral.tre"),
        aln     = file.path(IQDIR, "Swords12_AMA_MAD_supercontigs_60dip/MAD/IQTree/filtered_loci"),
        prefix  = file.path(OUTDIR, "Swords12_AMA_MAD_supercontigs_60dip_MAD_brlen"),
        out     = file.path(OUTDIR, "Swords12_AMA_MAD_supercontigs_60dip_MAD_ultrametric.tre"),
        name    = "AMA_MAD / MAD"
    )
)

for (a in analyses) {
    cat("\nProcessing:", a$name, "\n")

    # Step 1: re-estimate branch lengths on ASTRAL topology
    cmd <- paste("iqtree3 -te", a$astral,
                 "-p", a$aln,
                 "--prefix", a$prefix,
                 "-T AUTO --quiet")
    cat("  Running:", cmd, "\n")
    system(cmd)

    brlen_tree <- paste0(a$prefix, ".treefile")
    if (!file.exists(brlen_tree)) {
        cat("  ERROR: branch length tree not found:", brlen_tree, "\n"); next
    }

    # Step 2: make ultrametric
    tree <- read.tree(brlen_tree)
    cat("  Tips:", length(tree$tip.label), "\n")
    tree_ultra <- chronos(tree, lambda=1, model="correlated")
    cat("  is.ultrametric:", is.ultrametric(tree_ultra), "\n")
    write.tree(tree_ultra, file=a$out)
    cat("  Written:", basename(a$out), "\n")
}

cat("\nDone.\n")

# ── Relabel tips to canonical Tip_Label format ─────────────────────────────
cat("\nRelabeling tips to canonical format...\n")
master  <- read.csv(file.path(WORKDIR, "files/Madieae_Phylogenomics_Master.csv"),
                    stringsAsFactors=FALSE)
lookup  <- setNames(master$Tip_Label, master$HybPiper_ID)

for (a in analyses) {
    tree <- read.tree(a$out)
    tree$tip.label <- sapply(tree$tip.label, function(tip) {
        bare <- sub("_to_(AMA|ASC|KYH|MAD)$", "", tip)
        if (bare %in% names(lookup)) lookup[[bare]] else tip
    })
    write.tree(tree, a$out)
    cat("  Relabeled:", basename(a$out), "\n")
}
cat("Done.\n")
