#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --gres=gpu:1
#SBATCH --job-name=correlation
#SBATCH --out=correlation.out
#SBATCH --error=correlation.err
#SBATCH --mail-type=all
#SBATCH --mail-user=reza.kolasangiani@utah.edu
#SBATCH --account=bidone-gpu-np
#SBATCH --partition=bidone-gpu-np


####### NOTE: change --gres=gpu:4 to --gres=gpu:2 (if on lonepeak change it to 8) (never use 3 or another higher odd number, performance is bad)
# Use gromacs
module purge
module load gcc/11.2.0-gpu openmpi/4.1.4 gromacs/2022.3-gpu


#Source correlationplus:
source /uufs/chpc.utah.edu/common/home/u1362540/corrPlusEnv/bin/activate



# Define an array of the directories to loop over
directories=(
    "1.AlphaVBeta3/forcepull_bothfc0_replica1"
    "1.Alpha2bBeta3/forcepull_bothfc0_replica1"
 
 
)




# Loop over the directories and perform the commands
for directory in "${directories[@]}"; do
    cd "$directory"

correlationplus calculate -p protein.pdb -f combineallnopbc3.xtc -t ndcc -o ../../correlationplus/ndcc_"${directory//\//_}"
correlationplus visualize -p protein.pdb -t ndcc -i ../../correlationplus/ndcc_"${directory//\//_}".dat -o ../../correlationplus/0.ndcc_"${directory//\//_}"


 cd ../..
done






#   "1.AlphaVBeta3/bending_bothfc0_replica1"
#    "1.AlphaVBeta3/bending_bothfc0_replica2"
#    "1.AlphaVBeta3/bending_bothfc0_replica3"
#    "1.Alpha2bBeta3/bending_bothfc0_replica1"
#    "1.Alpha2bBeta3/bending_bothfc0_replica2"
#    "1.Alpha2bBeta3/bending_bothfc0_replica3"
























