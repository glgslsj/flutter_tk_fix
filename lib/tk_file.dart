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
  static Future<List<FileAsset>> pick({
    int max = 1,
    RequestType type = RequestType.image,
    Color color,
  }) async {
    if (TkHelper.isWeb) {
      FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: max > 1, type: typeMap[type]);
      if (result == null) return [];
      List<PlatformFile> files = result.files.getRange(0, max).toList();
      return files
          .map((e) => FileAsset(name: e.name, type: type, bytes: e.bytes))
          .toList();
    } else {
      List<AssetEntity> files = await AssetPicker.pickAssets(
        g.Get.context,
        maxAssets: max,
        requestType: type,
        themeColor: color ?? g.Get.theme.primaryColor,
        specialItemPosition: SpecialItemPosition.prepend,
        sortPathDelegate: CustomSortPathDelegate(),
        specialItemBuilder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final AssetEntity result = await CameraPicker.pickFromCamera(
                context,
                enableRecording: type != RequestType.image,
                theme: ThemeData(accentColor: Colors.white70),
              );
              if (result != null) {
                Navigator.of(context).pop(<AssetEntity>[result]);
              }
            },
            child: const Center(
              child: Icon(
                Icons.camera_alt,
                size: 36.0,
                color: Colors.white70,
              ),
            ),
          );
        },
      );
      if (files == null) return [];
      return files
          .map((e) => FileAsset(name: e.title, type: type, entity: e))
          .toList();
    }
  }

  static Future<Uint8List> compressImage(
    FileAsset file, {
    int maxSize = 1800,
  }) async {
    var image = file.entity;
    var ext = image.title.split('.').last.toLowerCase();
    if (ext == 'gif') return await image.originBytes;
    if (image.height >= maxSize || image.width >= maxSize || ext == 'heic') {
      var format = ext == 'png' ? ThumbFormat.png : ThumbFormat.jpeg;
      var scale = image.height >= image.width
          ? image.height / maxSize
          : image.width / maxSize;
      var height = scale > 1 ? (image.height / scale).round() : image.height;
      var width = scale > 1 ? (image.width / scale).round() : image.width;
      return await image.thumbDataWithSize(width, height, format: format);
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

  static pickAndUpload({
    int max = 1,
    RequestType type = RequestType.image,
    Color color,
  }) async {
    if (TkConfig().uploadUrl == null) throw ('必须设置uploadUrl才能上传文件');
    var list = await TkFile.pick(max: max, type: type, color: color);
    D(list);
    if (list == null) return null;
    List<Future<dynamic>> futures = [];
    list.forEach((element) {
      futures.add(TkFile.upload(element));
    });
    return await Future.wait(futures);
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

class CustomSortPathDelegate extends SortPathDelegate {
  const CustomSortPathDelegate();

  @override
  void sort(List<AssetPathEntity> list) {
    for (final AssetPathEntity entity in list) {
      if (assetsDirNames.containsKey(entity.name)) {
        entity.name = assetsDirNames[entity.name];
      }
    }
  }
}
