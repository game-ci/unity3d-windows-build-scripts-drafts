#!/usr/bin/env bash
# This script was adapted from https://gitlab.com/gableroux/unity3d-gitlab-ci-example/-/blob/896c8cae/ci/build.sh to work on Windows

set -ex

echo "Building for $BUILD_TARGET"

BUILD_MACHINE_USERNAME=Totema

WINDOWS_CURRENT_BUILD_PATH=$PWD
BUILD_PATH="$PWD/Builds/$BUILD_TARGET"
WINDOWS_BUILD_PATH=$BUILD_PATH
mkdir -p $BUILD_PATH || true

UNITY_LOG_PATH=/c/Users/$BUILD_MACHINE_USERNAME/AppData/Local/Unity/Editor/editor.log

# reset unity log on each build as a workaround
echo '' > $UNITY_LOG_PATH

set +e

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
  -logFile

UNITY_EXIT_CODE=$?

set -e

cat $UNITY_LOG_PATH

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
BUILD_SCRIPT_EXIT_CODE=$?

exit $BUILD_SCRIPT_EXIT_CODE
