#! /bin/bash

rm files/accappendreponames.csv > /dev/null 2>&1
rm files/reponames.csv > /dev/null 2>&1
rm files/exp_links.csv > /dev/null 2>&1

if [ -z "$susername" ] || [ -z "$stoken" ] || [ -z "$sdomain" ] || [ -z "$saccname" ] || [ -z "$dusername" ] || [ -z "$dtoken" ] || [ -z "$ddomain" ] || [ -z "$daccname" ] || [ -z "$dacctype" ] || [ -z "$appendusername" ]
	then 
    echo 'Inputs cannot be blank please try again'
    exit 0 
fi


while read line || [ -n "$line" ]
do
	string=$(echo "$line" | sed -e 's/\r//g')
	echo $string | awk -F "/"  'BEGIN {OFS= "-"} { print $4, $5}' >> files/accappendreponames.csv
	echo $string | awk -F "/"  'BEGIN {OFS= "-"} { print $5}' | awk -F "." '{print $1}' >> files/reponames.csv
done < "files/source_links.csv"

push_link="https://${dusername}:${dtoken}@${ddomain}/${daccname}/"

if [ $appendusername == yes ]
then
	echo "Export links generating..."
	while read line || [ -n "$line" ]
	do
		gitrepo=$(echo "$line" | sed -e 's/\r//g')
		e_link=${push_link}${gitrepo}".git"
		echo $e_link >> files/exp_links.csv	
	done < "files/accappendreponames.csv"
	out1=$(echo $?)
	if [ $out1 == 0 ]
	then
		echo "Export links Generation Successful"
	fi
else
	echo "Export links generating..."
	while read line || [ -n "$line" ]
	do
		
		gitrepo=$(echo "$line" | sed -e 's/\r//g')
		e_link=${push_link}${gitrepo}".git"
		echo $e_link >> files/exp_links.csv
	done < "files/reponames.csv"
	out1=$(echo $?)
	if [ $out1 == 0 ]
	then
		echo "Export links Generation Successful"
	fi
fi

if [ $dacctype == org ]
then
	while read line || [ -n "$line" ]
	do
		gitrepo=$(echo "$line" | sed -e 's/\r//g')
		status=$(curl -is -o /dev/null -w "%{http_code}" -H "Authorization: token ${dtoken}" -H "Accept: application/vnd.github.v3+json" -X POST "https://${ddomain}/api/v3/orgs/${daccname}/repos" -d '{"name":"'"$gitrepo"'","private": true}')
		if [ $status == "201" ]
		then
			echo Repo ${gitrepo} Created
		elif [ $status == "422" ]
		then
			echo Repo ${gitrepo} Exists
		else
			echo Repo ${gitrepo} Not Created
		fi
	done < "files/reponames.csv"

else
	while read line || [ -n "$line" ]
	do
		gitrepo=$(echo "$line" | sed -e 's/\r//g')
		status=$(curl -is -o /dev/null -w "%{http_code}" -H "Authorization: token ${dtoken}" -H "Accept: application/vnd.github.v3+json" -X POST "https://${ddomain}/api/v3/user/repos" -d '{"name":"'"$gitrepo"'","private": true}')
		if [ $status == "201" ]
		then
			echo Repo ${gitrepo} Created
		elif [ $status == "422" ]
		then
			echo Repo ${gitrepo} Exists
		else
			echo Repo ${gitrepo} Not Created
		fi
	done < "files/accappendreponames.csv"
fi
