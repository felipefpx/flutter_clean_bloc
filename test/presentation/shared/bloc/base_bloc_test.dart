import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_bloc/presentation/shared/bloc/base_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBloc extends BaseBloc<_FakeState, _FakeEvent> {
  _FakeBloc() : super(const _FakeInitialState());
}

class _FakeEvent extends BaseEvent<_FakeState, _FakeBloc> {
  const _FakeEvent();

  @override
  Stream<_FakeState> apply(_FakeBloc bloc) async* {
    yield _FakeState();
  }
}

class _FakeState extends BaseState {
  const _FakeState();

  @override
  List<Object?> get props => [2];
}

class _FakeInitialState extends _FakeState {
  const _FakeInitialState();

  @override
  List<Object?> get props => [1];
}

void main() {
  group('Base bloc', () {
    blocTest<_FakeBloc, _FakeState>(
      'emits [_FakeState] when _FakeState is added',
      build: () => _FakeBloc(),
      act: (bloc) => bloc.add(const _FakeEvent()),
      expect: () => [_FakeState()],
    );
  });
}
