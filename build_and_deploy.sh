#!/usr/bin/env bash

# This script is used to build and deploy the game to the web.
# Usage:
# ./build_and_deploy.sh

GAME_NAME=meagre-tactics
TARGET_FOLDER=~/Desktop
GITHUB_PAGES_BRANCH=web
SERVER=https://olhometro.vsti.dev/meagre-tactics

TIME_STAMP=$(date -u +"%Y%m%d-%H%M%S")
EXPORT_PATH=$TARGET_FOLDER/"$GAME_NAME"_"$TIME_STAMP"

echo -e '{\n  "build": "'$TIME_STAMP'",\n  "server": "'$SERVER'"\n}' > metadata.json
git add metadata.json
git commit -m "build label updated to \"$TIME_STAMP\""
git push

rm -rf $EXPORT_PATH
mkdir -p $EXPORT_PATH
godot --headless --export-release "Web" $EXPORT_PATH/index.html

git checkout $GITHUB_PAGES_BRANCH && git pull
mv .git $TARGET_FOLDER/.git
rm -rf ./*
mv $TARGET_FOLDER/.git ./
mv $EXPORT_PATH/* .
rm -rf $EXPORT_PATH

git add --all
git commit -m "build $TIME_STAMP"
git push
git checkout main
