import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver{
  @override

  void onCreate(BlocBase bloc){
    super.onCreate(bloc);
    log('onCreate -- bloc ${bloc.runtimeType}');
  }

  @override
   void onEvent(Bloc bloc, Object? event){
    super.onEvent(bloc, event);
    log('onCreate -- bloc ${bloc.runtimeType}, event $event');
  }

  @override
   void onChange(BlocBase bloc, Change change){
    super.onChange(bloc, change);
    log('onCreate -- bloc ${bloc.runtimeType}, change $change');
  }

   @override
   void onTransition(Bloc bloc, Transition transition){
    super.onTransition(bloc, transition);
    log('onCreate -- bloc ${bloc.runtimeType}, transition $transition');
  }

   @override
   void onError(BlocBase bloc, Object error, StackTrace stackTrace){
    super.onError(bloc, error, stackTrace);
    log('onCreate -- bloc ${bloc.runtimeType}, error $error');
  }

   @override

  void onClose(BlocBase bloc){
    super.onClose(bloc);
    log('onCreate -- bloc ${bloc.runtimeType}');
  }

}