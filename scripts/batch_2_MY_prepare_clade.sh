#!/bin/bash

# file batch_2_prepare_clade.sh
#

#SBATCH --job-name=prepare_clade
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --time=47:48:00

echo "SLURM_CPUS_PER_TASK = $SLURM_CPUS_PER_TASK"

# load modules:


## commands:

export WDIR=/path/to/working/dir/phaser/phaser_out_279

echo
echo "batch: WDIR = $PWD"

CMD="R -f bin/TEST_2a_prepare_bbsplit_script.R"

echo "batch: CMD=$CMD"

. $CMD

echo "DONE"
