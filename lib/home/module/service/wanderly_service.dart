// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class WanderlyService {
  static WanderlyService? _instance;

  static WanderlyService getInstance() {
    _instance ??= WanderlyService();
    return _instance!;
  }

  final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get serviceStream => _streamController.stream;

  void wanderlyAllData() {
    try {
      FirebaseFirestore.instance
          .collection('destinations/publisher/data')
          .snapshots()
          .listen((
        QuerySnapshot<Map<String, dynamic>> querySnapshot,
      ) {
        List<Map<String, dynamic>> allDocs = querySnapshot.docs
            .map(
              (doc) => doc.data()..['id'] = doc.id, // use cascade operator
            )
            .toList();

        _streamController.add(
          {
            'data': allDocs,
            'error': false,
          },
        );
      });
    } catch (error) {
      print('Catch block is execute for data service layer : $error');
      _streamController.add({
        'data': null,
        'error': true,
      });
    }
  }
}
