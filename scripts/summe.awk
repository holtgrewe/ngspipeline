#!/usr/bin/awk -f
{ total = total + $1 } END { print total }
