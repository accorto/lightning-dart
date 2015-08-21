# lightning dart

![Lightning Dart](/LightningDartLogo.svg?raw=true =60x "LightningDart")

A Dart library for developing web applications based on the Salesforce Lightning Design System CSS Framework 
[http://www.lightningdesignsystem.com](http://www.lightningdesignsystem.com "Lightning Design").

The Framework is not dependent on salesforce.com functionality and can be used independently.

The Salesforce Lightning CSS framework is similar to Bootstrap but uses more recent CSS technology and concentrates on building Web Applications, not Web Sites. 

Dart is a Google programming language compiling into Javascript ("Dart - the better Javascript"). 

## Usage

A simple usage example:

    import "package:lightning_dart/lightning_dart.dart";

    main() {
        LightningDart.init() // client env
        .then((_) {
            LContainer page = LContainer.create(); // find/add to body
            ...
        }
    }
    
See [documentation](wiki) 

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/accorto/lightning-dart/issues

## Colaboration

We welcome help and contributions.  The current status of the underlying design system (css) is in flux and can change quickly. 
So it is best to contact us first (support at accorto.com) to coordinate efforts. 
We require the usual contributor license agreement.


<img src="/LightningDartLogo.svg?raw=true" width="60"/>

[![Analytics](https://ga-beacon.appspot.com/UA-32129178-8/lightningdart/readme?pixel)](https://github.com/igrigorik/ga-beacon)
