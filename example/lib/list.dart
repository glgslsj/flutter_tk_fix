import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var l = 5;

  @override
  Widget build(BuildContext context) {
    return TkPage(
      appBar: AppBar(
        title: T('TkList'),
      ),
      bottomNavigationBar: TkFlex(
          children: [
            IconButton(
                onPressed: () {
                  l+=5;
                  setState(() {});
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  l-=5;
                  setState(() {});
                },
                icon: Icon(Icons.clear)),
          ]
      ),
      child: TkList(
        // height: 300,
        emptyWidget: Icon(Icons.emoji_emotions_sharp),
        spacing: 5,
        animation: true,
        loadmore: () async {
          await TkHelper.sleep(800);
          setState(() {
            l+=5;
          });
          },
        children: List.generate(
            l,
            (index) => TkBox(
                  child: T(index.toString()),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  color: TkColor('gray').withOpacity(0.3),
                )),
      ),
    );
  }
}
