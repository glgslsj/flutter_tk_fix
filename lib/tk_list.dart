import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:collection/collection.dart';

class TkList extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  final bool animation;
  final double? height;
  final Duration duration;
  final String Function(int index)? keyGenerator;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? loadmore;
  final ScrollController? scrollController;
  final Widget? emptyWidget;

  const TkList({
    Key? key,
    this.children = const [],
    this.spacing = 0,
    this.animation = false,
    this.height,
    this.duration = const Duration(milliseconds: 250),
    this.keyGenerator,
    this.onRefresh,
    this.loadmore,
    this.scrollController,
    this.emptyWidget,
  }) : super(key: key);

  @override
  _TkListState createState() => _TkListState();
}

class _TkListState extends State<TkList> {
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  List<Widget> currentChildren = [];

  String Function(int index) get _keyGenerator =>
      widget.keyGenerator ?? indexKey;

  List<String> get listKeys => currentChildren
      .mapIndexed<String>((index, widget) => _keyGenerator(index))
      .toList();

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: index == widget.children.lastIndex ? 0 : widget.spacing),
      child: FadeTransition(
        opacity: animation.drive(Tween(begin: 0, end: 1)),
        // And slide transition
        child: widget.children[index],
      ),
    );
  }

  Widget buildRemoveAnimatedItem(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: index == widget.children.lastIndex ? 0 : widget.spacing),
      child: FadeTransition(
        opacity: animation.drive(Tween(begin: 0, end: 1)),
        // And slide transition
        child: child,
      ),
    );
  }

  String indexKey(int index) {
    return index.toString();
  }

  bool get showEmptyWidget {
    return widget.children.isEmpty && widget.emptyWidget != null;
  }

  void buildList() async {
    if (!widget.animation) return;
    await TkHelper.sleep(1);
    var eq = const ListEquality().equals;
    List<String> currentListKeys = widget.children
        .mapIndexed((index, widget) => _keyGenerator(index))
        .toList();
    if (eq(currentListKeys, listKeys)) return;
    List<String> delKeys = listKeys
        .filter((String element) => !currentListKeys.contains(element))
        .toList();
    for (var element in delKeys) {
      int index = listKeys.indexOf(element);
      int i = delKeys.indexOf(element);
      var child =
          currentChildren.length > index ? currentChildren[index] : null;
      if (child != null && animatedListKey.currentState != null) {
        animatedListKey.currentState!.removeItem(index - i,
            (context, animation) {
          return buildRemoveAnimatedItem(child, index, animation);
        }, duration: widget.duration);
      }
    }
    if (delKeys.isNotEmpty) await Future.delayed(widget.duration);
    var pushKeys =
        currentListKeys.filter((element) => !listKeys.contains(element));
    for (var k in pushKeys) {
      int index = currentListKeys.indexOf(k);
      animatedListKey.currentState!.insertItem(index, duration: widget.duration);
      await Future.delayed(widget.duration);
    }
    currentChildren = List.from(widget.children);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      buildList();
    });
  }

  @override
  void didUpdateWidget(covariant TkList oldWidget) {
    super.didUpdateWidget(oldWidget);
    buildList();
  }

  @override
  Widget build(BuildContext context) {
    var current = widget.animation
        ? AnimatedList(
            shrinkWrap: true,
            key: animatedListKey,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: buildAnimatedItem,
          )
        : TkFlex(
            children: widget.children,
            spacing: widget.spacing,
            column: true,
          );

    current = EasyRefresh.custom(
          scrollController: widget.scrollController,
          header: BezierCircleHeader(),
          footer: BezierBounceFooter(),
          onRefresh: widget.onRefresh,
          onLoad: widget.loadmore,
          shrinkWrap: widget.height != null,
          emptyWidget: showEmptyWidget ? Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: widget.emptyWidget!,
          ) : null,
          slivers: [SliverToBoxAdapter(
            child: current,
          )],
        );
    if (widget.height != null) {
      current = TkBox(height: widget.height, child: current,);
    }
    return current;
  }
}
