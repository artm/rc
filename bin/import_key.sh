#!/bin/sh

if [ -z "$1" ] ; then
  echo "Usage: $0 KEY-HASH ..."
  exit 1
fi

for key_hash in $@ ; do
  gpg --recv-keys $key_hash && gpg --export --armor $key_hash | sudo apt-key add -
done
