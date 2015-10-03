#!/bin/bash
# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
echo "*** Running dart analyzer ..."
dartanalyzer --fatal-warnings \
	lib/lightning.dart \
	lib/lightning_ctrl.dart \
	web/demo.dart \
	test/lightning_test.dart


# Run the tests.

#echo "Running tests ... no_content_shell:"
#pub global run test_runner --verbose --disable-ansi --skip-browser-tests

# https://github.com/google/test_runner.dart
echo "*** Running tests ... with_content_shell:"
#xvfb-run -s '-screen 0 1024x768x24' pub global run test_runner --verbose --disable-ansi
pub run test -p content-shell


# https://github.com/duse-io/dart-coveralls
# https://pub.dartlang.org/packages/dart_coveralls
#
# https://coveralls.io/github/accorto/lightning-dart
# export COVERALLS_TOKEN=x
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "*** Running coverage ..."
# Install dart_coveralls; gather and send coverage data.
# pub global activate dart_coveralls
  pub global run dart_coveralls report --debug test/lightning_test.dart
fi
