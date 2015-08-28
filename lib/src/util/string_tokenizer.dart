/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;


/**
 * Java like StringTokenizer
 */
class StringTokenizer {

  final String string;
  final String delimiters;
  final bool returnDelimiters;
  int position = 0;

  /**
   * Constructs a new StringTokenizer for string using the specified
   * delimiters and returning delimiters as tokens when specified.
   * @param string the string to be tokenized
   * @param delimiters the delimiters to use, defaults to whitespace
   * @param returnDelimiters true to return each delimiter as a token
   */
  StringTokenizer(String this.string,
      [String this.delimiters = " \t\n\r\f", bool this.returnDelimiters = false]) {
    if (string == null) {
      throw new Exception("StringTokenizer with null");
    }
  }

  /**
   * Returns the number of unprocessed tokens remaining in the string.
   * @return number of tokens that can be retreived before an exception will result
   */
  int countTokens() {
    int count = 0;
    bool inToken = false;
    for (int i = position,
        length = string.length; i < length; i++) {
      if (delimiters.indexOf(string[i], 0) >= 0) {
        if (returnDelimiters) count++;
        if (inToken) {
          count++;
          inToken = false;
        }
      } else {
        inToken = true;
      }
    }
    if (inToken) {
      count++;
    }
    return count;
  } // countTokens

  /**
   * Returns true if unprocessed tokens remain.
   * @return true if unprocessed tokens remain
   */
  bool hasMoreElements() => hasMoreTokens();

  /**
   * Returns true if unprocessed tokens remain.
   * @return true if unprocessed tokens remain
   */
  bool hasMoreTokens() {
    int length = string.length;
    if (position < length) {
      if (returnDelimiters) {
        return true;
      }
      for (int i = position; i < length; i++) {
        if (delimiters.indexOf(string[i], 0) == -1) {
          return true;
        }
      }
    }
    return false;
  } // hasMoreTokens

  /**
   * Returns the next token in the string as an Object.
   * @return next token in the string as an Object
   * @exception NoSuchElementException if no tokens remain
   */
  Object nextElement() => nextToken();

  /**
   * Returns the next token in the string as a String.
   * @param delims temporarily overwrite default delimiters.
   * @return next token in the string as a String
   * @thows Exception if no tokens remain
   */
  String nextToken([String delims = null]) {
    if (delims == null) {
      delims = this.delimiters;
    }
    int i = position;
    int length = string.length;
    if (i < length) {
      if (returnDelimiters) {
        if (delims.indexOf(string[position], 0) >= 0) {
          return string[position++];
        }
        for (position++; position < length; position++) {
          if (delims.indexOf(string[position], 0) >= 0) {
            return string.substring(i, position);
          }
        }
        return string.substring(i);
      }

      while (i < length && delims.indexOf(string[i], 0) >= 0) {
        i++;
      }
      position = i;
      if (i < length) {
        for (position++; position < length; position++) {
          if (delims.indexOf(string[position], 0) >= 0) {
            return string.substring(i, position);
          }
        }
        return string.substring(i);
      }
    }
    throw new Exception("StringTokenizer no more tokens");
  } // nextToken

} // StringTokenizer
