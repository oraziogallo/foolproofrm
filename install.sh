#!/bin/bash
cp fprm.sh /usr/local/bin/

if [ -f '~/.bash_aliases' ]; then
    echo "alias rm='/usr/local/bin/fprm.sh'" >> ~/.bash_aliases
else
    echo "alias rm='/usr/local/bin/fprm.sh'" > ~/.bash_aliases
fi
