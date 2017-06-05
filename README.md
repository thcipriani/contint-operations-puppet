## What this is

    ¯\_(ツ)_/¯

## Make operations/puppet tests go fast

I've managed to get tests down from ~1 minute to ~27 seconds.

## Make it go

    docker build -t contint/operations/puppet .

    docker run \
        -v /srv/git:/srv/git                    # For speedy clone operations \
        -v /tmp/ci-puppet:/home/jenkins/.cache  # For caching deps            \
        -v ./log:/home/jenkins/log              # To get output logs          \
        contint/operations/puppet

tl;dr: ./build.sh

