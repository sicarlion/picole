import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/solution/storage.dart';
import 'package:picole/ui/main/ui_create.dart';
import 'package:uuid/uuid.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController tags = TextEditingController();
  Rating? rating = Rating.general;
  Categories? categories = Categories.normal;

  String? id;
  List<double> dimension = [0, 0];
  File? file;
  bool hasError = false;
  bool isProcessing = false;
  String errorMessage = '';
  Post? post;
  User? artist;

  @override
  void initState() {
    super.initState();
    id = Uuid().v4();
  }

  Future<int> createPost() async {
    if (file == null) {
      setError(1);
      return 1;
    }
    if (title.text == "") {
      setError(2);
      return 2;
    }
    if (isProcessing) {
      setError(3);
      return 3;
    }

    setState(() {
      isProcessing = true;
    });
    artist = await Client.session();

    if (id == null) {
      setState(() {
        isProcessing = false;
      });
      return 4;
    }

    final uploaded = await Storage(image: file, id: id!).dump();
    post = Post(
      id: id!,
      artist: artist!,
      image: Asset(url: uploaded.url, dimension: uploaded.dimension),
      title: title.text,
      description: description.text,
      rating: rating!,
      categories: categories!,
      tags: tags.text,
    );

    await post!.assign();

    setState(() {
      isProcessing = false;
    });

    return 0;
  }

  void setError(int error) {
    setState(() {
      switch (error) {
        case 0:
          hasError = false;
        case 1:
          hasError = true;
          errorMessage = "You are not assigning any image!";
        case 2:
          hasError = true;
          errorMessage = "Title cannot be empty!";
        case 3:
          hasError = true;
          errorMessage = "Image is still processing!";
        case 4:
          hasError = true;
          errorMessage = "Failed retrieving Post ID in time. Please try again.";
      }
    });
  }

  void setRating(Rating? value) {
    setState(() {
      rating = value;
    });
  }

  void setCategories(Categories? value) {
    setState(() {
      categories = value;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return uiCreate(context, this);
  }
}
