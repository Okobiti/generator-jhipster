#!/bin/bash

set -e

trap ctrl_c INT

function ctrl_c() {
    exit 1
}

function usage() {
    me=$(basename "$0")
    echo
    echo "Usage: $me build|clean"
    echo
    exit 2
}

if [ "$1" = "build" ]; then

    for dir in $(ls -1 travis/samples); do
        echo "*********************** Building $dir"
        pushd "travis/samples/$dir"
        npm link generator-jhipster
        yo jhipster --force
        if [ -f pom.xml ]; then
            ./mvnw verify
        else
            ./gradlew test
        fi
        popd
    done

elif [ "$1" = "clean" ]; then

    for dir in $(ls -1 travis/samples); do
        echo "*********************** Cleaning $dir"
        pushd "travis/samples/$dir"
        ls -a | grep -v .yo-rc.json | xargs rm -rf | true
        popd
    done

else
    usage
fi
