# lightning dart

![Lightning Dart](http://lightningdart.com/LightningDartLogo.svg =60x "LightningDart")

Lightning Dart is a library for developing web applications based on the CSS framework
[http://www.lightningdesignsystem.com](http://www.lightningdesignsystem.com "Lightning Design").

Written in [Dart](https://www.dartlang.org "Dart Language") it compiles into Javascript ("Dart - the better Javascript"), so the delivery is a "one page apps".
 
The Framework is not dependent on salesforce.com functionality and can be used independently.

The Salesforce Lightning CSS framework is similar to Bootstrap but uses more recent CSS technology and concentrates on building Web Applications, not Web Sites. 


## Usage

A simple usage example:

    import "package:lightning/lightning.dart";

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


<img src="http://lightningdart.com/LightningDartLogo.svg" width="60"/>

[![Analytics](https://ga-beacon.appspot.com/UA-32129178-8/lightningdart/readme?pixel)](https://github.com/igrigorik/ga-beacon)
