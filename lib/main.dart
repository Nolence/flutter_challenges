import 'package:challenges/constants.dart';
import 'package:challenges/pages/fractals/fractals.dart';
import 'package:challenges/pages/walkers/walkers.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Home(),
      routes: {
        '/walkers': (_) => Walkers(),
        '/fractals': (_) => Fractals(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.all(kPaLg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: <Widget>[
            PageButton(
              title: 'Walkers',
              to: '/walkers',
              description:
                  'Animated Walkers using random, perlin and symplex noise',
            ),
            PageButton(
              title: 'Fractals',
              to: '/fractals',
              description: 'Simple and L-System Recursive fractals',
            ),
          ],
        ),
      ),
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({
    this.title,
    this.to,
    this.description,
  })  : assert(title != null),
        assert(to != null);

  final String to;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, to),
        child: Padding(
          padding: const EdgeInsets.all(kPa),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.title.copyWith(),
              ),
              const SizedBox(height: kGapSmall),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 16.0),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
