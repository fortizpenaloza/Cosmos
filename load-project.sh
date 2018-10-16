#/bin/bash
set -x

env

sed -ri "/master/$SOURCE_BRANCH/g" load-project.st
./pharo-ui Pharo.image st load-project.st
