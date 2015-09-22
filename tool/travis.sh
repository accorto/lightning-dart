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
# pub global activate test_runner
pub global run test_runner


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
