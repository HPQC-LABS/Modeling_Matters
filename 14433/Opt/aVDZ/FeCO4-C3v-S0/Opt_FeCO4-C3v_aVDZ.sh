#!/bin/bash
#SBATCH --job-name=Opt_FeCO4-C3v_aVDZ.sh
#SBATCH --time=336:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --output=Opt_FeCO4-C3v_aVDZ.out
#SBATCH --error=Opt_FeCO4-C3v_aVDZ.err

JOBPATH=$(realpath .)
start_time="$(date -u +%s)"
. /home/$USER/.bashrc

echo "Successfully made it to $(hostname)! TIME: $(date +%Ec)"

module load openmpi/4.1.1 cfour/2.1

CFOUROUTPUT=Opt_FeCO4-C3v_aVDZ.out
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
echo "Attempting to make Opt_FeCO4-C3v_aVDZ20250829094852 in $CFOURSCRATCH/...  TIME: $(date +%Ec)"

mkdir Opt_FeCO4-C3v_aVDZ20250829094852
if [ -e Opt_FeCO4-C3v_aVDZ20250829094852/ ]; then
	echo "Success! TIME: $(date +%Ec)"
else
	echo "Aborting script. TIME: $(date +%Ec)"
	exit
fi

cd Opt_FeCO4-C3v_aVDZ20250829094852

cp $JOBPATH/ZMAT .
cp $JOBPATH/GENBAS .

echo "Attempting to run CFour... TIME: $(date +%Ec)"
xclean
xcfour > Opt_FeCO4-C3v_aVDZ.out
echo "CFour finished! TIME: $(date +%Ec)"

echo "Attempting to copy back files from $CFOURSCRATCH... TIME: $(date +%Ec)"
cp Opt_FeCO4-C3v_aVDZ.out $JOBPATH/Opt_FeCO4-C3v_aVDZ.out

echo "Attempting to clean $CFOURSCRATCH... save is False. TIME: $(date +%Ec)"
cd ../
rm -rf Opt_FeCO4-C3v_aVDZ20250829094852

if [[ -L "GENBAS" ]]; then unlink GENBAS; fi

echo "Total of $(($(date -u +%s)-$start_time)) seconds elapsed for this process."
