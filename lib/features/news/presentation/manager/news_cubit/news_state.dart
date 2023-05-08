part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsSuccess extends NewsState {
  final List<NewsModel> news;

  const NewsSuccess(this.news);
}

class NewsFailure extends NewsState {
  final String errMessage;

  const NewsFailure(this.errMessage);
}
