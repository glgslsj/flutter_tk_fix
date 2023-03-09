import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_tk_example/form_page.dart';
import 'package:flutter_tk_example/list.dart';
import 'package:flutter_tk_example/page.dart';
import 'package:get/get.dart';

class PageLink {
  final String title;
  final Widget page;

  PageLink(this.title, this.page);
}

List<PageLink> pages = [
  PageLink('列表', ListScreen()),
  PageLink('页面', PageScreen()),
  PageLink('其他', FormPage()),
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return TkPage(
      appBar: AppBar(
        title: T('widget列表'),
      ),
      child: ListView(
        children: pages.map((e) => ListTile(title: T(e.title), onTap: () { Get.to(e.page); },)).toList(),
      ),
    );
  }
}