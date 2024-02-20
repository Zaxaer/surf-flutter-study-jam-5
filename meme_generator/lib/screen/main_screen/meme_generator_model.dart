import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/domain/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MemeGeneratorModel extends ChangeNotifier {
  final GlobalKey previewContainer = GlobalKey();
  final BuildContext context;
  dynamic imageUrl = '';
  String inputImageUrl = '';
  String textMotivator = '';
  String inputTextMotivator = '';
  MemeGeneratorModel({
    required this.context,
  });

  void addNetworkImageToStack() {
    if (inputImageUrl.isEmpty) {
      return;
    }
    final bool isValid = RegExp(Constants.urlFormatter).hasMatch(inputImageUrl);
    if (isValid) {
      imageUrl = inputImageUrl;
      notifyListeners();
    }
  }

  void addTextToStack() {
    if (inputTextMotivator.isEmpty) {
      return;
    }
    textMotivator = inputTextMotivator;
    notifyListeners();
  }

  void deleteLastImage() {
    imageUrl = '';
    notifyListeners();
  }

  void deleteLastText() {
    textMotivator = '';
    notifyListeners();
  }

  void pickImagefromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);
        imageUrl = imageFile;
        notifyListeners();
      } else {
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> shareScreenShot() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final dir = await getTemporaryDirectory();
    var filename = '${dir.path}/image.png';
    // Save to filesystem
    final file = File(filename);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await file.writeAsBytes(pngBytes);

    Share.shareXFiles([XFile(file.path)], text: 'Great picture');
  }
}
