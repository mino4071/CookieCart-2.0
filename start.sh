#!/bin/sh
export NITROGEN_SRC=/usr/lib/erlang/lib/nitrogen-master/www
cd `dirname $0`

echo Creating link to nitrogen support files...
rm -rf wwwroot/nitrogen
ln -s $NITROGEN_SRC wwwroot/nitrogen

echo Starting Nitrogen on Inets...
erl \
	-name nitrogen@127.0.0.1 \
	-pa $PWD/apps $PWD/ebin $PWD/include \
	-s make all \
	-eval "application:start(codeWork)"

