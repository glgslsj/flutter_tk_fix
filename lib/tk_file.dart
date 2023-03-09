// @dart=2.9
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_tk/tk_config.dart';
import 'package:get/get.dart' as g;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';


class FileAsset {
  final String name;
  final RequestType type;
  final AssetEntity entity;
  final Uint8List bytes;

  FileAsset({
    this.name,
    this.type,
    this.entity,
    this.bytes,
  });
}

class TkFile {

  static Future<Uint8List> compressImage(
    FileAsset file, {
    int maxSize = 1800,
  }) async {
    var image = file.entity;
    var ext = image.title.split('.').last.toLowerCase();
    if (ext == 'gif') return await image.originBytes;
    if (image.height >= maxSize || image.width >= maxSize || ext == 'heic') {
      var format = ext == 'png' ? ThumbnailFormat.png : ThumbnailFormat.jpeg;
      var scale = image.height >= image.width
          ? image.height / maxSize
          : image.width / maxSize;
      var height = scale > 1 ? (image.height / scale).round() : image.height;
      var width = scale > 1 ? (image.width / scale).round() : image.width;
      ThumbnailSize size = ThumbnailSize(width, height);
      return await image.thumbnailDataWithSize(size, format: format);
    }
    return await image.originBytes;
  }

  static upload(FileAsset file) async {
    if (TkConfig().uploadUrl == null) throw ('必须设置uploadUrl才能上传文件');
    var data = TkHelper.isWeb ? file.bytes : await compressImage(file);
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(data),
    });
    Response res = await Dio().post(TkConfig().uploadUrl, data: formData);
    return res.data['url'];
  }
}

Map<RequestType, FileType> typeMap = {
  RequestType.image: FileType.image,
  RequestType.audio: FileType.audio,
  RequestType.video: FileType.video,
  RequestType.all: FileType.any,
  RequestType.common: FileType.media,
};

Map<String, String> assetsDirNames = {
  'Recent': '最近',
  'Live Photo': '实况照片',
  'Screenshots': '屏幕截图',
  'picture': '相册',
  'WeiXin': '微信',
  'images': '图片',
  'Camera': '照片',
  'Download': '下载',
};

