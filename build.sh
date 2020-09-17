#!/bin/bash

FBINSTFILE=$(basename ${FBURL})
FBINSTDIR=$(basename -s .tar.gz ${FBURL})

if [ ! -d "/tmp/inst/firebird" ]; then
  if [ ! -d "/tmp/inst" ]; then
    mkdir /tmp/inst
  fi
  mkdir /tmp/inst/firebird
fi

cd /tmp/inst/firebird

if [ -f "/tmp/inst/firebird/Firebird-3.0.4.33054-0.amd64.tar.gz" ]; then
  rm /tmp/inst/firebird/Firebird-3.0.4.33054-0.amd64.tar.gz
fi

wget -nv ${FBURL} --no-check-certificate
echo tar -xzvf ${FBINSTFILE}
tar -xzvf ${FBINSTFILE}
echo cd ${FBINSTDIR} 
cd ${FBINSTDIR} 

chmod +x install.sh
./install.sh -silent

export PATH="/opt/firebird/bin:$PATH"

mkdir /usr/local/firebird