//Flutter
import 'package:flutter/material.dart';

//Local widgets
import 'package:rick_and_morty_app/widgets/cards.dart';

class CharactersHome extends StatefulWidget {
  static String id = 'Characters';
  final size;

  const CharactersHome({Key key, this.size}) : super(key: key);

  @override
  _CharactersHome createState() {
    print('Characters screen: createS');
    return _CharactersHome();
  }
}

class _CharactersHome extends State<CharactersHome> {
  double _xOffset;
  double _yOffset;
  double _scaleFactor;
  double _border;
  bool _isDrawerOpen;

  @override
  void initState() {
    super.initState();
    print('Characters screen: init');
    _xOffset = 0;
    _yOffset = 0;
    _scaleFactor = 1.0;
    _border = 0;
    _isDrawerOpen = false;
  }

  void _scaleFactorUpdate(DragUpdateDetails details, Size size) {
    _xOffset = details.globalPosition.dx;
    _yOffset = details.globalPosition.dx / 2 + 20;
    _scaleFactor = details.globalPosition.direction - 0.4;
    _border = 40;
  }

  void drawerState(bool _isDrawerOpen, Size size) {
    if (_isDrawerOpen) {
      _xOffset = size.width * 0.5;
      _yOffset = size.width * 0.5 / 2 + 20;
      _scaleFactor = 0.8;
    } else {
      _xOffset = 0;
      _yOffset = 0;
      _scaleFactor = 1.0;
      _border = 0;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print('Characters screen: deactivated');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    print('Characters screen: build');
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_border),
              bottomLeft: Radius.circular(_border - 20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(90),
                blurRadius: 5.0,
                spreadRadius: 8.0,
                offset: Offset(10, 5))
          ]),
      transform: Matrix4.translationValues(_xOffset, _yOffset, 0)
        ..scale(_scaleFactor),
      duration: Duration(milliseconds: 250),
      child: GestureDetector(
        //TODO: try to optimize (somehow(?)) the drag and respectives disposes
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.globalPosition.dx <= widget.size.width * 0.5) {
            setState(() {
              _scaleFactorUpdate(details, widget.size);
            });
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          setState(() {
            if (_xOffset >= widget.size.width * 0.4) {
              _isDrawerOpen = true;
            } else {
              _isDrawerOpen = false;
            }
            drawerState(_isDrawerOpen, widget.size);
          });
        },
        child: Column(
          children: [
            Expanded(
                child: Cards(
              path: 'character',
              size: widget.size,
            ))
          ],
        ),
      ),
    );
  }
}
