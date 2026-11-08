#!/bin/bash

# file batch_3_phase.sh
#

#SBATCH --job-name=phase
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --time=13:48:00

echo "SLURM_CPUS_PER_TASK = $SLURM_CPUS_PER_TASK"

# load modules:


## commands:

export WDIR=/path/to/working/dir/phaser/phaser_out_279

echo
echo "batch: WDIR = $PWD"

CMD="R -f bin/3a_prepare_phasing_script.R"

echo "batch: CMD=$CMD"

. $CMD

echo "DONE"
