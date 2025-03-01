// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class WanderlyService {
  static WanderlyService? _instance;
  static WanderlyService getInstance() {
    _instance ??= WanderlyService();
    return _instance!;
  }

  final _streamController = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get serviceStream => _streamController.stream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _firestoreSubscription;

  void wanderlyAllData() {
    try {
      _firestoreSubscription?.cancel();

      _firestoreSubscription = FirebaseFirestore.instance
          .collection('destinations/publisher/data')
          .snapshots()
          .listen(
        (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
          List<Map<String, dynamic>> allDocs = querySnapshot.docs
              .map(
                (doc) => doc.data()..['id'] = doc.id, // use cascade operator
              )
              .toList();

          _streamController.add({
            'data': allDocs,
            'error': false,
          });
        },
        onError: (error) {
          print('Firestore Stream Error: $error');
          _streamController.add({
            'data': null,
            'error': true,
          });
        },
      );
    } catch (error) {
      print('Catch block executed: $error');
      _streamController.add({
        'data': null,
        'error': true,
      });
    }
  }

  void dispose() {
    _firestoreSubscription?.cancel(); // Cancel Firestore listener
    _streamController.close(); // Close the stream controller
  }
}
