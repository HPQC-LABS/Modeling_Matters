#!/bin/bash
#SBATCH --job-name=CO.sh
#SBATCH --time=336:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --output=CO.out
#SBATCH --error=CO.err

JOBPATH=$(realpath .)
start_time="$(date -u +%s)"
. /home/$USER/.bashrc

echo "Successfully made it to $(hostname)! TIME: $(date +%Ec)"

module load openmpi/4.1.1 cfour/2.1

CFOUROUTPUT=CO.out
export CFOUR_NUM_CORES=${SLURM_NTASK}
export OMP_NUM_THREADS=4


if [ ! -e $CFOURSCRATCH/ ]; then
	echo "Attempting to make $CFOURSCRATCH... TIME: $(date +%Ec)"
	mkdir $CFOURSCRATCH/
	if [ -e $CFOURSCRATCH/ ]; then
		echo "Success! TIME: $(date +%Ec)"
		chmod -R 777 $CFOURSCRATCH/
	else
		echo "Failure. Aborting... TIME: $(date +%Ec)"
		exit
	fi

fi

cd $CFOURSCRATCH/
echo "Attempting to make CO20250529134306 in $CFOURSCRATCH/...  TIME: $(date +%Ec)"

mkdir CO20250529134306
if [ -e CO20250529134306/ ]; then
	echo "Success! TIME: $(date +%Ec)"
else
	echo "Aborting script. TIME: $(date +%Ec)"
	exit
fi

cd CO20250529134306

cp $JOBPATH/ZMAT .
cp $JOBPATH/GENBAS .

echo "Attempting to run CFour... TIME: $(date +%Ec)"
xclean
xcfour > CO.out
echo "CFour finished! TIME: $(date +%Ec)"

echo "Attempting to copy back files from $CFOURSCRATCH... TIME: $(date +%Ec)"
cp CO.out $JOBPATH/CO.out

echo "Attempting to clean $CFOURSCRATCH... save is False. TIME: $(date +%Ec)"
cd ../
rm -rf CO20250529134306

if [[ -L "GENBAS" ]]; then unlink GENBAS; fi

echo "Total of $(($(date -u +%s)-$start_time)) seconds elapsed for this process."
