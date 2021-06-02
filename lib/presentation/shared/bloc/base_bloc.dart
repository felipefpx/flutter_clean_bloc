import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<S extends BaseState, E extends BaseEvent<S, Bloc>>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  @override
  Stream<S> mapEventToState(E event) => event.apply(this);

  void yield(S state) => super.emit(state);
}

abstract class BaseEvent<S extends BaseState, B extends Bloc> {
  const BaseEvent();

  Stream<S> apply(B bloc);
}

abstract class BaseState extends Equatable {
  const BaseState();
}
