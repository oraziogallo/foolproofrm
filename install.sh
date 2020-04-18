#!/bin/bash

fprm_alias="alias rm='$PWD/fprm.sh'"
if [ -f ~/.bash_aliases ]; then
    if grep -xq "$fprm_alias" ~/.bash_aliases ; then
        echo "Alias already set, skipping."
    else
        if grep -q "^alias rm=*" ~/.bash_aliases ; then
            echo "I found an existing alias named 'rm', quitting."
            exit 1
        fi
        echo $fprm_alias >> ~/.bash_aliases
    fi
else
    echo $fprm_alias > ~/.bash_aliases
fi

exit 0
