#!/usr/bin/env bash

#    Allows to connect to the bash shell of the running container
#    Copyright (C) 2017 Dmitry Berezovsky
#
#    The MIT License (MIT)
#    Permission is hereby granted, free of charge, to any person obtaining
#    a copy of this software and associated documentation files
#    (the "Software"), to deal in the Software without restriction,
#    including without limitation the rights to use, copy, modify, merge,
#    publish, distribute, sublicense, and/or sell copies of the Software,
#    and to permit persons to whom the Software is furnished to do so,
#    subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be
#    included in all copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

TARGET_CONTAINER=""
if [ -f "/etc/dive-in-docker.conf" ]; then
    TARGET_CONTAINER=`cat /etc/dive-in-docker.conf`
fi
if [ $# -ge 1 ]
then
    TARGET_CONTAINER="$1"
fi
if [ -z "$TARGET_CONTAINER" ]; then
    echo "Allows to connect to the bash shell of the running container"
    echo ""
    echo "Usage: dive [<container name>]"
    echo "       Searches for the running docker container and creates interactive bash session"
    echo "       If <container name> is not specifies it tries to get it from the file /etc/dive-in-docker.conf"
    exit 0
fi

CONTAINER_ID=`docker ps | grep "$TARGET_CONTAINER" | awk '{ print substr(\$1,0) }'`

if [ -z "$CONTAINER_ID" ]; then
    echo "Can't find container $TARGET_CONTAINER. Is it running?"
    exit 1
fi

echo ""
echo "=============================="
echo "   CONNECTED TO: $TARGET_CONTAINER"
echo "=============================="
echo ""

docker exec -it $CONTAINER_ID bash

echo ""
echo "=============================="
echo "         GOOD BYE"
echo "=============================="
echo ""