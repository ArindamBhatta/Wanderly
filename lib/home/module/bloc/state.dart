import 'package:equatable/equatable.dart';
import 'package:wanderly/home/module/model/publisher_model.dart';

abstract class WanderlyState extends Equatable {
  const WanderlyState();

  @override
  List<Object> get props => [];
}

class WarperInitial extends WanderlyState {}

class DataLoading extends WanderlyState {}

class FetchDataSuccessful extends WanderlyState {
  final List<PublisherModel> data;
  const FetchDataSuccessful(this.data);

  @override
  List<Object> get props => [data];
}

class FetchCachedData extends WanderlyState {
  final List<PublisherModel> cachedData;
  const FetchCachedData(this.cachedData);

  @override
  List<Object> get props => [cachedData];
}

class FetchDataError extends WanderlyState {
  final String message;
  const FetchDataError(this.message);

  @override
  List<Object> get props => [message];
}
