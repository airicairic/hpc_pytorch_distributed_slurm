# hpc_pytorch_distributed_slurm

This script uses srun to launch the appropriate number of processes for pytorch distributed on multiple nodes in a SLURM cluster.

Designed to work with a container or a software environment loaded via lmod, the scripts enable launching your Python code that uses pytorch distributed methods. A process running your script is launched for each GPU on multiple nodes. The job_launch.sh is a template that should be completed with the required compute resources, path to your script, and software environment. Specifications, prints, and launch shouldn't need updates. The job_launch.sh script shouldn't need updates for most use cases.

Using the example on HiperGator
-------------------------------

1. Copy this example to your blue directory.

2. Update job_launch.sh
2.1. Add SBATCH options job-name, mail-user, nodes, gpus-per-task, cpus-per-task, mem, time, and output. ntasks-per-node or nproc-per-node (in launch_node.sh) may need to be updated for some use cases.
2.2. Add the path to your Python script as the command variable.
2.3. Adjust the module load or use a path to a container for the appropriate software environment.

3. Change your working directory to your version of the pytorch_distributed_template folder.

4. Run 'sbatch job_launch.sh'.


Implementation Note
-------------------
Your python command script necessarily must implement distributed methods.

Your can reference os.environ['SLURM_NODEID'] or os.environ['RANK'] for the global node rank if needed. --local-rank will be passed from the pytorch distributed launcher to your Python command script. You will need to parse this argument and use it to set the device id so that the process knows which GPU to access.

The job_launch.sh uses srun to run launch_node.sh on each node. 

On each node, job_launch.sh then creates one process for each gpu (using environment variable $SLURM_GPUS_PER_TASK). Each of the processes will run your Python command script after connecting to the host node.
