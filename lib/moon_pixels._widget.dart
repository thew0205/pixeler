import 'package:flutter/foundation.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



import 'moon_pixel_cell.dart';

class MonoPixelsWidget extends StatelessWidget {
  const MonoPixelsWidget({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    print("/////////////////////////////////////");
    final height = context.watch<MonoPixels>().height;
    final width = context.watch<MonoPixels>().width;
    final pixels = context.watch<MonoPixels>().pixels;
    return Center(
        child: Table(
      border: TableBorder(borderRadius: BorderRadius.circular(5)),
      children: [
        for (int y = 0; y < height; y++)
          TableRow(children: [
            for (int x = 0; x < width; x++)
              ChangeNotifierProvider.value(
                  value: pixels[y][x],
                  builder: (context, child) {
                    return MonoPixelCell();
                  })
          ])
      ],
    ));
  }
}

class MonoPixels extends ChangeNotifier {
  MonoPixels()
      : _pixels = [
          for (int y = 0; y < 16; y++)
            [
              for (int x = 0; x < 16; x++) Pixel(false),
            ],
        ];

  int _height = 16;
  int _width = 16;

  final List<List<Pixel>> _pixels;

  List<List<Pixel>> get pixels => _pixels;

  set height(int height) {
    var tempList = _pixels;
    if (height < _height) {
      for (var y = height; y < _height; y++) {
        _pixels[y].removeLast();
      }
      // tempList = tempList.sublist(0, height);
    } else if (_height > height) {
      _pixels.addAll([
        for (int y = _height; y < height; y++)
          [for (int x = 0; x < _width; x++) Pixel(false)]
      ]);
    }
    _height = height;
    notifyListeners();
    // pixels = tempList;
  }

  int get width => _width;
  int get height => _height;
  set width(int width) {
    List<List<Pixel>> tempPixels = _pixels;
    if (width < _width) {
      for (int y = 0; y < _height; y++) {
        for (var i = 0; i < _width - width; i++) {
          _pixels[y].removeLast();
        }
        // tempPixels[i] = _pixels[i].sublist(0, width);
      }
    } else if (width > _width) {
      for (int y = 0; y < _height; y++) {
        _pixels[y].addAll([for (int x = _width; x < width; x++) Pixel(false)]);
      }
    }

    _width = width;
    notifyListeners();
    // pixels = tempPixels;
  }

  // set pixels(List<List<Pixel>> pixels) {
  //   // _pixels = pixels;
  //   notifyListeners();
  // }

  Uint8List pi() {
    var pixelList = <int>[];
    for (int y = 0; y < _height; y++) {
      int uint8_t = 0;

      int x = 0;
      while (x < _width) {
        if (_width - x > 8) {
          for (int i = 0; i < 8; i++) {
            uint8_t |= (_pixels[y][x + i].pixel ? 1 : 0) << 7 - i;
          }
          x += 8;
        } else {
          for (int i = 0; i < _width - x; i++) {
            uint8_t |= (_pixels[y][x + i].pixel ? 1 : 0) << 7 - i;
          }
          x = width;
        }
        pixelList.add(uint8_t);
        uint8_t = 0;
      }
      x = 0;
    }
    return Uint8List.fromList(pixelList);
  }

  void notify() {
    notifyListeners();
  }

  String get listString {
    String ret = '';

    final row = (_width / 8).ceil();
    final pixelList = pi();
    for (int i = 0; i < pixelList.length; i++) {
      ret += '0b' + pixelList[i].toRadixString(2).padLeft(8, '0');
      if (i % row == row - 1) {
        ret += ',\n';
      } else {
        ret += ',';
      }
    }

    return ret;
  }
}
