import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log(event.toString(), name: 'AppBlocObserver');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log(
      error.toString(),
      name: 'AppBlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(change.toString(), name: 'AppBlocObserver');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(transition.toString(), name: 'AppBlocObserver');
  }
}
