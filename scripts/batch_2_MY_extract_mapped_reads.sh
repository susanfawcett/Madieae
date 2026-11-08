#!/bin/bash

# file batch_2_MY_extract_mapped_reads.sh
#
#SBATCH --job-name=extract_mapped_reads
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:58:00

module load perl

export WDIR=/path/to/working/dir/phaser/phaser_out_279
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

CMD="parallel --sshdelay=0.1 --resume --jobs $JOBS_PER_NODE --slf hostfile --wd $WDIR --joblog extract_1.log   -a $SCR/lists/namelist_279.txt  bash $SCR/phaser/bin/2_MY_extract_mapped_reads.sh {}"

echo "batch: CMD=$CMD"
echo

. $CMD

echo "DONE"
