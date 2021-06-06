import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E extends BaseEvent<S, Bloc>, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  @override
  Stream<S> mapEventToState(E event) => event.apply(this);

  void emit(S state) => super.emit(state);
}

abstract class BaseEvent<S extends BaseState, B extends Bloc> {
  const BaseEvent();

  Stream<S> apply(B bloc);
}

abstract class BaseState extends Equatable {
  const BaseState();
}
