#!/bin/bash

[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DIR="/opt/ctan"
clear
mkdir $DIR
echo "Create directory $DIR"
cp ctan.sh $DIR
echo "Copy ctan.sh to $DIR"
mkdir $DIR/tmp
echo "Create directory $DIR/tmp"
chown -R $USER:$USER $DIR
echo "Change $USER's permissions for $DIR"
chmod +x $DIR/ctan.sh
echo "Make $DIR/ctan.sh executable"
touch $DIR/installed.list
touch $DIR/packages.list
touch $DIR/texmf.txt
touch $DIR/new.txt
echo "Create files in $DIR:"
echo "	installed.list"
echo "	packages.list"
echo "	texmf.txt"
echo "	new.txt"
echo "True" > $DIR/new.txt
echo "Define variables for first start."
echo " "
echo " "
echo "Please execute $DIR/ctan.sh --update to update the following files:"
echo "	installed.list (lists installed CTAN packages"
echo "	packages.list (lists available CTAN packages"
echo "	texmf.txt (contains the package directory"
echo "	new.txt (set to False)"