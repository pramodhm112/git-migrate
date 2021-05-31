#! /bin/bash

export appendusername=no

if [ $appendusername == yes ]
then
	input_dir="../files/accappendreponames.csv"
else
	input_dir="../files/reponames.csv"
fi

cd repos

count=0
arr=()

while read line || [ -n "$line" ]
do
  dirc=$(echo "$line" | sed -e 's/\r//g')
  arr[$count]="$dirc"
  arr[$count]="${arr[${count}]}.git"
  count=$(($count+1))
done < "$input_dir"

sCount=0

while read line || [ -n "$line" ]
do
	repo=$(echo "$line" | sed -e 's/\r//g')
	if [ -d ${arr[${sCount}]} ]
	then
		cd ${arr[${sCount}]}
	fi
	sCount=$(($sCount+1))
	git push --mirror $repo
	echo
	out1=$(echo $?)
	if [ $out1 == 0 ]
	then
		cd .. 
	fi
done < "../files/exp_links.csv"
