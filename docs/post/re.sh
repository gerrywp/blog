#!/bin/bash

for filename in `ls`
do
datestr=`echo ${filename}|tr -d '-'|cut -c1-8|grep '^[0-9]\{8\}$'`
if [ "${datestr}" != "" ]; then
newname=`echo ${filename}|tr -d '-'`
newname=${newname:2}
git mv "${filename}" "${newname}"
fi
done
exit 0