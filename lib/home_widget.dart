import 'package:flutter/material.dart';
import 'songs_model.dart';
import 'package:just_audio/just_audio.dart';
//https://pub.dev/packages/just_audio

/// This class displays the home page of the app
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.model});
  final SongsModel model;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  TextEditingController textController = TextEditingController();

  // Preserves the text in the textfield every time this widget gets rebuilt
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  // Clears the textfield and the songs in the list
  clearTextField(TextEditingController controller) {
    setState(() {
      controller.text = '';
      widget.model.clearSongs();
    });
  }

  // Clears any existing songs in the list and updates the songs in the list
  updateSongs(String keyword) {
    widget.model.fetchSongs(keyword);
  }

  // Plays a song if it's currently not being played and pauses a song if it's currently being played
  playSong(AudioPlayer audioPlayer, int index) {
    setState(() {
      if (audioPlayer.playing) {
        // If the audio is being played, pause it
        audioPlayer.stop();
        widget.model.songs[index].playIcon = const Icon(
          Icons.play_arrow,
          color: Colors.red,
        ); // Change the icon to play
      } else {
        // If it's not being played, play it
        audioPlayer
            .seek(Duration.zero); // Always play from the start of the audio
        audioPlayer.play();
        widget.model.songs[index].playIcon = const Icon(Icons.pause,
            color: Colors.red); // Change teh icon to pause
      }
    });
  }

  // Shorten the length of a title if it's more than 20 characters long
  String truncateTitle(String songTitle) {
    return (songTitle.length > 20)
        ? "${songTitle.substring(0, 20)}..."
        : songTitle;
  }

  // Shorten the length of the name of an artist if it's more than 15 characters long
  String truncateArtist(String artist) {
    return (artist.length > 15) ? "${artist.substring(0, 15)}..." : artist;
  }

  // Shorten the name of an album if it's more than 30 characters long
  String truncateAlbumName(String album) {
    return (album.length > 30) ? "${album.substring(0, 30)}..." : album;
  }

  // Widget that displays the list of songs depending on the list of songs in the model
  Widget displaySongs(BuildContext context) {
    if (widget.model.songs.isEmpty) {
      // If there is no songs in the list, let the user know
      return const Expanded(
        child: Center(
          child: Text('No songs to display'),
        ),
      );
    } else {
      // If there are songs in the list, display it
      return Expanded(
          child: ListView.separated(
        // Separate each tile with a light red colored line
        separatorBuilder: (context, index) => Divider(color: Colors.red[50]),
        itemCount: widget.model.songs.length,
        itemBuilder: (context, index) {
          return ListTile(
              // Each tile with an image, song title, artist, album and a play button
              leading: Image.network(widget.model.songs[index].imageUrl!),
              title: Text(// Truncate each text before displaying it
                  '"${truncateTitle(widget.model.songs[index].songTitle!)}" \n${truncateArtist(widget.model.songs[index].artist!)}'),
              subtitle: Text(
                  truncateAlbumName(widget.model.songs[index].album!),
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              trailing: IconButton(
                  onPressed:
                      () => // When the play button is pressed, play the song
                          playSong(
                              widget.model.songs[index].audioPlayer, index),
                  icon: widget.model.songs[index].playIcon));
        },
      ));
    }
  }

  // Builds the app bar for the home page
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Find Songs',
        style: TextStyle(color: Colors.white),
      ),
      actions: [ 
        IconButton( // For the refresh button, clear the text fields and songs
            onPressed: () => clearTextField(textController),
            icon: const Icon(Icons.refresh, color: Colors.white)),
        IconButton( // For the check button, update the songs in the list and display them
            onPressed: () => updateSongs(textController.text),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ))
      ],
      backgroundColor: Colors.red,
    );
  }

  // Builds the body of the home page
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Container( // Display and style the text field
          margin: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: "Enter a keyword",
                        contentPadding: EdgeInsets.all(10))),
              )
            ],
          ),
        ),
        displaySongs(context) // Display the songs in the list
      ],
    );
  }

  // Main widget displaying the home page with the app bar and the body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context), // Get the appbar
      body: buildBody(context), // Get the body
    );
  }
}
