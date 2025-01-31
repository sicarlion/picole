import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picole/solution/database.dart';

final cloudinary = Cloudinary.full(
  apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
  apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!,
  cloudName: dotenv.env['CLOUDINARY_API_NAME']!,
);

/// The main class for Picole Image Storage
class Storage {
  String? id;
  File? image;

  Storage({required this.id, required this.image});

  Future<Asset> dump() async {
    if (id != null && image != null) {
      var decodedImage = await decodeImageFromList(image!.readAsBytesSync());
      var dimension = [
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble()
      ];

      final CloudinaryResponse response =
          await cloudinary.uploadResource(CloudinaryUploadResource(
        filePath: image!.path,
        fileBytes: image!.readAsBytesSync(),
        resourceType: CloudinaryResourceType.auto,
        folder: '/posts/',
        fileName: id.toString(),
      ));

      if (response.isSuccessful) {
        if (response.secureUrl != null) {
          return Asset(
            url: response.secureUrl!,
            dimension: [dimension[0], dimension[1]],
          );
        }
      }
      return Asset(url: '', dimension: [0, 0]);
    }

    return Asset(url: '', dimension: [0, 0]);
  }

  Future<Asset> stamp() async {
    if (id != null && image != null) {
      var decodedImage = await decodeImageFromList(image!.readAsBytesSync());
      var dimension = [
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble()
      ];

      final CloudinaryResponse response =
          await cloudinary.uploadResource(CloudinaryUploadResource(
        filePath: image!.path,
        fileBytes: image!.readAsBytesSync(),
        resourceType: CloudinaryResourceType.auto,
        folder: '/avatar/',
        fileName: id.toString(),
      ));

      if (response.isSuccessful) {
        if (response.secureUrl != null) {
          return Asset(
            url: response.secureUrl!,
            dimension: [dimension[0], dimension[1]],
          );
        }
      }
      return Asset(url: '', dimension: [0, 0]);
    }

    return Asset(url: '', dimension: [0, 0]);
  }
}
