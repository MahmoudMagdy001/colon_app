import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utlis/api_news_sevice.dart';
import '../models/news_model/news_model.dart';
import 'news_repo.dart';

class NewsRepoImpl implements NewsRepo {
  final ApiNewsService apiService;

  NewsRepoImpl(this.apiService);
  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews() async {
    try {
      var data = await apiService.get(
          endpoint:
              'everything?sortBy=publishedAt&q=Colon Cancer&apiKey=ffbb1355bffd49be8fcd529b75c93062');

      List<NewsModel> news = [];
      for (var item in data['articles']) {
        news.add(NewsModel.fromJson(item));
      }
      return right(news);
    } catch (e) {
      if (e is DioError) {
        return left(
          ServerFailure.fromDioError(e),
        );
      }

      return left(
        ServerFailure(e.toString()),
      );
    }
  }
}
