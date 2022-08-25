#!/bin/bash
# Launch pytorch distributed in a software environment or container
#
# (c) 2022, Eric Stubbs
# University of Florida Research Computing

#SBATCH --wait-all-nodes=1
#SBATCH --job-name=
#SBATCH --mail-type=NONE
#SBATCH --mail-user=
#SBATCH --nodes=
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-task=
#SBATCH --cpus-per-task=
#SBATCH --mem=
#SBATCH --partition=gpu
#SBATCH --constraint=
#SBATCH --time=00:20:00
#SBATCH --output=pytorchdist_%j



# PYTHON SCRIPT
#==============

#This is the python script to run in the pytorch environment
COMMAND="/path/script_that_uses_pytorch_distributed_methods.py"



# LOAD PYTORCH SOFTWARE ENVIRONMENT
#==================================

## You can load a software environment or use a singularity container.
## CONTAINER="singularity exec --nv /path/to/container.sif" (--nv option is to enable gpu)
module load pytorch



# SPECIFICATIONS
#===============

# May need to change if port is used
export PORT=20000
export OMP_NUM_THREADS=1
# Communication variables for HiperGator
EXCLUDE_IB_LIST=mlx5_4,mlx5_5,mlx5_10,mlx5_11
export NCCL_IB_HCA=^${EXCLUDE_IB_LIST}
export NCCL_SOCKET_IFNAME=bridge-1145



# PRINTS
#=======
date; pwd; which python
export HOST=$(hostname -s)
NODES=$(scontrol show hostnames | grep -v $HOST | tr '\n' ' ')
echo "Host: $HOST" 
echo "Other nodes: $NODES"



# LAUNCH
#=======

echo "Starting $SLURM_GPUS_PER_TASK process(es) on each node..."

srun launch_node.sh "$CONTAINER" "$COMMAND"
