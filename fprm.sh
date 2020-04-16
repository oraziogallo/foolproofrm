#!/bin/bash
TRASH_DIR="/home/"$USER"/.trash_foolproof_rm/"

usage() {
  cat << EOF >&2
Usage: rm [OPTION]... [FILE]...
Remove (safely move to trash) the FILE(s).

-f      [NOT IMPLEMENTED] ignore nonexistent files and arguments, never prompt
-v      verbose (for debugging)
-r      remove directories and their contents recursively
-D      remove forever
EOF
  exit 1
}

now=$(date +'%F-%T')

# If the trash folder does not exist, create it.
if [[ ! -d $TRASH_DIR ]]
then
    mkdir $TRASH_DIR
fi

# Parse the inputs
while getopts fvrD o
do
  case $o in
    f) force=1;;
    v) verbose=1;;
    r) recursive=1;;
    D) remove=1;;
    *) usage
  esac
done
shift "$((OPTIND - 1))"
file="$@"

# If the feared -D argument was passed, just call rm
if [[ $remove ]]; then
  /bin/rm -rf "$@"
  exit 0
fi

for file; do
  out_file_name="$TRASH_DIR/$now-$file"
  if [[ -f $file ]]
  then
    if [[ -w $file || $force ]]; then
      go_ahead=1
    else
      read -p "rm: remove write-protected regular file '$file'? " answer
      case ${answer:0:1} in
          y|Y) go_ahead=1;;
      esac
    fi
    if [[ $go_ahead ]]; then
      mv $file $out_file_name
    fi
  fi
  if [[ -d $file ]]
  then
    if [[ ! $recursive ]]
    then 
      echo "rm: cannot remove '$file': Is a directory"
    else
      mv $file $out_file_name
    fi
  fi
done


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