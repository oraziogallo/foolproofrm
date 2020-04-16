#!/bin/bash
cp fprm.sh /usr/local/bin/
if [ $? -ne 0 ]; then
  echo "Copy failed. Run with sudo?" >&2
  exit 1
fi

if [ -f ~/.bash_aliases ]; then
    echo "alias rm='/usr/local/bin/fprm.sh'" >> ~/.bash_aliases
else
    echo "alias rm='/usr/local/bin/fprm.sh'" > ~/.bash_aliases
fi

exit 0
