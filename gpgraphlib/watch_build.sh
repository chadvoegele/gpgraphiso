#!/bin/bash
while inotifywait -r -e 'modify' .
do
  make ${MAKEFLAGS} -C src && make ${MAKEFLAGS} -C test && test/test_main
done
