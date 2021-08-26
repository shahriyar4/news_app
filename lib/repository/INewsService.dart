import 'package:newsapp_bloc/model/news_model.dart';

abstract class INewsService {
  Future<List<NewsModel>> getNews();
}
