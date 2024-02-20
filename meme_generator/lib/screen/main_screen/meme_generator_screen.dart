import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meme_generator/screen/main_screen/meme_generator_model.dart';

class MemeGeneratorScreen extends StatelessWidget {
  final MemeGeneratorModel model;
  const MemeGeneratorScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MemeGeneratorModel>();
    final decoration = BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );
    final size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _ImageScreenWidget(
                size: size,
                decoration: decoration,
              ),
              const SizedBox(height: 12),
              _MenuWidget(model: model),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuWidget extends StatelessWidget {
  final MemeGeneratorModel model;
  const _MenuWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black, fontSize: 25);
    final model = context.read<MemeGeneratorModel>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MenuButtonWidget(
              onChanged: (value) => model.inputImageUrl = value,
              alertTitleText: 'Past URL image',
              buttonText: 'Add image from URl',
              function: () {
                model.addNetworkImageToStack();
                Navigator.pop(context);
              },
              model: model,
            ),
            _PopButtonWidget(function: model.deleteLastImage)
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => model.pickImagefromGallery(),
              child: const Text(
                'Add image from gallery',
                style: style,
              ),
            ),
            _PopButtonWidget(function: model.deleteLastImage)
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MenuButtonWidget(
              onChanged: (value) => model.inputTextMotivator = value,
              alertTitleText: 'Past text',
              buttonText: 'Add text',
              function: () {
                model.addTextToStack();
                Navigator.pop(context);
              },
              model: model,
            ),
            _PopButtonWidget(function: model.deleteLastText)
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => model.shareScreenShot(),
          child: const Text(
            'Share screen shot',
            style: style,
          ),
        ),
      ],
    );
  }
}

class _PopButtonWidget extends StatelessWidget {
  final void Function() function;
  const _PopButtonWidget({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: function,
        icon: const Icon(
          Icons.restore_from_trash_outlined,
          color: Colors.white,
        ));
  }
}

class _MenuButtonWidget extends StatelessWidget {
  final void Function() function;
  final MemeGeneratorModel model;
  final String buttonText;
  final String alertTitleText;
  final void Function(String) onChanged;
  const _MenuButtonWidget({
    Key? key,
    required this.function,
    required this.model,
    required this.buttonText,
    required this.alertTitleText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black, fontSize: 25);
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(alertTitleText),
          content: ListenableProvider.value(
            value: model,
            child: _TextFieldWidget(onChanged: onChanged),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                function();
                Navigator.of(context).pop;
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
      child: Text(
        buttonText,
        style: style,
      ),
    );
  }
}

class _ImageScreenWidget extends StatelessWidget {
  const _ImageScreenWidget({
    required this.size,
    required this.decoration,
  });

  final double size;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MemeGeneratorModel>();
    return RepaintBoundary(
      key: model.previewContainer,
      child: Container(
        alignment: Alignment.center,
        height: size,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.white,
              width: 2,
            )),
        child: Stack(
          children: <Widget>[
            DragBoxImage(
              size: size,
              image: model.imageUrl,
            ),
            DragBoxText(
              size: size,
              text: model.textMotivator,
            )
          ],
        ),
      ),
    );
  }
}

class DragBoxImage extends StatefulWidget {
  final double size;
  final dynamic image;

  const DragBoxImage({
    Key? key,
    required this.size,
    required this.image,
  }) : super(key: key);
  @override
  DragBoxImageState createState() => DragBoxImageState();
}

class DragBoxImageState extends State<DragBoxImage> {
  Offset position = const Offset(0.0, 0.0);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MemeGeneratorModel>();
    return model.imageUrl == ''
        ? const SizedBox.shrink()
        : Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  position = offset;
                });
              },
              feedback: SizedBox(
                width: widget.size,
                height: widget.size / 2,
                child: Center(
                    child: widget.image is String
                        ? Image(image: NetworkImage(widget.image))
                        : Image(image: FileImage(widget.image))),
              ),
              child: SizedBox(
                width: widget.size,
                height: widget.size / 2,
                child: Center(
                    child: widget.image is String
                        ? Image(image: NetworkImage(widget.image))
                        : Image(image: FileImage(widget.image))),
              ),
            ),
          );
  }
}

class DragBoxText extends StatefulWidget {
  final double size;
  final String text;
  const DragBoxText({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);
  @override
  DragBoxTextState createState() => DragBoxTextState();
}

class DragBoxTextState extends State<DragBoxText> {
  Offset position = const Offset(0.0, 0.0);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 25);
    final model = context.watch<MemeGeneratorModel>();
    return model.imageUrl == ''
        ? const SizedBox.shrink()
        : Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  position = offset;
                });
              },
              feedback: SizedBox(
                width: widget.size / 2,
                child: Center(
                    child: Text(
                  widget.text,
                  style: style,
                )),
              ),
              child: SizedBox(
                width: widget.size / 2,
                child: Center(
                    child: Text(
                  widget.text,
                  style: style,
                )),
              ),
            ));
  }
}

class _TextFieldWidget extends StatelessWidget {
  final void Function(String) onChanged;
  const _TextFieldWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      onChanged: onChanged,
    );
  }
}
