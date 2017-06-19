#!/bin/bash
trap 'kill %1; kill %2' SIGINT
(./node_modules/.bin/bsb -w | sed -e 's/^/[bsb] /') &
(./node_modules/.bin/rollup --config --watch 2>&1 | sed -e 's/^/[rollup] /') &
(cd dist && ../node_modules/.bin/http-server -c-1 | sed -e 's/^/[http-server] /')
