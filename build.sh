#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CACHE_DIR="/tmp/ci-puppet/cache"
LOG_DIR="/tmp/ci-puppet/log"

info() {
    printf "[$(tput setaf 2)INFO$(tput sgr0)] %b\n" "$@"
}

mkdir -p "$LOG_DIR"
mkdir -p "$CACHE_DIR"

chmod 777 "$LOG_DIR"
chmod 777 "$CACHE_DIR"

pushd "$DIR" &> /dev/null

info "building docker container"
docker build -t contint/operations/puppet .

info "running docker container"
docker run \
    --rm -it \
    -e "HOME=/home/jenkins" \
    -v /srv/git:/srv/git \
    -v $CACHE_DIR:/home/jenkins/.cache \
    -v $LOG_DIR:/home/jenkins/log \
    contint/operations/puppet

popd &> /dev/null

info "Logs available in $LOG_DIR"
