import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_async_exer/model/song.dart';
import 'package:flutter_async_exer/service/song_service.dart';

class SongSearchPage extends StatefulWidget {
  @override
  _SongSearchPageState createState() => _SongSearchPageState();
}

class _SongSearchPageState extends State<SongSearchPage> {
  final SongService songService = new SongService();
  TextEditingController textEditingController = TextEditingController();

  // Stream initialize
  late StreamController streamController;
  late Stream _stream;

  // Search Song function
  searchSong() async {
    if (textEditingController.text.length == 0) {
      streamController.add(null);
      return;
    }
    streamController.add('waiting');
    String songTerm = textEditingController.text.trim();
    List<Song> searchSongList = await songService.searchSong(term: songTerm);
    streamController.add(searchSongList);
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    _stream = streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Songs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 11),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white),
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Search for a song',
                      contentPadding: const EdgeInsets.only(left: 24),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  searchSong();
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Enter a song'),
              );
            } else if (snapshot.data == 'waiting') {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // output
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Song song = snapshot.data[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.background),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.subtitle),
                );
              },
            );
          },
          stream: _stream,
        ),
      ),
    );
  }
}
