class AnchorInfo {
  AnchorInfo(
      {this.nickName = "",
      this.userID = "0",
      this.avatarUrl = "",
      this.fansNum = 0,
      this.subscribeNum = 0});

  final String nickName;
  final String userID;
  final String avatarUrl;
  final int fansNum;
  final int subscribeNum;

  AnchorInfo copyWith(
      {String? nickName,
      String? avatarUrl,
      int? fansNum,
      int? subscribeNum,
      String? userID}) {
    return AnchorInfo(
        nickName: nickName ?? this.nickName,
        userID: userID ?? this.userID,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        fansNum: fansNum ?? this.fansNum,
        subscribeNum: subscribeNum ?? this.subscribeNum);
  }
}
