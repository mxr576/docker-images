#!/bin/bash

# Copy SSH keys from host if available
if [ -f  /.ssh/id_rsa ]; then
  cp /.ssh/id_rsa* ~/.ssh/
fi

# Launch supervisord to keep the container running.
/usr/bin/supervisord -n
