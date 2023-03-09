import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';

class PageScreen extends StatefulWidget {
  PageScreen({Key key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  Widget build(BuildContext context) {
    return TkPage(
      // immersive: true,
      backgroundColor: Colors.amberAccent,
      floatAppBar: true,
      onShow: () {
        D('onShow');
      },
      onHide: () {
        D('onHide');
      },
      appBar: TkBox(
        height: 44,
        alignment: Alignment.center,
        child: T('TkPage'),
      ),
      child: TkList(
        children: [
          TkBox(
            height: 300,
            color: Colors.red,
            ripple: true,
            onPressed: () {},
          ),
          TkBox(
            height: 300,
            ripple: true,
            onPressed: () {},
            border: Border.all(color: TkColor('blue')),
          )
        ],
      ),
    );
  }
}
