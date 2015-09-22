#!/bin/bash
# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
echo "Running dartanalyzer..."
dartanalyzer --fatal-warnings \
	lib/lightning.dart \
	lib/lightning_ctrl.dart \
	web/demo.dart \
	test/lightning_test.dart


# Run the tests.
echo "Running tests..."
#pub run test
pub global run test_runner --verbose --disable-ansi --skip-browser-tests
xvfb-run -s '-screen 0 1024x768x24' pub global run test_runner --verbose --disable-ansi


# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "Running coverage..."
# pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --retry 2 \
    --exclude-test-files \
    --debug \
    test/lightning_all.dart
fi
