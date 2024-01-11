import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/user_avatar.dart';
import 'package:tencent_cloud_av_chat_room/utils/optimize_utils.dart';

class OnlineMemberSummary extends StatelessWidget {
  // const OnlineMemberSummary(
  //     {super.key, this.onlineMemberCount = 0, required this.memberAvatarList})
  //     : assert(memberAvatarList.length <= 3);
  final int onlineMemberCount;
  final List<String> memberAvatarList;

  const OnlineMemberSummary(
      {Key? key,
      required this.onlineMemberCount,
      required this.memberAvatarList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      children: [
        ...memberAvatarList.map(
          (e) => UserAvatar(
            url: e,
          ),
        ),
        if (memberAvatarList.length >= 3)
          UserAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: Text(
              _getOnlineMemberCount(),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 12.sp),
            ),
          )
      ],
    );
  }

  String _getOnlineMemberCount() {
    final count = onlineMemberCount.toString();
    final option1 = count.substring(0, count.length - 4);
    if (count.length >= 5) {
      return TIM_t_para("{{option1}} 万+", "$option1 万+")(
          option1: option1);
    }
    return count;
  }
}

class OnlineMember extends StatefulWidget {
  // const OnlineMember({super.key, required this.avChatRoomID});
  final String avChatRoomID;

  const OnlineMember({Key? key, required this.avChatRoomID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnlineMemberState();
}

class _OnlineMemberState extends State<OnlineMember> {
  int onlineMemberCount = 0;
  late V2TimGroupListener _groupListener;
  List<V2TimGroupMemberInfo?> memberAvatarList = [];

  @override
  void initState() {
    super.initState();

    /// getDefaultMemberList
    _getDefaultMemberList();

    /// get online member count
    _getOnlineMemberCount(widget.avChatRoomID);
    _addGroupListener();
  }

  @override
  void dispose() {
    super.dispose();
    _removeGroupListener();
  }

  @override
  Widget build(BuildContext context) {
    final avatarListString = memberAvatarList
        .map(
          (e) => e?.faceUrl ?? "",
        )
        .toList();
    return OnlineMemberSummary(
      memberAvatarList: avatarListString,
      onlineMemberCount: (memberAvatarList.length >= 3 && onlineMemberCount > 3)
          ? onlineMemberCount - 3
          : onlineMemberCount,
    );
  }

  _getOnlineMemberCount(String groupID) async {
    final onlineMemberResult = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupOnlineMemberCount(groupID: groupID);
    if (onlineMemberResult.code == 0) {
      onlineMemberCount = onlineMemberResult.data ?? 0;
    } else {
      onlineMemberCount = 0;
    }
    setState(() {});
  }

  _addGroupListener() {
    final onMemberEnterFunc =
        OptimizeUtils.throttle((List<V2TimGroupMemberInfo> memberList) {
      final enteredMember = List<V2TimGroupMemberInfo>.empty(growable: true);
      for (var member in memberList) {
        final isExisted = memberAvatarList
                .indexWhere((element) => element?.userID == member.userID) !=
            -1;
        if (!isExisted) {
          enteredMember.add(member);
        } else {
          debugPrint("is existed");
        }
      }

      memberAvatarList.addAll(enteredMember);
      final start =
          memberAvatarList.length < 3 ? 0 : memberAvatarList.length - 3;
      memberAvatarList = memberAvatarList.sublist(start);
      setState(() {});

      _getOnlineMemberCount(widget.avChatRoomID);
    }, 80);

    _groupListener = V2TimGroupListener(onMemberEnter: (groupID, memberList) {
      if (groupID == widget.avChatRoomID) {
        onMemberEnterFunc(memberList);
      }
    });

    TencentImSDKPlugin.v2TIMManager.addGroupListener(listener: _groupListener);
  }

  _removeGroupListener() {
    TencentImSDKPlugin.v2TIMManager
        .removeGroupListener(listener: _groupListener);
  }

  _getDefaultMemberList() async {
    final groupMemberListResult = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMemberList(
            groupID: widget.avChatRoomID,
            filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
            nextSeq: "0",
            count: 3);
    if (groupMemberListResult.code == 0) {
      final infoResult = groupMemberListResult.data;
      if (infoResult != null) {
        final memberInfoList = infoResult.memberInfoList ?? [];
        final formatedMemberList = memberInfoList.map((e) =>
            V2TimGroupMemberInfo(
                userID: e?.userID,
                nickName: e?.nickName,
                nameCard: e?.nameCard,
                friendRemark: e?.friendRemark,
                faceUrl: e?.faceUrl));
        memberAvatarList.addAll(formatedMemberList);
        memberAvatarList = memberAvatarList.sublist(
            memberAvatarList.length > 3 ? memberAvatarList.length - 3 : 0);
        setState(() {});
      }
    }
  }
}

class OnlineMemberList extends StatefulWidget {
  // const OnlineMemberList(
  //     {super.key, required this.avChatRoomID, this.onTapItem});
  final String avChatRoomID;
  final Function(BuildContext context, V2TimGroupMemberFullInfo member)?
      onTapItem;

  const OnlineMemberList({Key? key, required this.avChatRoomID, this.onTapItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnlineMemberListState();
}

class _OnlineMemberListState extends State<OnlineMemberList> {
  String nextSeq = "0";
  final List<V2TimGroupMemberFullInfo?> _groupMemberList = [];
  final List<Color> _indexColor = const [
    Color(0xFFFF465D),
    Color(0xFFFF8607),
    Color(0xFFFCAF41),
    Color(0xFF999999),
  ];

  @override
  void initState() {
    super.initState();
    _getMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.w,
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TIM_t("在线观众"),
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            TIM_t("观众信息"),
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF999999),
                fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16.w),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if (index == _groupMemberList.length - 1 && nextSeq != "0") {
                    _getMemberList();
                  }
                  final member = _groupMemberList[index];
                  if (member == null) {
                    return Container();
                  }

                  final displayIndex =
                      index <= 2 ? (index + 1).toString() : "-";
                  final displayIndexColor =
                      displayIndex == "-" ? _indexColor[3] : _indexColor[index];

                  return GestureDetector(
                    onTap: () {
                      if (widget.onTapItem != null) {
                        widget.onTapItem!(context, member);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.w),
                      child: Row(
                        children: [
                          Text(
                            displayIndex,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: displayIndexColor),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          UserAvatar(
                            width: 48,
                            height: 48,
                            url: member.faceUrl,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            _getMemberNickName(member) ?? "",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF333333)),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _groupMemberList.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  _getMemberList() async {
    final groupMemberListResult = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMemberList(
            groupID: widget.avChatRoomID,
            filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
            nextSeq: nextSeq);
    if (groupMemberListResult.code == 0) {
      final infoResult = groupMemberListResult.data;
      if (infoResult != null) {
        final memberInfoList = infoResult.memberInfoList ?? [];
        nextSeq = infoResult.nextSeq ?? "0";
        _groupMemberList.addAll(memberInfoList);
        setState(() {});
      }
    }
  }

  static String? _getMemberNickName(V2TimGroupMemberFullInfo e) {
    final friendRemark = e.friendRemark;
    final nameCard = e.nameCard;
    final nickName = e.nickName;
    final userID = e.userID;

    if (friendRemark != null && friendRemark != "") {
      return friendRemark;
    } else if (nameCard != null && nameCard != "") {
      return nameCard;
    } else if (nickName != null && nickName != "") {
      return nickName;
    } else {
      return userID;
    }
  }
}
