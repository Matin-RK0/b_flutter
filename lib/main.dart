import 'package:audio_service/audio_service.dart';
import 'package:blue_music_player/notifiers/songs_provider.dart';
import 'package:blue_music_player/screens/Home/homepage.dart';
import 'package:blue_music_player/services/data.dart';
import 'package:blue_music_player/services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

SongHandler _songHandler = SongHandler();

Future<void> main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveDataBaseAdapter());
  await Hive.openBox<HiveDataBase>('songs');

  // Initialize AudioService with the custom SongHandler
  _songHandler = await AudioService.init(
    builder: () => SongHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.Blue.app',
      androidNotificationChannelName: 'Blue Player',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );

  // Run the application
  runApp(
    MultiProvider(
      providers: [
        // Provide the SongsProvider with the loaded songs and SongHandler
        ChangeNotifierProvider(
          create: (context) => SongsProvider()..loadSongs(_songHandler),
        ),
      ],
      // Use the MainApp widget as the root of the application
      child: const MyApp(),
    ),
  );

  // Set preferred orientations for the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Color(0xff1C1B1B),
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      home: HomePage(songHandler: _songHandler),
    );
  }
}
