import 'package:flutter/material.dart';

class SlidingTransition extends StatefulWidget {
  final Widget child;
  final AnimationController controller;
  final Offset begin;
  final Offset end;
  const SlidingTransition({Key? key, required this.child, required this.controller, required this.begin, required this.end}) : super(key: key);

  @override
  State<SlidingTransition> createState() => _SlidingTransitionState();
}

class _SlidingTransitionState extends State<SlidingTransition> with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = Tween<Offset>(begin: widget.begin, end: widget.end, ).animate(CurvedAnimation(
        parent: widget.controller,
        curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
          position: animation,
          child: widget.child,
      ),
    );
  }
}
