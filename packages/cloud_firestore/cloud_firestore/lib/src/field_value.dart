// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cloud_firestore;

/// Sentinel values that can be used when writing document fields with set() or
/// update().
class FieldValue implements platform.FieldValueInterface {
  platform.FieldValueInterface _delegate;

  FieldValue._(this._delegate);

  @override
  platform.FieldValueInterface get instance => _delegate;

  @visibleForTesting
  platform.FieldValueType get type => _delegate.type;

  @visibleForTesting
  dynamic get value => _delegate.value;

  /// Returns a special value that tells the server to union the given elements
  /// with any array value that already exists on the server.
  ///
  /// Each specified element that doesn't already exist in the array will be
  /// added to the end. If the field being modified is not already an array it
  /// will be overwritten with an array containing exactly the specified
  /// elements.
  static FieldValue arrayUnion(List<dynamic> elements) =>
      FieldValue._(platform.FieldValueFactoryPlatform.instance.arrayUnion(elements));

  /// Returns a special value that tells the server to remove the given
  /// elements from any array value that already exists on the server.
  ///
  /// All instances of each element specified will be removed from the array.
  /// If the field being modified is not already an array it will be overwritten
  /// with an empty array.
  static FieldValue arrayRemove(List<dynamic> elements) =>
      FieldValue._(platform.FieldValueFactoryPlatform.instance.arrayRemove(elements));

  /// Returns a sentinel for use with update() to mark a field for deletion.
  static FieldValue delete() =>
      FieldValue._(platform.FieldValueFactoryPlatform.instance.delete());

  /// Returns a sentinel for use with set() or update() to include a
  /// server-generated timestamp in the written data.
  static FieldValue serverTimestamp() =>
      FieldValue._(platform.FieldValueFactoryPlatform.instance.serverTimestamp());

  /// Returns a special value for use with set() or update() that tells the
  /// server to increment the field’s current value by the given value.
  static FieldValue increment(num value) =>
      FieldValue._(platform.FieldValueFactoryPlatform.instance.increment(value));
}
