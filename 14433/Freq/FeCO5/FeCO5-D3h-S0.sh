#!/bin/bash
#SBATCH --job-name=FeCO5-D3h-S0.sh
#SBATCH --time=336:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --output=FeCO5-D3h-S0.out
#SBATCH --error=FeCO5-D3h-S0.err

JOBPATH=$(realpath .)
start_time="$(date -u +%s)"
. /home/$USER/.bashrc

echo "Successfully made it to $(hostname)! TIME: $(date +%Ec)"

module load openmpi/4.1.1 cfour/2.1

CFOUROUTPUT=FeCO5-D3h-S0.out
export CFOUR_NUM_CORES=${SLURM_NTASK}
export OMP_NUM_THREADS=32


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
echo "Attempting to make FeCO5-D3h-S020250529134124 in $CFOURSCRATCH/...  TIME: $(date +%Ec)"

mkdir FeCO5-D3h-S020250529134124
if [ -e FeCO5-D3h-S020250529134124/ ]; then
	echo "Success! TIME: $(date +%Ec)"
else
	echo "Aborting script. TIME: $(date +%Ec)"
	exit
fi

cd FeCO5-D3h-S020250529134124

cp $JOBPATH/ZMAT .
cp $JOBPATH/GENBAS .

echo "Attempting to run CFour... TIME: $(date +%Ec)"
xclean
xcfour > FeCO5-D3h-S0.out
echo "CFour finished! TIME: $(date +%Ec)"

echo "Attempting to copy back files from $CFOURSCRATCH... TIME: $(date +%Ec)"
cp FeCO5-D3h-S0.out $JOBPATH/FeCO5-D3h-S0.out

echo "Attempting to clean $CFOURSCRATCH... save is False. TIME: $(date +%Ec)"
cd ../
rm -rf FeCO5-D3h-S020250529134124

if [[ -L "GENBAS" ]]; then unlink GENBAS; fi

echo "Total of $(($(date -u +%s)-$start_time)) seconds elapsed for this process."
