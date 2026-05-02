#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/update.conf"

set -xe
set -o pipefail

mkdir -p -- "${BASEDIR}/../.daemonless"

cat -- "${BASEDIR}/config.yaml.template" |\
    sed -E \
        -e "s/%%TAG1%%/${TAG1}/g" > "${BASEDIR}/../.daemonless/config.yaml"

cat -- "${BASEDIR}/README.md.template" |\
    sed -E \
        -e "s/%%IMAGE_NAME%%/${IMAGE_NAME}/g" \
        -e "/%%OCI_CONFIGURATION%%/{
            r ${BASEDIR}/../.daemonless/config.yaml
            d
        }" > "${BASEDIR}/../README.md"

mkdir -p -- "${BASEDIR}/../.github/workflows"

cat -- "${BASEDIR}/build.yaml.template" |\
    sed -E \
        -e "s/%%IMAGE_NAME%%/${IMAGE_NAME}/g" > "${BASEDIR}/../.github/workflows/build.yaml"
