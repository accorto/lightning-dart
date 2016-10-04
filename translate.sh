#!/usr/bin/env bash
set -e

# Translate lightning-dart

pub --version

## (0) -- clean directories
if [ -d tool/translation ]; then
  rm -rf tool/translation
fi
mkdir tool/translation
if [ -d lib/intl ]; then
  rm -rf lib/intl
fi
mkdir lib/intl

# absolute path
TARGET=/Users/jorg/Documents/BizPlatform/lightning/lightning-dart
DIR=${TARGET}/tool/translation

## (1a) -- create cmd file
# intl/bin/extract_to_arb
echo "pub run intl_translation:extract_to_arb --output-dir=$DIR lib/lightning_dart " > xx
# local lib
find lib -type f -name *.dart -exec echo "{}" >> xx  \;
tr '\n' ' ' < xx > translate_to_arb.sh
rm xx

## (1b) -- create arb file to be translated
# https://github.com/dart-lang/intl/blob/master/bin/extract_to_arb.dart
sh translate_to_arb.sh
echo "(1) ---- arb generated"
ls -lh tool/translation/*.arb


## (2) -- translate arb files
# in ../bin/trl_arb.dart
pub run lightning:trl_arb $DIR de
pub run lightning:trl_arb $DIR fr
pub run lightning:trl_arb $DIR es

echo "(2) ---- arb translated"
ls -lh tool/translation


## (3a) -- create cmd file
#echo "pub run intl:generate_from_arb --output-dir=lib/intl " > yy
echo "pub run intl_translation:generate_from_arb --output-dir=lib/intl --generated-file-prefix=ldart_ " > yy
find lib -type f -name *.dart -exec echo "{}" >> yy  \;
# translated arb file names can only have _locale (no other _)
# echo " tool/translation/messages_de.arb tool/translation/messages_fr.arb" >> yy
find tool/translation -type f -name messages*.arb -exec echo "{}" >> yy  \;
tr '\n' ' ' < yy > translate_from_arb.sh
rm yy

## (3b) -- create dart files
# https://github.com/dart-lang/intl/blob/master/bin/generate_from_arb.dart
sh translate_from_arb.sh
echo "(3) ---- intl generated"
ls -lh lib/intl

# base-messages_all.dart 			-> library messages_all
# base-messages_de.dart 			-> library messages_de;


