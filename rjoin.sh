#!/bin/bash
# http://stackoverflow.com/a/18153506

if [[ $# -ge 2 ]]; then
    function __r {
        if [[ $# -gt 1 ]]; then
            exec join -t$'\t' - "$1" | __r "${@:2}"
        else
            exec join -t$'\t' - "$1"
        fi
    }

    __r "${@:2}" < "$1"
fi
