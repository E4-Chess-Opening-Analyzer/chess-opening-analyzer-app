import 'package:app/states/gameboard/gameboard_cubit.dart';
import 'package:app/views/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Opening Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E1A4D)),
        useMaterial3: true,
        fontFamily: 'Inria sans',
      ),
      home: BlocProvider<GameboardCubit>(
          create: (BuildContext context) => GameboardCubit(),
          child: const MainPage(),
      ),
    );
  }
}
