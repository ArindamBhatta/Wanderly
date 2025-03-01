// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/home/module/bloc/events.dart';
import 'package:wanderly/home/module/bloc/state.dart';
import 'package:wanderly/home/module/model/publisher_model.dart';
import 'package:wanderly/home/module/repo/wanderly_repo.dart';

class WanderlyLogic extends Bloc<WanderlyEvent, WanderlyState> {
  final WanderlyRepo _repo = WanderlyRepo.getInstance();
  StreamSubscription<Map<String, dynamic>>? _stream;
  final bool _hasReceivedStreamData = false;

  WanderlyLogic() : super(WarperInitial()) {
    on<InitialLoadRequested>((event, emit) async {
      emit(DataLoading());
      // Open the live stream first
      openStream();
      _repo.fetchInitData();

      // Wait for a short period to see if stream provides data
      await Future.delayed(Duration(seconds: 4));

      // If no stream data has arrived yet, load cached data
      if (!_hasReceivedStreamData) {
        List<PublisherModel>? cachedData = await _repo.accessCachedData();
        if (cachedData != null) {
          emit(FetchCachedData(cachedData));
        } else {
          emit(FetchDataError(
            'Failed to load data and no cached data available.',
          ));
        }
      }
    });

    on<StartDataSubscription>(
      (event, emit) {
        if (event.data['data'] != null &&
            (event.data['data'] as List).isNotEmpty) {
          List<PublisherModel> modelDataList = List<PublisherModel>.from(
            event.data['data'],
          );

          emit(
            FetchDataSuccessful(
              modelDataList,
            ),
          );
        } else {
          emit(
            FetchDataError(
              'Failed to load data and no cached data available',
            ),
          );
        }
      },
    );
  }

  //Raise a new Event
  void openStream() {
    _stream ??= _repo.stream.listen(
      (
        Map<String, dynamic> data,
      ) {
        add(
          StartDataSubscription(data),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _stream?.cancel();
    return super.close();
  }
}
