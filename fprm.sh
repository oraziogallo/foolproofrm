#!/bin/bash
TRASH_DIR="/home/"$USER"/.trash_foolproofrm"
VERSION="0.1"

usage() {
  cat << EOF >&2
Usage: rm [OPTION]... [FILE]...
Remove (safely move to trash) the FILE(s).

-f      ignore nonexistent files and arguments, never prompt
-r      remove directories and their contents recursively
-v      verbose
-h      show this message
-D      remove forever
-E      empty trash

foolproofrm v$VERSION
EOF
  exit 1
}

clear_trash() {
  if [[ -d "$TRASH_DIR" ]]; then
    go_ahead=1
    if [[ ! "$force" ]]; then
      read -p "Permanently empty the trash folder? " answer
      case ${answer:0:1} in
          y|Y) go_ahead=1;;
          *) go_ahead=0;;
      esac
    fi
    if [[ $go_ahead -eq 1 ]]; then
      /bin/rm -rf "$TRASH_DIR"/*
    fi
    exit 0
  else
    echo "Trash directory not found."
    exit 1
  fi
}

now=$(date +'%F-%T')

# If the trash folder does not exist, create it.
if [[ ! -d $TRASH_DIR ]]
then
    mkdir $TRASH_DIR
fi

# Parse the inputs
while getopts fvrhTDE o
do
  case $o in
    f) force=1;;
    v) verbose=1;;
    r) recursive=1;;
    D) remove=1;;
    E) clear_trash;;
    h|*) usage;;
  esac
done
shift "$((OPTIND - 1))"
file="$@"

if [[ $# -eq 0 ]]; then
  echo "Missing operand"
  usage
fi

# If the feared -D argument was passed, just call rm
if [[ $remove ]]; then
  /bin/rm -rf "$@"
  exit 0
fi

for file; do
  # Properly handle spaces?
  # file=${file// /$'\ '}

  # Do not delete the trash folder
  if [[ "${file%/}" == "$TRASH_DIR" ]]; then
    echo "Cannot remove the trash folder itself. (-D to force)"
    exit 1
  fi
  
  # Target filename:
  # prepend date and flatten 
  out_file="$TRASH_DIR/$now-${file////$'__'}"

  # Files
  if [[ -f "$file" ]]; then
    if [[ -w "$file" || $force ]]; then
      go_ahead=1
    else
      read -p "rm: remove write-protected regular file '${file}'? " answer
      case ${answer:0:1} in
          y|Y) go_ahead=1;;
          *) go_ahead=0;;
      esac
    fi
    if [[ $go_ahead -eq 1 ]]; then
      if [[ $verbose ]]; then
        echo "Moving $file -> $out_file"
      fi
      mv -- "$file" "$out_file"
    fi
  fi

  # Directories
  if [[ -d "$file" ]]; then 
    if [[ ! $recursive ]]; then 
      echo "rm: cannot remove '${file}': Is a directory"
    else
      if [[ $verbose ]]; then
        echo "Moving $file/ -> $out_file"
      fi
      mv -- "$file" "$out_file"
    fi
  fi

done

exit 0

# Getops from the getops manual:
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/getopts.html
# aflag=
# bflag=
# while getopts ab: name
# do
#     case $name in
#     a)    aflag=1;;
#     b)    bflag=1
#           bval="$OPTARG";;
#     ?)   printf "Usage: %s: [-a] [-b value] args\n" $0
#           exit 2;;
#     esac
# done
# if [ ! -z "$aflag" ]; then
#     printf "Option -a specified\n"
# fi
# if [ ! -z "$bflag" ]; then
#     printf 'Option -b "%s" specified\n' "$bval"
# fi
# shift $(($OPTIND - 1))
# printf "Remaining arguments are: %s\n" "$*"


# Getops from Stackoverflow post:
# https://unix.stackexchange.com/questions/321126/dash-arguments-to-shell-scripts
# #! /bin/sh -
# PROGNAME=$0
# usage() {
#   cat << EOF >&2
# Usage: $PROGNAME [-v] [-d <dir>] [-f <file>]
# -f <file>: ...
#  -d <dir>: ...
#        -v: ...
# EOF
#   exit 1
# }
# dir=default_dir file=default_file verbose_level=0
# while getopts d:f:v o; do
#   case $o in
#     (f) file=$OPTARG;;
#     (d) dir=$OPTARG;;
#     (v) verbose_level=$((verbose_level + 1));;
#     (*) usage
#   esac
# done
# shift "$((OPTIND - 1))"
# echo Remaining arguments: "$@"