import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/engremagens.riv').then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.

          artboard.addController(_controller = SimpleAnimation('Spin2'));
          _togglePlay();

          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  void _togglePlay() {
    _controller.apply(RuntimeArtboard(), 1.0);
    setState(() => _controller.isActive = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Container(
            width: 200.0,
            height: 200.0,
            child: _riveArtboard == null
                ? const SizedBox(
                    child: Text(" Não há _riveArtboard"),
                  )
                : Rive(artboard: _riveArtboard),
          ),
        ),
      ),
    );
  }
}
