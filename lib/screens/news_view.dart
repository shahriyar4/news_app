import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:newsapp_bloc/blocs/news_cubit.dart';
import 'package:newsapp_bloc/model/news_model.dart';
import 'package:newsapp_bloc/repository/news_service.dart';

class NewsView extends StatefulWidget {
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(
        newsService: NewsService(),
      ),
      child: buildScaffold(context),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewsView'),
      ),
      body: BlocConsumer<NewsCubit, NewsState>(
        listener: (context, state) {
          if (state is NewsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is NewsInitial) {
            return Center(
              child: Column(
                children: [
                  Text("Hello"),
                  FloatingActionButton(
                    onPressed: () => context.read<NewsCubit>().getNews(),
                    child: Icon(Icons.forward),
                  )
                ],
              ),
            );
          } else if (state is NewsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsCompleted) {
            List<NewsModel> _articleList = [];
            _articleList = state.model;
            return ListView.builder(
              itemCount: _articleList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      FlutterWebBrowser.openWebPage(
                        url: _articleList[index].url.toString(),
                        customTabsOptions: CustomTabsOptions(
                          colorScheme: CustomTabsColorScheme.dark,
                          toolbarColor: Colors.deepPurple,
                          secondaryToolbarColor: Colors.green,
                          navigationBarColor: Colors.amber,
                          addDefaultShareMenuItem: true,
                          instantAppsEnabled: true,
                          showTitle: false,
                          urlBarHidingEnabled: false,
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  _articleList[index].urlToImage != null
                                      ? _articleList[index]
                                          .urlToImage
                                          .toString()
                                      : "https://i.stack.imgur.com/y9DpT.jpg",
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          children: [
                            Text(
                              _articleList[index].title.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            final error = state as NewsError;
            return Center(
              child: Text(error.message),
            );
          }
        },
      ),
    );
  }
}
