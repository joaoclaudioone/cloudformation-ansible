#!/bin/bash
cd /app/bin

umask 027
JAR=`ls *jar`
DIRNAME=`dirname $0`
HOME=`cd $DIRNAME/../; pwd`

exec java -jar ${JAR} server
