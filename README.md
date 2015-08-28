# Lightning Dart

Lightning Dart is a library for developing web applications based on the css framework
[http://www.lightningDesignSystem.com](http://www.lightningdesignsystem.com "SLDS").

Written in [Dart](https://www.dartlang.org "Dart Language") it compiles into Javascript ("Dart - the better Javascript"), so the delivery is a "one page apps".
 
The Framework is not dependent on salesforce.com functionality and can be used independently.

The Salesforce Lightning Design css framework is similar to Bootstrap but uses more recent css technology and concentrates on building Web Applications, not Web Sites. 

Check out the [demo](http://lightningdart.com)


## Usage

A simple usage example:

    import "package:lightning/lightning.dart";

    main() {
        LightningDart.init() // client env
        .then((_) {
            PageSimple page = PageSimple.create();
            // check example: http://lightningdart.com/exampleForm.html
            page.add(...content...);
        }
    }
    
For more details, see [documentation](http://lightning.accorto.com) 
- for component code, check the Source tabs in [http://lightningdart.com](http://lightningdart.com)
- for form with code, check [subscribe form example](http://lightningdart.com/exampleForm.html) 
- our blog of our [Lightning Experience](http://lightning.accorto.com/support/discussions/forums/1000228577) journey


## Status, features and bugs

The Component Demo http://lightningdart.com provides the implementation status per component. 

Please file feature requests and bugs at the [issue tracker](http://lightning.accorto.com) or send an email to lightning@accorto.com.



## Colaboration

We welcome help and contributions.  The current status of the underlying design system (css) is in flux and can change quickly. 
So it is best to contact us first (lightning@accorto.com) to coordinate efforts. 
We require the usual contributor license agreement.

<img src="http://lightningdart.com/LightningDartLogo.svg" width="60"/>

[![Analytics](https://ga-beacon.appspot.com/UA-32129178-8/lightningdart/readme?pixel)](https://github.com/igrigorik/ga-beacon)
