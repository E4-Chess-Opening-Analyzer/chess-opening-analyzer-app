abstract class MovesState {
  MovesState({
      this.movesData = const <String, Map<String, int>>{}
  });
  final Map<String, Map<String, int>> movesData;
}

class MovesInitial extends MovesState {}
class MovesLoading extends MovesState {
  MovesLoading({required super.movesData});
}
class MovesLoaded extends MovesState {
  MovesLoaded({required super.movesData});
}

class MovesError extends MovesState {
  MovesError({super.movesData = const <String, Map<String, int>>{}});
}
