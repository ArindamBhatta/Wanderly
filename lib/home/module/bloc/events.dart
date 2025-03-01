import 'package:equatable/equatable.dart';

abstract class WanderlyEvent extends Equatable {
  const WanderlyEvent();

  @override
  List<Object> get props => [];
}

class InitialLoadRequested extends WanderlyEvent {}

//Internal Event
class StartDataSubscription extends WanderlyEvent {
  final Map<String, dynamic> data;
  const StartDataSubscription(this.data);
  @override
  List<Object> get props => [data];
}
