import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp_bloc/model/news_model.dart';
import 'package:newsapp_bloc/repository/INewsService.dart';

class NewsCubit extends Cubit<NewsState> {
  final INewsService newsService;

  bool isLoading = false;
  NewsCubit({required this.newsService}) : super(NewsInitial());

  void getNews() async {
    try {
      emit(NewsLoading());

      await Future.delayed(Duration(milliseconds: 500));
      final response = await newsService.getNews();

      emit(NewsCompleted(response));
    } on NetworkError catch (e) {
      emit(NewsError(e.messsage));
    }
  }
}

abstract class NewsState {
  const NewsState();

   @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsCompleted extends NewsState {
  final List<NewsModel> model;

  const NewsCompleted(this.model);
}

class NewsLoading extends NewsState {}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);
}

class NetworkError implements Exception {
  final String statusCode;
  final String messsage;

  NetworkError(this.statusCode, this.messsage);
}
