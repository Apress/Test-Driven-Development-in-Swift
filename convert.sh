#!/bin/bash

PROJECT=./04-tdd-in-the-real-world/1-end/Albertos.xcodeproj
WORKSPACE=
SCHEME=Albertos
SIMULATOR_NAME="iPhone 15 Pro"

function run_tests {
  if [[ -z $WORKSPACE ]]; then
    if [[ -z $PROJECT ]]; then
      echo "Please set either PROJECT or WORKSPACE."
      exit 1
    fi
    SOURCE_OPTION="-project $PROJECT"
  else
    SOURCE_OPTION="-workspace $WORKSPACE"
  fi

  XCODEBUILD_CMD=$(cat <<EOF
xcodebuild test \
  $SOURCE_OPTION \
  -scheme $SCHEME \
  -destination 'platform=iOS Simulator,name=$SIMULATOR_NAME'
EOF
)

if command -v xcbeautify >/dev/null 2>&1; then
  printf "Running:\n\t%s\n" "$XCODEBUILD_CMD"
  eval "$XCODEBUILD_CMD" | xcbeautify
else
  eval "$XCODEBUILD_CMD"
fi
}

echo "Running tests before converting..."
run_tests

