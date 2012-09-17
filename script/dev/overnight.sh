#!/bin/sh

DATE=`date +%d%m%Y`
export DATE

cd $GIT_SERVER_REPOSITORY
#stash any local changes
git stash

#check if there is any local changes
STASH_LIST="$(git stash list)"
#this if will output a error msg when STASH_LIST is not empty, but the operation is still correct.
if [ -z ${STASH_LIST:-""} ]
then 
	#pull changes from repo
	git pull $GIT_REMOTE_NAME $GIT_REMOTE_BRANCH
	exit 0
else
        #any local changes should be reported.
        git stash show -p > DIRTY_CHANGE_${DATE}_OVERNIGHT.patch
        git stash pop
        #output error messages
        exec 1>&2
        echo "Dirty change found and put in DIRTY_CHANGE_${DATE}_OVERNIGHT.patch"
        echo "release failed because local changes exist, please refer to DIRTY_CHANGE_${DATE}_OVERNIGHT.patch to retify"
	mail -s "DIRTY_CHANGE_${DATE}_OVERNIGHT.patch file exists in ${GIT_SERVER_REPOSITORY}" ${ALERT_EMAIL} < ${GIT_SERVER_REPOSITORY}/DIRTY_CHANGE_${DATE}_OVERNIGHT.patch
        exit 1
fi
