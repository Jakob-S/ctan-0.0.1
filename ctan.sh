#!/bin/bash -i

directory=/opt/ctan
URL="http://ftp.tu-chemnitz.de/pub/tex/macros/latex2e/contrib/"
TEX=`cat $directory/texmf.txt`
sudo mkdir /opt/ctan 2>/dev/null
sudo mkdir $directory 2>/dev/null
sudo mkdir $directory/tmp 2>/dev/null
sudo chown -R $USER:$USER $directory
help_msg() {
	echo "Usage: ctan <operations> [...]"
	echo "operations:"
	echo "        -h|--help			Print this help message"
	echo "        -s|--search {pkg|string}	Search package by specific name or string"
	echo "        -l|--list			List available packages"
	echo "        -i|--install {pkg}		Install specific package"
	echo "        -u|--update			Update packages.list from the FTP of tu-chemnitz"
	echo "        -c|--changelog {pkg}		View CHANGELOG of specific package"
	echo "        -d|--directory 			Change default directory for texmf"
	echo "        -cd|--check-directory		Check path of the texmf-directory"
	echo "        -a|--already			List already installed packages"
	exit 1
}

installed() {
	installed_packages=`ls $TEX`
	echo $installed_packages > $directory/installed.list
}

update() {
	
	wget -c -O $directory/packages.list "http://ftp.tu-chemnitz.de/pub/tex/macros/latex2e/contrib/"
	cat $directory/packages.list | grep 'class="f"' | grep -Po '<a.*>\K.*(?=<\/a>)'  | grep -v zip > $directory/sources.list
	mv $directory/sources.list $directory/packages.list
	installed
}

directory() {
	echo "Enter the path to your texmf-directory. "
	read -e -p "Path: "  path
	echo $path >  $directory/texmf.txt
}


##### Program logic starts here #####

new=`cat $directory/new.txt`
if [ $new == "True" ]; then
	directory
	update
	echo "False" > $directory/new.txt
fi


while test $# -gt 0; do
	case "$1" in
	-h|--help)	help_msg;;
	-s|--search)
		pkg=$2
		if grep -qw "$pkg" $directory/packages.list; then
			README=$URL/$pkg/README
			if curl --output /dev/null --silent --head --fail $README; then
				sudo wget -c -O $directory/tmp/README $README 2>/dev/null
				cat $directory/tmp/README
				sudo rm $directory/tmp/README
			else
				echo "Package exists, but there's actually no README available"
			fi
			README=$URL/$pkg/README.md
			if curl --output /dev/null --silent --head --fail $README; then
				sudo wget -c -O $directory/tmp/README $README 2>/dev/null
				cat $directory/tmp/README
				sudo rm $directory/tmp/README
			else
				echo "Package exists, but there's actually no README.md available"
			fi
			README=$URL/$pkg/README.txt
			if curl --output /dev/null --silent --head --fail $README; then
				sudo wget -c -O $directory/tmp/README $README 2>/dev/null
				cat $directory/tmp/README
				sudo rm $directory/tmp/README
			else
				echo "Package exists, but there's actually no README.txt available"
			fi
			PDFDoc=$URL$pkg/$pkg-doc.pdf
			PDF=$URL$pkg/$pkg.pdf
			if curl --output /dev/null --silent --head --fail $PDFDoc; then
				while true
				do
					read -p "Wanna open $PDFDoc in your default web browser? " answer
					case $answer in 
						[yY]* )	xdg-open $PDFDoc
							break;;
						[nN]*)	exit;;
						* )	echo "Dude, just enter [yY] or [nN] please...";;
					esac
					
				done
			fi
			if curl --output /dev/null --silent --head --fail $PDF; then
				while true
				do
					read -p "Wanna open $PDFDoc in your default web browser? " answer
					case $answer in 
						[yY]* )	xdg-open $PDF
							break;;
						[nN]*)	exit;;
						* )	echo "Dude, just enter [yY] or [nN] please...";;
					esac
					
				done
			fi
		else
			if grep $pkg $directory/packages.list; then
				grep $pkg $directory/packages.list
			else
				echo "There's no package containing $pkg"
			fi
		fi 
		exit 1;;
	-l|--list)
		cat $directory/packages.list;
		exit 1;;
	-a|--already)
		ls $TEX
		exit 1;;
	-cd|--check-directory)
		cat $directory/texmf.txt
		exit 1;;
	-i|--install)
		pkg=$2
		if grep -qw "$pkg" $directory/packages.list; then
			STY=$URL/$pkg/$pkg.sty
			if curl --output /dev/null --silent --head --fail $STY; then
				sudo mkdir $TEX/$pkg
				sudo wget -c -O $TEX/$pkg/$pkg.sty $STY
				sudo texhash
			else
				echo "$pkg.sty not existing"
			fi
			INS=$URL/$pkg/$pkg.ins
			DTX=$URL/$pkg/$pkg.dtx
			if curl --output /dev/null --silent --head --fail $INS; then
				sudo mkdir $TEX/$pkg
				sudo wget -c -O $TEX/$pkg/$pkg.ins $INS
				sudo wget -c -O $TEX/$pkg/$pkg.dtx $DTX
				sudo latex $TEX/$pkg/$pkg.ins
				sudo texhash
				clear
				req_pkg=`cat $TEX/$pkg/$pkg.dtx | grep Require | grep -oP '\{\K[^\}]+' | grep -v Requirements`
				echo "These packages are required by $pkg:"
				echo -e '\033[31m' "$req_pkg" '\033[39m '
			else
				echo "$pkg.ins not existing"
			fi
		else
			echo "Package $pkg not existing"
		fi
		installed
		exit;;
	-u|--update)	update
							exit;;
	-r|--remove)
		pkg=$2
		if grep -qw "$pkg" $directory/installed.list; then
			while true
				do
					read -p "You really wanna remove $pkg?: " answer
					case $answer in 
						[yY]* )	
							sudo rm -rf $TEX/$pkg
							sudo texhash
							break;;
						[nN]*)	exit;;
						* )	echo "Dude, just enter [yY] or [nN] please...";;
					esac
					
				done
		else
			echo " Package $pkg not existing"
		fi
		installed
		exit 1;;
	-d|--directory)	directory;;
	-c|--changelog)
		pkg=$2
		if grep -qw "$pkg" $directory/packages.list; then
			changelog=$URL/$pkg/CHANGELOG
			if curl --output /dev/null --silent --head --fail $changelog; then
				sudo wget -c -O $directory/tmp/CHANGELOG $URL/$pkg/CHANGELOG 2>/dev/null
				
				cat $directory/tmp/CHANGELOG
				sudo rm $directory/tmp/CHANGELOG
				exit 1
			else
				echo "Package exists, but there's actually no CHANGELOG available"
			fi
			changelog=$URL/$pkg/ChangeLog
			if curl --output /dev/null --silent --head --fail $changelog; then
				sudo wget -c -O $directory/tmp/CHANGELOG $URL/$pkg/CHANGELOG 2>/dev/null
				
				cat $directory/tmp/CHANGELOG
				sudo rm $directory/tmp/CHANGELOG
				exit 1
			else
				echo "Package exists, but there's actually no ChangeLog available"
			fi
		else
			echo "There's no package called $pkg"
		fi 
		exit;;
	*)
		echo "There's no parameter called $1";
		exit 1;;
	esac 
done
