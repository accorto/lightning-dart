#!/bin/sh
# bizbase_upload.sh

# build and upload to lightningdart.com
set -e
# https://www.dartlang.org/tools/dart2js/
pub  --version

dartanalyzer lib/lightning.dart
dartanalyzer lib/lightning_ctrl.dart
dartanalyzer web/demo.dart

dartdoc
# pub global activate simple_http_server
#  --path /Users/jorg/Documents/BizPlatform/lightning/lightning-dart/doc/api

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

TARGET=/Users/jorg/Documents/Accorto/gh-pages/lightning-dart/
cp -R build/web/* ${TARGET}

#exit 0;

# Model
export IN="/Users/jorg/Library/Application Support/VisualParadigm/ws/teamwork_client/projects/lightning-dart/lightning-dart.vpp"
export OUT=/Users/jorg/Documents/Accorto/gh-pages/lightning-dart/model
if [ -d ${OUT} ]; then
  rm -rf ${OUT}
fi
mkdir ${OUT}

cd "/Applications/Visual Paradigm 11.2/scripts"
sh ProjectPublisher.sh -project "${IN}" -out ${OUT}
cd -

