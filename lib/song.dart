import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
//https://pub.dev/packages/just_audio used for audio playing

// This class represents a song that has an artist, songTitle, preview link for the mp3, album,
// image URL , audio player, and a play icon.
class Song {
  String? artist;
  String? songTitle;
  String? preview;
  String? album;
  String? imageUrl;
  final AudioPlayer audioPlayer = AudioPlayer();
  Icon playIcon = const Icon(Icons.play_arrow, color: Colors.red);


  // Constructor for setting instances and setting the audio player with the preview link
  Song(this.artist, this.songTitle, preview, this.album, this.imageUrl){
    audioPlayer.setUrl(preview);
  }
}