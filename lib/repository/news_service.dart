import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp_bloc/model/news_model.dart';
import 'package:newsapp_bloc/repository/INewsService.dart';

class NewsService implements INewsService {

   final url = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&apiKey=07b547dad53c4208810379a479746cf9");
  @override
  Future<List<NewsModel>> getNews() async {
    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=tr&apiKey=07b547dad53c4208810379a479746cf9"));

    var data = jsonDecode(response.body);

    List<NewsModel> _articleModelList = [];

    if (response.statusCode == 200) {
      for (var item in data["articles"]) {
        NewsModel _artcileModel = NewsModel.fromJson(item);
        _articleModelList.add(_artcileModel);
      }
      return _articleModelList;
    } else {
      return _articleModelList; // empty list
    }
  }
  }



