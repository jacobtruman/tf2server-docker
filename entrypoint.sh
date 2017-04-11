#!/bin/bash

# update the server
${TF2_SERVER_SCRIPT} force-update

# run the server
${TF2_SERVER_SCRIPT} start

# check until the server is up
${TF2_SERVER_SCRIPT} monitor

# This is to keep the container running
${TF2_SERVER_SCRIPT} console
