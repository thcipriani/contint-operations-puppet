#!/usr/bin/env bash

set -eu

TEMP_DIR=$(mktemp -d)
CACHE_DIR="${HOME}/.cache/jenkins"
LOG_DIR="${HOME}/log"

git clone --reference /srv/git/operations/puppet https://gerrit.wikimedia.org/r/operations/puppet "$TEMP_DIR/puppet"

cd "$TEMP_DIR/puppet"

{
    set -o pipefail
    PY_COLORS=1 tox -v | tee "${LOG_DIR}/tox.log"
    set +o pipefail
    mv "${TEMP_DIR}/puppet/.tox" "${CACHE_DIR}"
} &

{
    if [ -d "${CACHE_DIR}/.gems" ]; then
        mv "${CACHE_DIR}/.gems" "${HOME}/.gems"
    fi
    bundle install --path "${HOME}/.gems" --clean
    bundle exec rake test | tee "${LOG_DIR}/rake.log"
    mv "${HOME}/.gems" "${CACHE_DIR}/.gems"
} &

wait
