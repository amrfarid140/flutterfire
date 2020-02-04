// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cloud_firestore;

/// Sentinel values that can be used when writing document fields with set() or
/// update().
///
/// This class serves as a static factory for FieldValuePlatform instances, but also
/// as a Facade for the Fieldvalue type, so plugin users don't need to worry about
/// the actual internal implementation of their Fieldvalues, after they're created.
class FieldValue {
  static final platform.FieldValueFactoryPlatform _delegate =
      platform.FieldValueFactoryPlatform.instance;

  /// Returns a special value that tells the server to union the given elements
  /// with any array value that already exists on the server.
  ///
  /// Each specified element that doesn't already exist in the array will be
  /// added to the end. If the field being modified is not already an array it
  /// will be overwritten with an array containing exactly the specified
  /// elements.
  static platform.FieldValuePlatform arrayUnion(List<dynamic> elements) =>
      _delegate.arrayUnion(elements);

  /// Returns a special value that tells the server to remove the given
  /// elements from any array value that already exists on the server.
  ///
  /// All instances of each element specified will be removed from the array.
  /// If the field being modified is not already an array it will be overwritten
  /// with an empty array.
  static platform.FieldValuePlatform arrayRemove(List<dynamic> elements) =>
      _delegate.arrayRemove(elements);

  /// Returns a sentinel for use with update() to mark a field for deletion.
  static platform.FieldValuePlatform delete() => _delegate.delete();

  /// Returns a sentinel for use with set() or update() to include a
  /// server-generated timestamp in the written data.
  static platform.FieldValuePlatform serverTimestamp() =>
      _delegate.serverTimestamp();

  /// Returns a special value for use with set() or update() that tells the
  /// server to increment the field’s current value by the given value.
  static platform.FieldValuePlatform increment(num value) =>
      _delegate.increment(value);
}
