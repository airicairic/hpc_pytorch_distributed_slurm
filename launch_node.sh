#!/bin/bash
CONTAINER=$1
COMMAND=$2
if [ -z "$COMMAND" ]
then
    COMMAND=$1
    CONTAINER=""
fi
    
$CONTAINER python -m torch.distributed.launch \
              --nproc_per_node=$SLURM_GPUS_PER_TASK \
              --nnodes=$SLURM_JOB_NUM_NODES \
              --node_rank=$SLURM_NODEID \
              --master_addr=$HOST \
              --master_port=$PORT \
              $COMMAND
