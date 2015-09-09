/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */
// Dynamic Context Eval
var LDART = function() {
    // set context
    this.set = function(name, value) {
        this[name] = value;
    };
    // evaluate in context
    this.evaluate = function(logic) {
        with (this) {
            return eval(logic);
        }
    }
};
