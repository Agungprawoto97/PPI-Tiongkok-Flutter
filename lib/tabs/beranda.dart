import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import '../screens/beritapost.dart' as _beritaPostPage;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_html/flutter_html.dart';

class HomeMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Home();
}

class Home extends State<HomeMain> with AutomaticKeepAliveClientMixin<HomeMain>{

  bool get wantKeepAlive => true;

  // Base URL for our wordpress API
  final String apiUrl = "http://www.ppitiongkok.org/wp-json/wp/v2/";

  // Empty list for our posts
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        _buildTile(
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Selamat Datang di',
                              style: TextStyle(color: Colors.red)),
                          Padding(padding: EdgeInsets.only(bottom: 3.0)),
                          Text('PPI Tiongkok',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 32.0)),
                        ],
                      ),
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(0.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new Image.asset('res/logo.jpg',
                                width: 40.0, height: 62.0),
                          )))
                    ],
                  ),
                ],
              )),
        ),
        ListView.builder(
          itemCount: posts == null ? 0 : posts.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildTile(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: posts[index]["featured_media"] == 0
                        ? 'http://www.ppitiongkok.org/wp-content/uploads/2018/08/no_image.jpg'
                        : posts[index]["_embedded"]["wp:featuredmedia"][0]
                            ["source_url"],
                  ),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new ListTile(
                      title: new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: new Text(posts[index]["title"]["rendered"])),
                      subtitle: new Html(data: posts[index]["excerpt"]["rendered"]),
                    ),
                  ),
                  new ButtonTheme.bar(
                    child: new ButtonBar(
                      children: <Widget>[
                        new FlatButton(
                          child: const Text('READ MORE'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    new _beritaPostPage.beritapost(
                                        post: posts[index]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 110.0),
        StaggeredTile.extent(2, 900.0),
      ],
    ));
  }
}

Widget _buildTile(Widget child, {Function() onTap}) {
  return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
          onTap: onTap != null
              ? () => onTap()
              : () {
                  print('Not set yet');
                },
          child: child));
}
