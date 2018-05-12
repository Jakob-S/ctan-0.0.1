#!/bin/bash

[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DIR="/opt/ctan"
mkdir $DIR
cp ctan.sh installed.list new.txt packages.list texmf.txt $DIR
mkdir $DIR/tmp