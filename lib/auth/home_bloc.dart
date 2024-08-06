import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeEvent {}

class HomeRefresh extends HomeEvent {}

class HomeLoadMore extends HomeEvent {}

class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> items;

  HomeLoaded(this.items);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeRefresh>((event, emit) async {
      emit(HomeLoading());
      await Future.delayed(Duration(seconds: 2));
      emit(HomeLoaded(List<String>.generate(10, (index) => 'Item ${index + 1}')));
    });

    on<HomeLoadMore>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final newItems = List<String>.generate(10, (index) => 'Item ${currentState.items.length + index + 1}');
        emit(HomeLoaded(currentState.items + newItems));
        print("New Item: $newItems");
        print("Current State: ${currentState.items}");
      }
    });

    add(HomeRefresh());
  }
}
