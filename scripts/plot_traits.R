#!/usr/bin/env Rscript
library(ape)
library(phytools)

WORKDIR <- "."  # set to your working directory
CDIR <- WORKDIR
OUTPDF <- file.path(CDIR, "Silversword_Trait_Mapping_ARD_3trees.pdf")

trait_labels <- c(
    habit         = "Growth habit (0=annual, 1=perennial)",
    ray_expression = "Ray expression (0=absent, 1=present)",
    pappus        = "Pappus (0=absent, 1=present)",
    SI            = "Self-incompatibility (0=SC, 1=SI)",
    disk_bisexual = "Disk flowers bisexual (0=no, 1=yes)"
)

cols <- setNames(c("#377EB8","#E41A1C"), c("0","1"))

pdf(OUTPDF, width=8.5, height=11)

for (tree_name in c("AMA_ASC","AMA_KYH","AMA_MAD")) {
    for (trait in names(trait_labels)) {
        rds <- file.path(CDIR, paste0("simmap_", tree_name, "_", trait, ".rds"))
        if (!file.exists(rds)) { cat("Skipping:", basename(rds), "\n"); next }
        sm <- readRDS(rds)
        pd <- describe.simmap(sm, plot=FALSE)

        tr <- sm[[1]]

        title_str <- paste0(tree_name, " supercontigs\n", trait_labels[trait])

        plot.phylo(tr, type="cladogram", use.edge.length=FALSE, align.tip.label=TRUE,
                   show.tip.label=TRUE, cex=0.55, font=1,
                   edge.color="grey50", edge.width=1.5,
                   no.margin=FALSE, main=title_str, cex.main=0.85,
                   label.offset=0.5)

        tip_states <- sapply(tr$tip.label, function(t) {
            if (t %in% rownames(pd$tips)) names(which.max(pd$tips[t,])) else NA
        })
        tiplabels(pch=21, bg=cols[tip_states], col="grey30", cex=0.8)
        nodelabels(pie=pd$ace, piecol=cols, cex=0.35)
        legend("bottomleft", legend=c("state 0","state 1"),
               fill=cols, bty="n", cex=0.8)
    }
}

dev.off()
cat("Written:", OUTPDF, "\n")
