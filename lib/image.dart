import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function setImage;

  ImageInput(this.setImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).accentColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: Theme.of(context).accentColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        OutlineButton(

          borderSide: BorderSide(color: accentColor, width: 2.0),
          onPressed: _openImagePicker,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: accentColor),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Add Image',
                style: TextStyle(color: accentColor),
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
        _imageFile == null
            ? Text('Pick an image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              )
      ],
    );
  }
}
