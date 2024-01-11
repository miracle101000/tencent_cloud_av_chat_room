class MessageConfig {
  MessageConfig(
      {this.isGetMessageListBeforeJoinGroup = false,
      this.showNickName = true,
      this.showTitle = true,
      this.isUseGroupCounter = false});
  late final bool isGetMessageListBeforeJoinGroup;
  late final bool isUseGroupCounter;
  late final bool showNickName;
  late final bool showTitle;
}
