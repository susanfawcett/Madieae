#!/bin/bash

# file batch_piper_assemble_Silversword_AMA_ASC.sh

#SBATCH --job-name=piper_assemble_3
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=YOUR_PARTITION
#SBATCH --nodes=17
#SBATCH --cpus-per-task=4
#SBATCH --time=09:58:00

## commands:

export WDIR=/path/to/working/dir/piper/piper_out_Silversword_AMA_ASC
cd $WDIR
echo "WDIR = $PWD"
echo

echo $SLURM_JOB_NODELIST |sed s/\,/\\n/g > hostfile

export JOBS_PER_NODE=$(( $SLURM_CPUS_ON_NODE / $SLURM_CPUS_PER_TASK ))

CMD="parallel --resume --jobs $JOBS_PER_NODE --slf hostfile --wd $WDIR --joblog piper_assemble_phased.log -a ../../lists/namelist_Silversword_AMA_ASC.txt  bash ../run_piper_assemble_AMA_ASC.sh {}"

echo "batch: CMD=$CMD"
echo

$CMD

echo
echo "DONE"
echo
