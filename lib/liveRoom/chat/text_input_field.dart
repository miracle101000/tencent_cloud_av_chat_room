import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';

class TextInputField extends StatefulWidget {
  // const TextInputField(
  //     {super.key,
  //     this.onSubmit,
  //     this.controller,
  //     this.hintText = "说点啥...",
  //     required this.action,
  //     required this.decortaor});
  final void Function(String text)? onSubmit;
  final TextEditingController? controller;
  final String hintText;
  final List<Widget> Function(BuildContext context) action;
  final Widget Function(BuildContext context) decortaor;

  const TextInputField(
      {Key? key,
      this.onSubmit,
      this.controller,
      required this.hintText,
      required this.action,
      required this.decortaor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  bool showTextFieldLabel = true;
  bool isKeyBoardShow = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyBoardShow = visible;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    keyboardSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (isKeyBoardShow) {
      showTextFieldLabel = false;
    }
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: isKeyBoardShow ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          onEnd: () {
            showTextFieldLabel = true;
            setState(() {});
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 10.w),
              child: RoundedContainer(
                color: const Color(0xFFf3f3f3),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    try {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(value);
                      }
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                    _controller.clear();
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                  ),
                  // style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.merge(TextStyle(fontSize: 14.sp, color: Colors.black)),
                ),
              ),
            ),
          ),
        ),
        if (!isKeyBoardShow && showTextFieldLabel)
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isKeyBoardShow) {
                      _focusNode.requestFocus();
                    }
                  },
                  child: widget.decortaor(context),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.action(context)))
              ],
            ),
          )
      ],
    );
  }
}
