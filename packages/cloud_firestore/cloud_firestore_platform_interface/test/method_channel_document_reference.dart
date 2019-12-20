import 'dart:async';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

typedef MethodCallCallback = dynamic Function(MethodCall methodCall);

class MockFiledValue extends Mock implements FieldValueInterface {}

const _kCollectionId = "test";
const _kDocumentId = "document";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("$MethodChannelDocumentReference()", () {
    MethodChannelDocumentReference _documentReference;
    final mockFieldValue = MockFiledValue();
    setUp(() {
      _documentReference = MethodChannelDocumentReference(
          FirestorePlatform.instance, [_kCollectionId, _kDocumentId]);
      reset(mockFieldValue);
      when(mockFieldValue.type).thenReturn(FieldValueType.incrementDouble);
      when(mockFieldValue.value).thenReturn(2.0);
    });

    test("setData", () async {
      _assertSetDataMethodCalled(_documentReference, null, null);
      _assertSetDataMethodCalled(_documentReference, true, null);
      _assertSetDataMethodCalled(_documentReference, false, null);
      _assertSetDataMethodCalled(_documentReference, false, mockFieldValue);
      verify(mockFieldValue.instance);
    });

    test("updateData", () async {
      bool isMethodCalled = false;
      final Map<String,dynamic> data = {"test":"test","fieldValue": mockFieldValue};
      _handleMethodCall((call) {
        if (call.method == "DocumentReference#updateData") {
          isMethodCalled = true;
          expect(call.arguments["data"]["test"], equals(data["test"]));
        }
      });
      await _documentReference.updateData(data);
      verify(mockFieldValue.instance);
      expect(isMethodCalled, isTrue,
          reason: "DocumentReference.updateData was not called");
    });

    test("get",() async {
      await _assertGetMethodCalled(_documentReference, null, "default");
      await _assertGetMethodCalled(_documentReference, Source.cache, "cache");
      await _assertGetMethodCalled(_documentReference, Source.server, "server");
      await _assertGetMethodCalled(_documentReference, Source.serverAndCache, "default");
    });

    test("delete", () async {
      bool isMethodCalled = false;
      _handleMethodCall((call) {
        if(call.method == "DocumentReference#delete") {
          isMethodCalled = true;
        }
      });
      await _documentReference.delete();
      expect(isMethodCalled, isTrue,
          reason: "DocumentReference.delete was not called");
    });

    test("snapshots", () async {
      bool isMethodCalled = false;
      _handleMethodCall((call)  {
        if(call.method == "DocumentReference#addSnapshotListener") {
          isMethodCalled = true;
        }
        return 0;
      });
      _documentReference.snapshots().listen((_){});
      expect(isMethodCalled, isTrue,
          reason: "DocumentReference.addSnapshotListener was not called");
    });
  });
}

void _assertGetMethodCalled(DocumentReference documentReference,Source source, String expectedSourceString ) async {
  bool isMethodCalled = false;
  _handleMethodCall((call) {
    if (call.method == "DocumentReference#get") {
      isMethodCalled = true;
      expect(call.arguments["source"], equals(expectedSourceString));
    }
    return {
      "path":"test/test",
      "data": {},
      "metadata": {
        "hasPendingWrites": false,
        "isFromCache": false
      }
    };
  });
  if (source != null) {
    await documentReference.get(source: source);
  } else {
    await documentReference.get();
  }
  expect(isMethodCalled, isTrue,
      reason: "DocumentReference.get was not called");
}

void _assertSetDataMethodCalled(DocumentReference documentReference, bool expectedMergeValue, FieldValueInterface fieldValue) async {
  bool isMethodCalled = false;
  final Map<String,dynamic> data = {"test":"test"};
  if(fieldValue != null) {
    data.addAll({"fieldValue": fieldValue});
  }
  _handleMethodCall((call) {
    if (call.method == "DocumentReference#setData") {
      isMethodCalled = true;
      expect(call.arguments["data"]["test"], equals(data["test"]));
      expect(call.arguments["options"]["merge"], expectedMergeValue ?? false);
    }
  });
  if (expectedMergeValue == null) {
    await documentReference.setData(data);
  } else {
    await documentReference.setData(data,merge: expectedMergeValue);
  }
  expect(isMethodCalled, isTrue,
      reason: "DocumentReference.setData was not called");
}

void _handleMethodCall(MethodCallCallback methodCallCallback) =>
    MethodChannelFirestore.channel.setMockMethodCallHandler((call) async {
      expect(call.arguments["app"], equals(FirestorePlatform.instance.appName()));
      expect(call.arguments["path"], equals("$_kCollectionId/$_kDocumentId"));
      return await methodCallCallback(call);
    });
