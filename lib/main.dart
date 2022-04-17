import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:band_names/screen/screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketServices())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home': ( _ ) => const HomeScreen(),
          'status': ( _ ) => const StatusScreen()
        },
      ),
    );
  }
}