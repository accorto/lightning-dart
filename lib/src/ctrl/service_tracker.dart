/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Service Performance Tracker
 */
class ServiceTracker {

  /// get client duration
  static Duration getDuration(SResponse response) {
    int start = response.clientRequestTime.toInt();
    int receipt = response.clientReceiptTime.toInt();
    int deltaMs = receipt - start;
    if (deltaMs > 0 && start > 0) {
      return new Duration(milliseconds: deltaMs);
    }
    return new Duration();
  }

  /// format duration in sec
  static String formatDuration(SResponse response) {
    return DurationUtil.formatDuration(getDuration(response));
  }

  /// Server Response
  final SResponse response;
  final String utv;
  final String details;

  /**
   * Service Performance Tracker
   */
  ServiceTracker(SResponse this.response, String this.utv, String this.details) {
    if (!response.hasClientRequestTime())
      response.clientRequestTime = new Int64(new DateTime.now().millisecondsSinceEpoch);
    if (!response.hasClientReceiptTime())
      response.clientReceiptTime = new Int64(new DateTime.now().millisecondsSinceEpoch);
  }


  /// Process Complete - send
  void send() {
    ServiceAnalytics.sendTimingApp(utv, response, details);
  } // send

} // ServiceTracker
