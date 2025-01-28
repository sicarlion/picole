import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';

final cloudinary = Cloudinary.full(
  apiKey: '828658633436799',
  apiSecret: '0ON_LXM62U1Mh1JufaVGQ2hSLd8',
  cloudName: 'dfv5twcgr',
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
        resourceType: CloudinaryResourceType.image,
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
        resourceType: CloudinaryResourceType.image,
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

class Asset {
  /// The URL of the Image
  String url;
  List<double> dimension;

  Asset({required this.url, required this.dimension});

  Asset toThumb() {
    // Find the position to insert the new string
    String insertion = "c_thumb,q_10,f_auto/";
    String updatedUrl = url.replaceFirst("/v", "/${insertion}v");

    return Asset(url: updatedUrl, dimension: dimension);
  }

  /// Drop the value of asset and remove the image from database.
  void drop() {}
}
