#!/usr/bin/env bash

trap "exit" INT TERM ERR
trap "kill 0" EXIT

set -e
set -x

export BUILD_TARGET=Switch
export UNITY_EXECUTABLE='/mnt/c/Program Files/Unity/Hub/Editor/2018.4.20f1/Editor/Unity.exe'

echo "Building for $BUILD_TARGET"

CURRENT_BUILD_PATH=$PWD
WINDOWS_CURRENT_BUILD_PATH=$(wslpath -w "$CURRENT_BUILD_PATH")
BUILD_PATH="$PWD/Builds/$BUILD_TARGET"
WINDOWS_BUILD_PATH=$(wslpath -w "$BUILD_PATH")
mkdir -p $BUILD_PATH

LOG_FILE=/mnt/c/Users/Totema/AppData/Local/Unity/Editor/editor.log
echo '' > $LOG_FILE
tail -f $LOG_FILE &

"${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity}" \
  -projectPath "${WINDOWS_CURRENT_BUILD_PATH}" \
  -quit \
  -batchmode \
  -buildTarget $BUILD_TARGET \
  -customBuildTarget $BUILD_TARGET \
  -customBuildName $BUILD_NAME \
  -customBuildPath "${WINDOWS_BUILD_PATH}" \
  -customBuildOptions AcceptExternalModificationsToPlayer \
  -executeMethod BuildCommand.PerformBuild \
  -logFile /dev/stdout

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

ls -la $BUILD_PATH
[ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
