// ignore_for_file: avoid_print

import 'dart:async';
import 'package:wanderly/home/module/caching/caching.dart';
import 'package:wanderly/home/module/model/publisher_model.dart';
import 'package:wanderly/home/module/service/wanderly_service.dart';

class WanderlyRepo {
  final WanderlyService _service = WanderlyService.getInstance();
  StreamSubscription<Map<String, dynamic>>? _stream;

  static WanderlyRepo? instance;

  static WanderlyRepo getInstance() {
    instance ??= WanderlyRepo();
    return instance!;
  }

  final _streamController = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  List<PublisherModel>? dataCollection;

  Future<List<PublisherModel>?> accessCachedData() async {
    try {
      List<Map<String, dynamic>>? cacheData =
          await getCachingTravelApi(CachedProperty.travelData);

      if (cacheData != null && cacheData.isNotEmpty) {
        List<PublisherModel> cachedList =
            cacheData.map((json) => PublisherModel.fromJson(json)).toList();
        return cachedList;
      }
    } catch (error) {
      print("Error accessing cache: $error");
    }
    return null;
  }

  void openStream() {
    _stream ??= _service.serviceStream.listen((data) {
      try {
        if (data['data'] != null) {
          List<Map<String, dynamic>> rawDataList =
              List<Map<String, dynamic>>.from(
            data['data'],
          );

          // Convert Firestore data to List of models
          dataCollection = rawDataList
              .map(
                (json) => PublisherModel.fromJson(json),
              )
              .toList();

          setCachingTravelApi(
            CachedProperty.travelData,
            {
              'data': rawDataList,
            },
          );

          // Send data through the stream
          _streamController.add({
            'data': dataCollection,
            'error': false,
          });
        }
      } catch (error) {
        _streamController.add(
          {
            'data': null,
            'error': true,
          },
        );
      }
    });
  }

  void fetchInitData() {
    openStream();
    _service.wanderlyAllData();
  }

  void dispose() {
    _stream?.cancel();
    _streamController.close();
  }
}
