/**
 * DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
 * This is a library that looks up messages for specific locales by
 * delegating to the appropriate library.
 */

library messages_all;

import 'dart:async';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:intl/intl.dart';

import 'base-messages_de.dart' deferred as messages_de;
import 'base-messages_es.dart' deferred as messages_es;
import 'base-messages_fr.dart' deferred as messages_fr;


Map<String, Function> _deferredLibraries = {
  'de' : () => messages_de.loadLibrary(),
  'es' : () => messages_es.loadLibrary(),
  'fr' : () => messages_fr.loadLibrary(),
};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'de' : return messages_de.messages;
    case 'es' : return messages_es.messages;
    case 'fr' : return messages_fr.messages;
    default: return null;
  }
}

/** User programs should call this before using [localeName] for messages.*/
Future initializeMessages(String localeName) {
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  var lib = _deferredLibraries[Intl.canonicalizedLocale(localeName)];
  var load = lib == null ? new Future.value(false) : lib();
  return load.then((_) =>
      messageLookup.addLocale(localeName, _findGeneratedMessagesFor));
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, (x) => _findExact(x) != null,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
