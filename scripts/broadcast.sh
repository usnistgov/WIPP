#!/bin/bash
if [ $# -ne 1 ]
then
    echo "No address to broadcast to..."
    exit 1
fi

# Change the source to broadcast outside the machine
for f in `find ~/gui/src -name "*.ts"`
do
    sed -i \
        -e "s;localhost;$1;g" \
        ${f}
done
