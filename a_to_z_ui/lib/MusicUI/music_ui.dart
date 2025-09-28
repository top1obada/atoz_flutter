import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveSong {
  SaveSong._();

  static Future<void> save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ATOZ_Song', value);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ATOZ_Song');
  }
}

class PVSong extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentSong;
  int _currentSongIndex = 0;

  bool get isPlaying => _isPlaying;
  String? get currentSong => _currentSong;
  int get currentSongIndex => _currentSongIndex;

  PVSong() {
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    _player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // Song finished - restart it automatically
        _restartCurrentSong();
      }
    });

    _player.onPlayerComplete.listen((event) {
      // Song completed - restart it
      _restartCurrentSong();
    });
  }

  Future<void> _restartCurrentSong() async {
    if (_currentSong != null) {
      await _player.stop();
      await _player.play(
        AssetSource(_currentSong!.replaceFirst('assets/', '')),
      );
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> start() async {
    // Read saved song preference on start
    final savedSong = await SaveSong.read();
    if (savedSong != null && savedSong.isNotEmpty) {
      _currentSong = savedSong;
      // Auto-play the saved song if it exists
      await play(savedSong);
    }
    notifyListeners();
  }

  Future<void> play(String song) async {
    await _player.stop();
    await _player.play(AssetSource(song.replaceFirst('assets/', '')));
    _isPlaying = true;
    _currentSong = song;
    // Save the selected song
    await SaveSong.save(song);
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    _currentSong = null;
    // Clear saved song when stopped
    await SaveSong.save('');
    notifyListeners();
  }

  Future<void> toggle(String song) async {
    if (_isPlaying && _currentSong == song) {
      await stop();
    } else {
      await play(song);
    }
  }

  Future<void> playNext(List<Map<String, dynamic>> songs) async {
    if (songs.isEmpty) return;

    int currentIndex = songs.indexWhere((s) => s['file'] == _currentSong);
    int nextIndex = (currentIndex + 1) % songs.length;

    await play(songs[nextIndex]['file']);
  }

  Future<void> playPrevious(List<Map<String, dynamic>> songs) async {
    if (songs.isEmpty) return;

    int currentIndex = songs.indexWhere((s) => s['file'] == _currentSong);
    int previousIndex = currentIndex <= 0 ? songs.length - 1 : currentIndex - 1;

    await play(songs[previousIndex]['file']);
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
  // Easy to add more songs - just add new entries to this list
  final List<Map<String, dynamic>> _songs = [
    {
      'title': 'أغنية دبي الاسترخاء',
      'artist': 'موسيقى تسوق هادئة',
      'file': 'assets/dubai_song.mp3',
      'color': Colors.blue,
      'icon': Icons.beach_access,
    },

    // Add more songs here easily by copying the format above
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<PVSong>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "راديو المتجر",
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.grey[100]!],
          ),
        ),
        child: Column(
          children: [
            // Now Playing Section
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[600]!, Colors.purple[600]!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.graphic_eq,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    songProvider.isPlaying ? 'جاري التشغيل' : 'متوقف',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    songProvider.currentSong != null
                        ? _getSongTitle(songProvider.currentSong!)
                        : 'اختر أغنية',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Navigation buttons when multiple songs available
                  if (_songs.length > 1 && songProvider.isPlaying)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                          ),
                          onPressed: () => songProvider.playPrevious(_songs),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                          ),
                          onPressed: () => songProvider.playNext(_songs),
                        ),
                      ],
                    ),

                  // Animated equalizer when playing
                  if (songProvider.isPlaying)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          width: 4,
                          height: 20 + (index % 3) * 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),

            // Control Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors:
                          songProvider.isPlaying
                              ? [Colors.red[400]!, Colors.red[600]!]
                              : [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        songProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        songProvider.isPlaying
                            ? 'إيقاف التشغيل'
                            : 'تشغيل الموسيقى',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).pressable(() {
              if (songProvider.currentSong != null) {
                songProvider.toggle(songProvider.currentSong!);
              } else {
                // If no song is selected, play the first song
                songProvider.toggle(_songs.first['file']);
              }
            }),

            const SizedBox(height: 24),

            // Songs List
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'الأغاني المتاحة (${_songs.length})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _songs.length,
                        itemBuilder: (context, index) {
                          final song = _songs[index];
                          final isSelected =
                              songProvider.currentSong == song['file'];
                          final isPlaying =
                              songProvider.isPlaying && isSelected;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? song['color'].withOpacity(0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: song['color'],
                                        width: 2,
                                      )
                                      : null,
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: song['color'],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  song['icon'],
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                song['title'],
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected
                                          ? song['color']
                                          : Colors.grey[800],
                                ),
                              ),
                              subtitle: Text(
                                song['artist'],
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color:
                                      isSelected
                                          ? song['color'].withOpacity(0.8)
                                          : Colors.grey[600],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Radio button indicator
                                  Radio(
                                    value: song['file'],
                                    groupValue: songProvider.currentSong,
                                    onChanged: (value) {
                                      songProvider.toggle(song['file']);
                                    },
                                    activeColor: song['color'],
                                  ),
                                  // Playing indicator
                                  if (isPlaying)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: song['color'],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.graphic_eq,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                songProvider.toggle(song['file']);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getSongTitle(String songFile) {
    try {
      return _songs.firstWhere((song) => song['file'] == songFile)['title'];
    } catch (e) {
      return 'أغنية غير معروفة';
    }
  }
}

// Extension for pressable effect
extension Pressable on Widget {
  Widget pressable(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: this,
      ),
    );
  }
}
