import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class PVSong extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> play(String song) async {
    await _player.stop();
    await _player.play(AssetSource(song.replaceFirst('assets/', '')));
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> toggle(String song) async {
    if (_isPlaying) {
      await stop();
    } else {
      await play(song);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class MusicRadioPage extends StatefulWidget {
  const MusicRadioPage({super.key});

  @override
  State<MusicRadioPage> createState() => _MusicRadioPageState();
}

class _MusicRadioPageState extends State<MusicRadioPage> {
  String _selectedSong = 'assets/dubai_song.mp3';

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<PVSong>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار أغنية"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text("Dubai Song"),
            value: 'assets/dubai_song.mp3',
            groupValue: _selectedSong,
            onChanged: (value) {
              setState(() {
                _selectedSong = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => songProvider.toggle(_selectedSong),
            child: Text(songProvider.isPlaying ? "إيقاف" : "تشغيل"),
          ),
        ],
      ),
    );
  }
}
