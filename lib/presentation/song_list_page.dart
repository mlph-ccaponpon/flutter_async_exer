import 'package:flutter/material.dart';
import 'package:flutter_async_exer/model/song.dart';
import 'package:flutter_async_exer/presentation/song_search_page.dart';
import 'package:flutter_async_exer/service/song_service.dart';

class SongListPage extends StatefulWidget {
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final SongService songService = new SongService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Song'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SongSearchPage()));
              },
              child: Icon(
                Icons.search,
                size: 26,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: songService.getRecommendedSongs(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Song song = snapshot.data[index];
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(song.background),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.subtitle));
                },
              );
            } else if (snapshot.hasError) {
              return Text('No Song');
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
