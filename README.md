# ctan-0.0.1
Simple CTAN library installer

Usage: ctan <operations> [...]
operations:
        -h|--help			Print this help message
        -s|--search {pkg|string}	Search package by specific name or string
        -l|--list			List available packages
        -i|--install {pkg}		Install specific package
        -u|--update			Update packages.list from the FTP of tu-chemnitz
        -c|--changelog {pkg}		View CHANGELOG of specific package
        -d|--directory 			Change default directory for texmf
        -cd|--check-directory		Check path of the texmf-directory
        -a|--already			List already installed packages
