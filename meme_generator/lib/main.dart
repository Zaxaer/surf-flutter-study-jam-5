import 'package:flutter/material.dart';
import 'package:meme_generator/screen/main_screen/meme_generator_model.dart';
import 'package:meme_generator/screen/main_screen/meme_generator_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MemeGeneratorModel(context: context);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
          create: (_) => model, child: MemeGeneratorScreen(model: model)),
    );
  }
}
