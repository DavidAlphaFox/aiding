#!/bin/sh
cd `dirname $0`
export ERL_MAX_PORTS=2048
gmake && cd $(pwd)/examples && erlc -I ../include  *.erl &
wait $!
exec erl +K true -pa $(pwd)/ebin $(pwd)/examples $(find $(pwd)/deps -type d -name ebin | xargs) -s aiding
