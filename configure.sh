#!/bin/bash

[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DIR="/opt/ctan"
mkdir $DIR
cp ctan.sh $DIR
mkdir $DIR/tmp
chown -R $USER:$USER $DIR
chmod +x $DIR/ctan.sh
touch $DIR/installed.list
touch $DIR/packages.list
touch $DIR/texmf.txt
touch $DIR/new.txt
echo "True" > $DIR/new.txt
$DIR/ctan.sh