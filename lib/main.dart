import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:url_launcher/url_launcher.dart';

import 'webview.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  String _formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    final outputFormat = DateFormat('EEEE, MMMM d, y, h:mm a');
    final DateTime dateTime = DateTime.parse(dateString);
    final formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

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
                icon: Icon(Icons.menu),
                onPressed: (){
                  print("click menu button");
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchNewsArticles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final articles = snapshot.data;

              return ListView.builder(
                itemCount: articles?.length,
                itemBuilder: (context, index) {
                  final article = articles?[index];
                  final title = article?['title'] as String;
                  final url = article?['url'] as String;
                  final publishedAt = article?['publishedAt'] as String;

                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsWebView(articleUrl:'articles')));
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
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              article!["title"].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              //let's add the height

                              image: DecorationImage(
                                  image: NetworkImage(article!["urlToImage"].toString()), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            article!["description"].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_formatDate(publishedAt),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceWebView: true,
          forceSafariVC: true,
          enableJavaScript: true,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error gracefully, e.g., show an error message to the user.
    }
  }
}





