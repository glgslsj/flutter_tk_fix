import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_tk/tk_image.dart';
import 'package:flutter_tk/tk_log.dart';
import 'package:flutter_tk/tk_page.dart';
import 'package:fbutton/fbutton.dart';
import 'package:get/get.dart';

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TkPage(
      child: ListView(
        children: [
          Center(
            child: TkImage('http://moke-store.oss-cn-beijing.aliyuncs.com/8aee5751-a357-421f-a145-f3caa7357bbe.png',
              width: 300,
              height: 150,
            ),
          ),
          T(GetPlatform.isMobile.toString(), weight: FontWeight.bold,),
          // LiveList(
          // ),
          TkFlex(
            spacing: 10,
            wrap: true,
            children: List.generate(16, (index) => TkBox(
              color: TkColor('red').withOpacity(0.1),
              col: 1/3,
              colOnTablet: 1/4,
              colOnDesktop: 1/6,
              ratio: 1/2,
              elevation: 2,
              onPressed: () {
                D(index);
              },
            )),
          ),
          FButton(
            text: 'test',
            onPressed: () async {
              // var rs = await TkFile.pickAndUpload();
              // D(rs);
            },
          ),
          // TkPicker(data: List.generate(10, (index) => TkPickerItem(index)),)
        ],
      ),
    );
  }
}
