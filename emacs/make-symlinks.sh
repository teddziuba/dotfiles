#!/bin/bash

MY_DIR="$( cd "$( dirname $0 )" && pwd)"

for f in $MY_DIR/*.el
do
    base=`basename $f`
    ln -s $f ~/.emacs.d/$base
done

ln -s $MY_DIR/rhtml ~/.emacs.d/rhtml