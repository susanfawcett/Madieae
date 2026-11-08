#!/bin/bash

# file batch_1_consensus_sing.sh
#
# this is the "single-core" version that will invoke 
# 1_generate_consensus_sequences_single-core.sh
# (yes, that is a hyphen between single & core)
#
# we actually assign 2 cores per sample, so that 18 nodes 
# with 32 cores each can process 279 samples all in paralel


#SBATCH --job-name=phaser_1_sing
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=4
#SBATCH --time=00:58:00

# load modules

module load samtools
module load bwa
module load bcftools

## commands:

export WDIR=/path/to/working/dir/phaser/phaser_out_Layia_2x2
cd $WDIR
echo
echo "WDIR = $PWD"
echo

echo $SLURM_JOB_NODELIST |sed s/\,/\\n/g > hostfile

export JOBS_PER_NODE=$(( $SLURM_CPUS_ON_NODE / $SLURM_CPUS_PER_TASK ))

echo "SLURM_CPUS_ON_NODE = $SLURM_CPUS_ON_NODE"
echo "SLURM_CPUS_PER_TASK = $SLURM_CPUS_PER_TASK"
echo "JOBS_PER_NODE = $JOBS_PER_NODE"
echo

 
CMD="parallel --sshdelay=0.1 --resume --jobs $JOBS_PER_NODE --slf hostfile --wd $WDIR --joblog phaser_1.log   -a $SCR/lists/namelist_Layia_2x2.txt  bash $SCR/phaser/run_1_consensus_sing.sh {}"

echo "batch:CMD=$CMD"

# run it now
$CMD

echo
echo "DONE"
