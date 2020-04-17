#!/bin/bash

# TODO: make sure that the alias is not there yet. 
if [ -f ~/.bash_aliases ]; then
    echo "alias rm='$PWD/fprm.sh'" >> ~/.bash_aliases
else
    echo "alias rm='$PWD/fprm.sh'" > ~/.bash_aliases
fi

exit 0
