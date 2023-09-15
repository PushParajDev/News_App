import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class NewsWebView extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _fetchNewsArticles() async {
    final String apiKey = '72abd87555b541328d0cfefa263f33c5';
    final String apiUrl =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=72abd87555b541328d0cfefa263f33c5';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final articles = data['articles'] as List<dynamic>;

      if (articles.isNotEmpty) {
        return articles.cast<Map<String, dynamic>>();
      } else {
        throw 'No articles found.';
      }
    } else {
      throw 'Failed to fetch news data';
    }
  }
  final String articleUrl;

  NewsWebView({super.key, required this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Center(
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
              backgroundColor: Colors.black,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('FLUTTER',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(width: 8,),
                  Text('NEWS',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.blue),),
                ],
              ),
            ),
          ),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(articleUrl)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(

            ),
          ),
        ),
      ),

    );
  }
}