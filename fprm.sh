#!/bin/bash

# Fool-proof rm
# Copyright (C) 2020  Orazio Gallo
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
# IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

TRASH_DIR="/home/"$USER"/.trash_foolproofrm"
VERSION="0.2"

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
flags=""
while getopts fvrhTDE o
do
  case $o in
    f) force=1; flags+=$o;;
    v) verbose=1; flags+=$o;;
    r) recursive=1; flags+=$o;;
    D) remove=1;;
    E) clear_trash;;
    h|*) usage; exit 0;
  esac
done
shift "$((OPTIND - 1))"
file="$@"

if [[ $# -eq 0 ]]; then
  echo "Missing operand"
  usage
  exit 1
fi

# If the feared -D argument was passed, just call rm
if [[ $remove ]]; then
  if [[ ${#flags} -gt 0 ]]; then
    flags="-"$flags
  fi
  eval "/bin/rm $flags $@"
  exit $?
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
