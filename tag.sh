#!/bin/bash

set -e

TAG_NAME=release_test_build_flow_1
git commit -am "Auto Build Tag: $TAG_NAME"
git pull --rebase
git push
git tag $TAG_NAME
git push origin $TAG_NAME