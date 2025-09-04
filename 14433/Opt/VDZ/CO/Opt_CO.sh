#!/bin/bash
#SBATCH --job-name=Opt_CO.sh
#SBATCH --time=336:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=4G
#SBATCH --output=Opt_CO.out
#SBATCH --error=Opt_CO.err

JOBPATH=$(realpath .)
start_time="$(date -u +%s)"
. /home/$USER/.bashrc

echo "Successfully made it to $(hostname)! TIME: $(date +%Ec)"

module load openmpi/4.1.1 cfour/2.1

CFOUROUTPUT=Opt_CO.out
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
echo "Attempting to make Opt_CO20250305112127 in $CFOURSCRATCH/...  TIME: $(date +%Ec)"

mkdir Opt_CO20250305112127
if [ -e Opt_CO20250305112127/ ]; then
	echo "Success! TIME: $(date +%Ec)"
else
	echo "Aborting script. TIME: $(date +%Ec)"
	exit
fi

cd Opt_CO20250305112127

cp $JOBPATH/ZMAT .
cp $JOBPATH/GENBAS .

echo "Attempting to run CFour... TIME: $(date +%Ec)"
xclean
xcfour > Opt_CO.out
echo "CFour finished! TIME: $(date +%Ec)"

echo "Attempting to copy back files from $CFOURSCRATCH... TIME: $(date +%Ec)"
cp Opt_CO.out $JOBPATH/Opt_CO.out

echo "Attempting to clean $CFOURSCRATCH... save is False. TIME: $(date +%Ec)"
cd ../
rm -rf Opt_CO20250305112127

if [[ -L "GENBAS" ]]; then unlink GENBAS; fi

echo "Total of $(($(date -u +%s)-$start_time)) seconds elapsed for this process."
