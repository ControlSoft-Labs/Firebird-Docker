#!/usr/bin/env bash

HC_IP=127.0.0.1
HC_PORT=3050

nc -z "${HC_IP}" "${HC_PORT}" < /dev/null
exit $?