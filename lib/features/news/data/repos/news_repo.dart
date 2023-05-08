import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/news_model/news_model.dart';

abstract class NewsRepo {
  Future<Either<Failure, List<NewsModel>>> fetchNews();
}
