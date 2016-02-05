#!/bin/sh
# bizbase_upload.sh

# build and upload to lightningdart.com
set -e
# https://www.dartlang.org/tools/dart2js/
pub  --version

dartanalyzer lib/lightning.dart
dartanalyzer lib/lightning_ctrl.dart
dartanalyzer web/demo.dart

# Doc
export API=/Users/jorg/Documents/BizPlatform/lightning/lightning-dart/doc/api
if [ -d ${API} ]; then
  rm -rf ${API}
fi
mkdir ${API}
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

#  aws s3 cp build/web s3://lightningdart --recursive
aws s3 sync build/web s3://lightningdart --quiet
aws s3 ls s3://lightningdart --recursive --summarize --human-readable

echo $TS
echo "http://lightningdart.s3-website-us-east-1.amazonaws.com/"
#exit 0;

TARGET=/Users/jorg/Documents/Accorto/gh-pages/lightning-dart/
cp -R build/web/* ${TARGET}

# Model
export IN="/Users/jorg/Library/Application Support/VisualParadigm/ws/teamwork_client/projects/lightning-dart/lightning-dart.vpp"

export MODEL=/Users/jorg/Documents/Accorto/gh-pages/lightning-dart/model
export MODEL=/Users/jorg/Documents/BizPlatform/lightning/lightning-dart/doc/model
if [ -d ${MODEL} ]; then
  rm -rf ${MODEL}
fi
mkdir ${MODEL}

cd "/Applications/Visual Paradigm 11.2/scripts"
sh ProjectPublisher.sh -project "${IN}" -out ${MODEL}
cd -


aws s3 sync ${API} s3://lightningdart/api --quiet
aws s3 sync ${MODEL} s3://lightningdart/model --quiet
aws s3 ls s3://lightningdart --recursive --summarize --human-readable

echo $TS
# https://lightningdart.com
echo "http://lightningdart.s3-website-us-east-1.amazonaws.com/"

# CI
curl http://ci.bizfabrik.com/job/IT_Lightning/build?token=build --user jorg.janke@accorto.com:$BIZPASS
