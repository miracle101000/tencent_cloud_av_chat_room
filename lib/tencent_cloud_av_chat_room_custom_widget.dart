import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class TencentCloudAvChatRoomCustomWidgets {
  TencentCloudAvChatRoomCustomWidgets(
      {this.roomHeaderAction,
      this.roomHeaderLeading,
      this.roomHeaderTag,
      this.onlineMemberListPanelBuilder,
      this.anchorInfoPanelBuilder,
      this.messageItemBuilder,
      this.giftMessageBuilder,
      this.messageItemPrefixBuilder,
      this.textFieldActionBuilder,
      this.giftsPanelBuilder,
      this.textFieldDecoratorBuilder});

  /// A widget to display at the top right of the screen
  final Widget? roomHeaderAction;

  /// A widget to display at the top left of the screen
  final Widget? roomHeaderLeading;

  /// A widget to display under the [roomHeaderAction] and [roomHeaderLeading]
  final Widget? roomHeaderTag;

  /// Customize the online member list panel
  /// when tap the avatar of online member will show panel.
  final Widget Function(BuildContext context, String groupID)?
      onlineMemberListPanelBuilder;

  /// Customize the anchor info panel.
  /// when tap the subscribe button will show panel.
  final Widget Function(BuildContext context, String groupID)?
      anchorInfoPanelBuilder;

  /// Customize the message sent by users.
  final Widget Function(
          BuildContext context, V2TimMessage message, Widget child)?
      messageItemBuilder;

  /// Customize gifts messages.
  final Widget Function(BuildContext context, V2TimMessage message)?
      giftMessageBuilder;

  /// Customize message item prefix. such as user level.
  final Widget Function(BuildContext context, V2TimMessage message)?
      messageItemPrefixBuilder;

  /// Customize text field decorator.
  /// A widget to display at the bottom left of the screen. text field will be focused when tap it.
  final Widget Function(BuildContext context)? textFieldDecoratorBuilder;

  /// Customize text field actions.
  /// Some widgets to disply at the bottom right of the screen. such as gift button.
  final List<Widget> Function(BuildContext context)? textFieldActionBuilder;

  /// Customize gifs panel.
  /// Tap the gifs action will show this panel.
  final Widget Function(BuildContext context)? giftsPanelBuilder;
}
