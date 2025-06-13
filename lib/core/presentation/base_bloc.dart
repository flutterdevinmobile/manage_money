import 'package:flutter_bloc/flutter_bloc.dart';

/// Base BLoC following SOLID principles
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  void handleError(Object error, Emitter<State> emit) {
    emit(createErrorState(error.toString()));
  }

  State createErrorState(String message);
  State createLoadingState();
  State createSuccessState(String message);
}
