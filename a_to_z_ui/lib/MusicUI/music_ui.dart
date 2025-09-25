import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';

class PVSong extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  bool _istarted = false;

  void start() {}

  Future<void> play(String song) async {
    await _player.stop();
    await _player.setAsset(song);

    await _player.play();
  }

  void stop() {
    _player.stop();
  }
}

class MusicRadioPage extends StatefulWidget {
  const MusicRadioPage({super.key});

  @override
  State<MusicRadioPage> createState() => _MusicRadioPageState();
}

class _MusicRadioPageState extends State<MusicRadioPage> {
  String _selectedSong = 'dubai_song.mp3';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _playSong() async {
    await context.read<PVSong>().play('assets/$_selectedSong');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار أغنية"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text("Dubai Song"),
            value: 'dubai_song.mp3',
            groupValue: _selectedSong,
            onChanged: (value) {
              setState(() {
                _selectedSong = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _playSong, child: const Text("تشغيل")),
        ],
      ),
    );
  }
}
