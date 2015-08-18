#!/bin/sh
# bizbase_upload.sh

# build and upload to lightningdart.com
set -e
pub  --version

dartanalyzer lib/lightning_dart.dart
dartanalyzer lib/biz_base_dart.dart
dartanalyzer web/demo.dart

# https://www.dartlang.org/tools/dart2js/
pub deps > dependencies.txt

# dart build
echo "--build--"
if [ -d build ]; then
  rm -rf build
fi
pub build --mode=debug

# Timestamp
export TS=`date -u "+%Y-%m-%dT%H:%M:%SZ"`
sed -i '' -E 's/data-timestamp="(.*)"/data-timestamp="'$TS'"/g'  build/web/*.html
sed -i '' -E 's/name="etag" content="(.*)"/name="etag" content="'$TS'"/g'  build/web/*.html
sed -i '' 's/\${timestamp}/'$TS'/g' build/web/*.html
cat build/web/demo.html | grep $TS

TARGET=/Users/jorg/Documents/Accorto/gh-pages/lightning-dart/demo
cp -R build/web/* ${TARGET}
