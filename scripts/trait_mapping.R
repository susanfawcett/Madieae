#!/usr/bin/env Rscript
# trait_mapping.R
# Ancestral state reconstruction for discrete morphological traits across
# the Hawaiian silversword alliance using stochastic character mapping.
# phytools make.simmap, ARD model, 100 simulations.
# Ultrametric trees from IQTree concat ML + chronos() rate smoothing.
# Three SC trees (AMA_ASC/AMA, AMA_KYH/KYH, AMA_MAD/MAD) bracket topological variation.
# Tip labels: canonical Genus_species_voucher from Madieae_Phylogenomics_Master.csv
# Authors: Baldwin, Fawcett et al. (in prep.)

library(ape)
library(phytools)

WORKDIR <- "."  # set to your working directory
CDIR <- WORKDIR

traits <- read.table(file.path(CDIR, "traits_12_Swords_canonical.txt"),
                     header=TRUE, sep="\t", row.names=1,
                     na.strings=c("NA",""), check.names=FALSE)

trees <- list(
    AMA_ASC = read.tree(file.path(CDIR, "Swords12_AMA_ASC_supercontigs_60dip_AMA_ultrametric.tre")),
    AMA_KYH = read.tree(file.path(CDIR, "Swords12_AMA_KYH_supercontigs_60dip_KYH_ultrametric.tre")),
    AMA_MAD = read.tree(file.path(CDIR, "Swords12_AMA_MAD_supercontigs_60dip_MAD_ultrametric.tre"))
)

discrete_traits <- c("habit", "ray expression", "pappus", "SI", "disk bisexual")

set.seed(42)

for (tree_name in names(trees)) {
    tr <- trees[[tree_name]]
    cat("\n===", tree_name, "===\n")
    cat("  Tips:", length(tr$tip.label), "\n")
    cat("  Ultrametric:", is.ultrametric(tr), "\n")

    # Root on Venegasia
    if ("Venegasia_carpesioides_BGB893" %in% tr$tip.label)
        tr <- root(tr, outgroup="Venegasia_carpesioides_BGB893", resolve.root=TRUE)

    for (trait in discrete_traits) {
        if (!trait %in% colnames(traits)) {
            cat("Trait not found:", trait, "\n"); next
        }
        x <- setNames(traits[[trait]], rownames(traits))
        x <- x[!is.na(x) & names(x) %in% tr$tip.label]
        if (length(unique(x)) < 2) {
            cat("Skipping", trait, "(invariant)\n"); next
        }
        tr_sub <- drop.tip(tr, setdiff(tr$tip.label, names(x)))
        x <- x[tr_sub$tip.label]
        x <- factor(x)
        cat("\n---", trait, "| n =", length(x),
            "| states:", paste(levels(x), collapse="/"), "---\n")
        tryCatch({
            fit <- fitMk(tr_sub, x, model="ARD")
            cat("ARD AIC:", round(AIC(fit), 2), "\n")
            simmap <- make.simmap(tr_sub, x, model="ARD", nsim=100, pi="estimated")
            pd <- describe.simmap(simmap, plot=FALSE)
            cat("Root state:\n"); print(round(pd$ace[1,], 3))
            trait_safe <- gsub("[^A-Za-z0-9]", "_", trait)
            rds <- file.path(CDIR,
                paste0("simmap_", tree_name, "_", trait_safe, ".rds"))
            saveRDS(simmap, rds)
            cat("Saved:", basename(rds), "\n")
        }, error=function(e) cat("ERROR:", conditionMessage(e), "\n"))
    }
}
cat("\n=== All done ===\n")
