#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -v $LOG_LEVEL ]]; then
    echo "Log level: $LOG_LEVEL"
else
    echo "Log level: INFO"
fi

template () {
    arg1=$1
    arg2=$2
    python3 $DIR/lib/template.py --template $1 --output $2
}

template $DIR/lib/dnsdist.conf.j2 /etc/dnsdist/dnsdist.conf

if [[ $LOG_LEVEL = "DEBUG" ]]; then
    echo "----------------------------------------"
    echo "                Config"
    echo "----------------------------------------"
    cat /etc/dnsdist/dnsdist.conf
fi

echo "----------------------------------------"
echo "         Starting PDNS dnsdist"
echo "----------------------------------------"
/usr/bin/dnsdist --supervised
