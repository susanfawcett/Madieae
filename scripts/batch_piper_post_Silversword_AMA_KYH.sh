#!/bin/bash

# file: batch_piper_post_Silversword_AMA_KYH.sh

#SBATCH --job-name=post_Silversword_3
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --partition=savio4_htc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:58:58

## commands:

export WDIR="${SCR}/piper/piper_out_Silversword_AMA_KYH"
cd $WDIR
echo "WDIR = $PWD"
echo

echo $SLURM_JOB_NODELIST |sed s/\,/\\n/g > hostfile

NAMELIST="../../lists/namelist_Silversword_AMA_KYH.txt"

../run_piper_post.sh $NAMELIST > piper_post.log
