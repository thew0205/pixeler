import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'colors.dart';
import 'functions.dart';
import 'moon_pixels._widget.dart';

class MonoPage extends StatefulWidget {
  const MonoPage({Key? key}) : super(key: key);

  @override
  State<MonoPage> createState() => _MonoPageState();
}

class _MonoPageState extends State<MonoPage> {
  int width = defaultPixelLength;
  int height = defaultPixelLength;
  final _formKey = GlobalKey<FormState>();
  static const int defaultPixelLength = 16;

  String? validateNumber(String? number) {
    if (number == null) return "Enter a valid number";
    if (int.tryParse(number) == null) {
      return "Enter a valid number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MonoPixels>(
      create: (context) => MonoPixels(),
      builder: (context, snapshot) {
        // return Builder(builder: (context) {
        return Scaffold(
            appBar: AppBar(title: Text("MonoPixel")),
            body: Column(
              children: [
                SelectableText('data'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PixelSizeInputForm(
                        value: context.watch<MonoPixels>().width.toString(),
                        hintText: 'Width',
                        text: 'Width',
                        validator: validateNumber,
                        onEditingComplete: ((value) {
                          if (value == null) return;
                          final tempWidth = int.tryParse(value);
                          if (tempWidth == null) return;
                          context.read<MonoPixels>().width = tempWidth;
                        })),
                    Icon(Icons.close, color: switchesColor),
                    PixelSizeInputForm(
                        value: context.watch<MonoPixels>().height.toString(),
                        validator: validateNumber,
                        hintText: 'height',
                        text: 'Height',
                        onEditingComplete: ((value) {
                          if (value == null) return;
                          final tempHeight = int.tryParse(value);
                          if (tempHeight == null) return;

                          context.read<MonoPixels>().height = tempHeight;
                        })),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(child: MonoPixelsWidget()),
                ),
                SelectableText(
                  context.watch<MonoPixels>().listString,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         content: SelectableText(
                  //             context.read<MonoPixels>().toString()),
                  //       );
                  //     });
                  context.read<MonoPixels>().notify();
                },
                child: Icon(Icons.abc)));
        // });
      },
    );
  }
}

extension boolean on bool {
  bool invert() {
    return !this;
  }
}

class Grid<T> {
  List<List<T>> _list = [];
  Grid({
    required List<List<T>> list,
  })  : assert(list.every((element) => element.length == list.first.length),
            "List must be same lenght"),
        _width = list.first.length,
        _height = list.length,
        _list = list;

  int _width;
  int _height;

  List<T> nthRow(int n) {
    if (n >= _height) throw IndexError(n, _height - 1);
    return _list[n];
  }

  List<T> nthColumn(int n) {
    if (n >= _width) throw IndexError(n, _width - 1);
    final returnList = <T>[];
    for (int i = 0; i < _height; i++) {
      returnList.add(_list[i][n]);
    }
    return returnList;
  }
}

class PixelSizeInputForm extends StatelessWidget {
  PixelSizeInputForm({
    Key? key,
    required this.text,
    this.hintText,
    var textEditingController,
    this.validator,
    this.onEditingComplete,
    this.errorText,
    this.value,
  })  : textEditingController = TextEditingController()..text = value ?? '',
        super(key: key);
  final String? value;
  final String text;
  final String? hintText;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final void Function(String?)? onEditingComplete;
  final String? errorText;
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              text,
              style: getTextStyle(
                  color: switchesColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: focusNode,
              // textInputAction: TextInputAction.done,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              onEditingComplete: () {
                // onEditingComplete?.call(textEditingController?.text);
              },
              onSubmitted: (value) {
                if (validator?.call(value) != null) {
                  return;
                }
                onEditingComplete?.call(value);
                FocusScope.of(context).unfocus();
              },
              style: GoogleFonts.sourceSansPro(
                  fontSize: 16, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: hintText,
                errorText: errorText,
                filled: true,
                fillColor: Color(0xe5e5e5e5),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: switchesColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: switchesColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
