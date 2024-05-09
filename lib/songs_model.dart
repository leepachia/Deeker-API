import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'song.dart';
// Uses Deeze=-081` xcvbn,./ API: https://rapidapi.com/deezerdevs/api/deezer-1/

// This class is the model for the app that extends change notifier
class SongsModel extends ChangeNotifier {
  List<Song> songs = [];

  // Get the songs from the Deezer API depending on the user's keyword
  fetchSongs(String keyword) async {
    clearSongs(); // Make the list empty in case it isn't and stop playing any music if there are any playing
    
    await get( // Get the results and parse it
      Uri(
        scheme: 'https',
        host: 'deezerdevs-deezer.p.rapidapi.com',
        path: 'search',
        // ignore: prefer_interpolation_to_compose_strings
        query: 'q=$keyword',
      ),
      headers: {'X-RapidAPI-Key': '2022cac27cmsh9f820bdf2d950edp18387djsn57895a3410fc',
      'X-RapidAPI-Host': 'deezerdevs-deezer.p.rapidapi.com'},
      ).then((response) {
        // ignore: unused_local_variable
        var result = jsonDecode(response.body); // Decode the result and parse it
        parse(result);
      }).catchError((error) {
      // ignore: avoid_print
        print('Error: $error');
        throw 'Error!';
      }
    );
    notifyListeners();
  }

  // Parses the songs and puts them into a list
  parse(Map<String, dynamic> result) {
    List<dynamic> data = result['data'];

    // For each song, extract the title of the song, artist, preview, image, and album
    for (int i = 0; i < data.length; i++) {
      String songTitle = data[i]['title'];
      String preview = data[i]['preview'];
      String artist = data[i]['artist']['name'];
      String album = data[i]['album']['title'];
      String imageUrl = data[i]['artist']['picture'];

      // Make the song and add it to songs
      Song song = Song(artist, songTitle, preview, album, imageUrl);
      songs.add(song);
    }
  }

  // Clears the list of songs and stops playing any audios that are playing
  clearSongs() {
    // If there are any audios playing, stop them
    for (var song in songs) {
      if (song.audioPlayer.playing) { // If the current song is playing, stop playing it
        song.audioPlayer.stop();
      }
    }

    // Clear the list of songs
    songs = [];
    notifyListeners();
  }
}