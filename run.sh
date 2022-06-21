#!/bin/bash

./sort --filename $1  --smp $3 -m $4 >& /dev/null || exit 1
mv result.txt $2
