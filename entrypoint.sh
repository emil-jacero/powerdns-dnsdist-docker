#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

template () {
    arg1=$1
    arg2=$2
    python3 $DIR/template.py --template $1 --output $2
}

template $DIR/dnsdist.conf.j2 /etc/dnsdist/dnsdist.conf

echo "----------"
echo "Config:"
cat /etc/dnsdist/dnsdist.conf
echo "----------"

echo "Starting:"
/usr/bin/dnsdist --supervised
