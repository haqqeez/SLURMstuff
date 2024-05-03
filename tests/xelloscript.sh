#! /bin/bash

pwd=$(pwd)

test=$(find $pwd -type d -name "Miniscope" -o -name "Miniscope_2")

for i in $test
do
	if [[ "$i" == *"ZHA013"* ]]
	then
		cd $i
		if [ -f "ms.mat" ]
		then
			echo "DONE $i it is already analyzed"
			continue
		elif [ -f "timeStamps.csv" ]
		then
			echo "Analyzing $i"
			cp /home/haqqeez/Desktop/SLURMstuff/slurm.sh .
			cp /home/haqqeez/Desktop/SLURMstuff/msRun.txt .
			sleep 2
			./slurm.sh
		else
			echo "ERROR $i not compatible for analysis"
		fi
	fi
done
