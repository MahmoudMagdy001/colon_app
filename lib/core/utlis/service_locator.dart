import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/news/data/repos/news_repo_impl.dart';
import 'api_news_sevice.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiNewsService>(ApiNewsService(Dio()));
  getIt.registerSingleton<NewsRepoImpl>(
    NewsRepoImpl(
      getIt.get<ApiNewsService>(),
    ),
  );
}
