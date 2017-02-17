#!/bin/bash
if [[ -z ${MAKEJOBS} ]]
then
  MAKEJOBS=1
fi
while inotifywait -r -e 'modify' .
do
  make -j ${MAKEJOBS} -C src && make -j ${MAKEJOBS} -C test && test/test_main
done
