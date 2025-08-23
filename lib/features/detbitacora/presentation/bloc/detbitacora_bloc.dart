import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detbitacora_event.dart';
part 'detbitacora_state.dart';

class DetbitacoraBloc extends Bloc<DetbitacoraEvent, DetbitacoraState> {
  DetbitacoraBloc() : super(DetbitacoraInitial()) {
    on<DetbitacoraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
