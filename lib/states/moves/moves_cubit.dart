import 'package:app/states/moves/moves_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovesCubit extends Cubit<MovesState> {
  MovesCubit() : super(MovesInitial());

  void setLoadingState() {
    emit(MovesLoading(movesData: state.movesData));
  }

  void loadMovesData(Map<String, Map<String, int>> movesData) {
    emit(MovesLoaded(movesData: movesData));
  }

  void setErrorState() {
    emit(MovesError(movesData: state.movesData));
  }
}
