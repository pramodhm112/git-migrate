#! /bin/bash

export susername=$susername
export stoken=$stoken
export sdomain=$sdomain
export saccname=$saccname

export dusername=$username
export dtoken=$token
export ddomain=$domain
export daccname=$accname
export dacctype=$dacctype
export appendusername=$appendusername

./prepare.sh

./clone.sh

./push.sh
