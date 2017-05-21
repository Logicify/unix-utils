#!/usr/bin/env bash

#    Copy docker image tool allows to copy docker image from one repository to another
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

# Fail on error
set -e

# ======= PARAMETERS ==============
ARG_LOCAL=0
ARG_ECR=0
ARG_HELP=0
ARG_TAG=""
ARG_SOURCE=""
ARG_TARGET=""
# ========== END ==================

function print_help() {
    echo ""
    echo "The tool allows to copy docker image from one docker repository to another."
    echo "It also natively supports ECR (elastic container repository) authorization which requires AWS CLI to
be installed."
    echo ""
    echo "Usage: docker-image-copy [-l,--local] [-e,--ecr] [-h] [-t,--tag TAG] <source> <target>"
    echo ""
    echo "-l, --local       Get source image from local repository. If not set it script will try to pull remote
    repository before uploading."
    echo "-e, --ecr         Do ECR login before pull and push operations. Doesn't work in local mode (-l)"
    echo "-t, --tag         Assign tag in the SOURCE repository
    "
    echo "Positional arguments"
    echo "source            Source image tag"
    echo "target            Target image tag"
    echo ""
    echo "NOTE: Image tag should be fully qualified tag. Examples:"
    echo "  - logicify/django:1.0               -   means docker image from docker hub repository"
    echo "  - my_image:latest                   -   docker image from local repository"
    echo "  - http://myrepo.com/my_image:1.0    -   docker image from remote repository"
    echo ""
    echo "
MIT License"
    echo "Copyright (C) 2017 Dmitry Berezovsky (https://github.com/Logicify/unix-utils)"
}

function check_requirements() {
    echo "Checking if all required tools are installed:"
    # docker
    echo -n "* docker is installed: "
    which docker 2>/dev/null || (echo "no" && exit 1)
    if [ $ARG_ECR -gt 0 ]; then
        # aws-cli
        echo -n "* aws-cli is installed: "
        which aws 2>/dev/null || (echo "no" && exit 1)
    fi
}

function ecr_login() {
    echo "Obtaining ECR authorization token"
    eval $(aws ecr get-login | sed 's|https://||')
    echo "Done"
}

function parse_arguments() {
# Example for args with value, e.g. "-a test"
#        -l|--lib)
#        LIBPATH="$2"
#        shift # past argument
#        ;;
    while [[ $# -gt 1 ]]
    do
        key="$1"
        case $key in
            -l|--local)
            ARG_LOCAL=1
            shift
            ;;
            -e|--ecr)
            ARG_ECR=1
            shift
            ;;
            -h|--help)
            ARG_HELP=1
            ;;
            -t|--tag)
            ARG_TAG="$2"
            echo "tag : ${ARG_TAG}"
            shift
            shift # past argument
            ;;
            *)
                break # No more named arguments left
            ;;
        esac
    done

    ARG_SOURCE="$1"
    ARG_TARGET="$2"

    if [ -z "$ARG_SOURCE" ] || [ -z "$ARG_TARGET" ]; then
        echo "ERROR: no source or target specified"
        print_help
        exit 1
    fi
}

# 1) Parse arguments and show help if invokation is wrong
parse_arguments $@

# 2) Show help message if -h flag specified
if [ ${ARG_HELP} -gt 0 ]; then
    print_help
fi

# 3) Exit if not all of the requirements satisfied
check_requirements

# 4) ECR login if required
if [ ${ARG_LOCAL} -eq 0 ] && [ ${ARG_ECR} -gt 0 ]; then
    ecr_login
fi

# 5) Pull source image if local mode is disabled
if [ ${ARG_LOCAL} -eq 0 ]; then
    docker pull "${ARG_SOURCE}"
echo ""
fi

# 6) Push to remote repo
docker tag "${ARG_SOURCE}" "${ARG_TARGET}"

# 7) If tag is specified - assign it on the source
if [ ! -z "${ARG_TAG}" ]; then
    new_source_tag=`echo "${ARG_SOURCE}" | sed -e s/:.*$/:${ARG_TAG}/`
    docker tag ${ARG_SOURCE} ${new_source_tag}
    if [ ${ARG_LOCAL} -eq 0 ]; then
        docker push ${new_source_tag}
    fi
fi

docker push "${ARG_TARGET}"