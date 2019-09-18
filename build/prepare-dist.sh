#!/bin/bash
set -x
set -e

DIST=dist;
ROOT_DIR=$(cd `dirname $0` && pwd)/..;
cd "$ROOT_DIR"

mkdir -p "$DIST"

## NPM INSTALL 
(
    echo "NPM install in root of the repo"
    cd "$ROOT_DIR"
    npm install
)

## Prepare Platfrom Declarations
(
    PACKAGE=tns-platform-declarations;

    echo "Clearing $DIST/$PACKAGE"
    npx rimraf "$DIST/$PACKAGE"
    npx rimraf "$DIST/$PACKAGE*.tgz"

    echo "Copying $PACKAGE $DIST/$PACKAGE..."
    npx ncp "$PACKAGE" "$DIST/$PACKAGE"

    echo "Copying README and LICENSE to $DIST/$PACKAGE"
    npx ncp LICENSE "$DIST/$PACKAGE"/LICENSE

    cd "$DIST/$PACKAGE"

    echo 'Running npm install...'
    npm install

    echo 'Running npm test...'
    npm test
)

## Prepare Core Modules
(
    PACKAGE=tns-core-modules;

    echo "Clearing $DIST/$PACKAGE"
    npx rimraf "$DIST/$PACKAGE"
    npx rimraf "$DIST/$PACKAGE*.tgz"

    echo "Copying $PACKAGE $DIST/$PACKAGE..."
    npx ncp "$PACKAGE" "$DIST/$PACKAGE"

    echo "Cleaning inner readme.md-s ..."
    npx rimraf "$DIST/$PACKAGE/**/README.md"
    npx rimraf "$DIST/$PACKAGE/**/Readme.md"

    echo "Copying README and LICENSE to $DIST/$PACKAGE"
    npx ncp LICENSE "$DIST"/"$PACKAGE"/LICENSE
    npx ncp README.md "$DIST"/"$PACKAGE"/README.md

    (
        echo 'TypeScript transpile...'
        cd "$DIST/$PACKAGE"
        npm install
        npx tsc
    )

    echo "Clearing typescript definitions from private APIs..."
    node build/clear-private-definitions "$DIST/$PACKAGE"
)
