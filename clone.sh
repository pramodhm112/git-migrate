#! /bin/bash

rm files/auth_source_links.csv > /dev/null 2>&1

sed "s#https://*#https://$susername:$stoken@#g" files/source_links.csv >> files/auth_source_links.csv

cd repos

while read line || [ -n "$line" ]
do
  repo=$(echo "$line" | sed -e 's/\r//g')
  
  git clone --bare $repo
  echo
done < "../files/auth_source_links.csv"

cd ..
