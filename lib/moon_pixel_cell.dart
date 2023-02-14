import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MonoPixelCell extends StatelessWidget {
  const MonoPixelCell({
    Key? key,
    // required this.x,
    // required this.y,
  }) : super(key: key);
  // final VoidCallback? invert;
  // final int x;
  // final int y;

  @override
  Widget build(BuildContext context) {
    print("************************");
    return InkWell(
      onTap: () {
        context.read<Pixel>().invert();
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: context.watch<Pixel>().pixel ? Colors.red : Colors.black,
            ),
            child: const SizedBox(
              width: 10,
              height: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class Pixel extends ChangeNotifier {
  bool _pixel;

  Pixel(this._pixel);

  set pixel(bool pixel) {
    _pixel = pixel;
    notifyListeners();
  }

  bool get pixel => _pixel;
  void invert() {
    pixel = !_pixel;
    notifyListeners();
  }
}
