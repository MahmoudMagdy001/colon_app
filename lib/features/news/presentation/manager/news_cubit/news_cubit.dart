// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/news_model/news_model.dart';
import '../../../data/repos/news_repo.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this.homeRepo) : super(NewsInitial());

  final NewsRepo homeRepo;

  Future<void> fetchNews() async {
    emit(NewsLoading());
    var result = await homeRepo.fetchNews();
    result.fold((failure) {
      emit(NewsFailure(failure.errMessage));
    }, (news) {
      emit(NewsSuccess(news));
    });
  }
}
