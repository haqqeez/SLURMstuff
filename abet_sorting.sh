#!/bin/bash

initials='ZHA'

pwdirectory=$(pwd)
data=$(find $pwdirectory -type d -name "Miniscope" -o -name "Miniscope_2")

for session in $data
do
	cd $session
	abetcheck=$(find -type f -name "*_abet.csv" | wc -l)
	if [ $abetcheck == 0 ]
	then
		ID=$initials${session#*$initials}
		ID=${ID::6}
		date=202${session#*202}; date=${date::10}
		ID=$(echo ${ID}_${date})

		abetfile=$(find /lustre03/project/rpp-markpb68/m3group/Haqqee/data/ABET/Batch_4/Renamed -type f -name "*$ID*_abet.csv")
		filecount=$(printf '%s\n' $abetfile | wc -l)

		if (( $filecount == 1 ))
		then
			cp $abetfile .
			echo "Moved $abetfile to $session"
		elif (( $filecount < 1 ))
		then
			echo "Cannot find ABET file for $ID"
		elif (( $filecount > 1 ))
		then
			cd ../../
			abetcheckagain=$(find -type f -name "*_abet.csv" | wc -l)
			if [ $abetcheckagain == 0 ]
			then
				for file in $abetfile
				do
					cp $file .
					echo "MULTIPLE files copied: $file to $(pwd). Please manually sort these!"
				done
			else
				echo "WARNING! Multiple files already exist unsorted outside $session. Please manually sort them!"
			fi
		fi
	else
		echo "Good; $session already has an ABET file"
	fi
done
